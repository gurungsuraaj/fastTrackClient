import 'package:fasttrackgarage_app/database/AppDatabase.dart';
import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/Promo.dart';
import 'package:fasttrackgarage_app/models/UserList.dart';
import 'package:fasttrackgarage_app/models/person.dart';
import 'package:fasttrackgarage_app/screens/GoogleMap.dart';
import 'package:fasttrackgarage_app/screens/LocateActivity.dart';
import 'package:fasttrackgarage_app/screens/OfferPromo.dart';
import 'package:fasttrackgarage_app/screens/PostedSalesInvoiceScreen.dart';
import 'package:fasttrackgarage_app/screens/ShopNGo.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/PrefsManager.dart';
import 'CheckInventory.dart';
import 'LoginActivity.dart';
import 'ServiceHistoryActivity.dart';
import 'OutletActivity.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'InventoryCheckActivity.dart';
import 'ServiceActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return HomeActivity();
  }
}

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> with AutomaticKeepAliveClientMixin<HomeActivity> {
  @override
  bool get wantKeepAlive => true;
  List<UserList> userList = List();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Promo> promoList = new List<Promo>();
  String customerNumber;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  NTLMClient client;
  double userLong, userLatitude; //  For location of client user
  bool isProgressBarShown = false;
  List<Placemark> placemark = List<Placemark>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);

     _messaging.getToken().then((token) {
       print("Your FCM Token is : $token");
     });
    // ignore: missing_return

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    // ignore: missing_return
    _messaging.configure(onMessage: (Map<String, dynamic> msg) {
      showNotification(msg);
    });


    getPrefs().then((val) async {
      getLocationOfCLient();
      showOffer();
    });

  }
  showNotification(Map<String, dynamic> msg) async {

//    print("this is message $msg");
//
//    var android = new AndroidNotificationDetails(
//      'sdffds dsffds',
//      "CHANNLE NAME",
//      "channelDescription",
//    );
//    var iOS = new IOSNotificationDetails();
//    var platform = new NotificationDetails(android, iOS);
//    await flutterLocalNotificationsPlugin.show(
//        0, msg['notification']['title'],msg['notification']['body'], platform);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,  msg['notification']['title'], msg['notification']['body'], platformChannelSpecifics,
        payload: 'item x');
  }

  void getLocationOfCLient() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    placemark = await Geolocator().placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    print(
        "THis is the location latitude ${position.latitude}  location :${position.longitude}");

    userLong = position.longitude;
    userLatitude = position.latitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Container(
            height: 35,
            child: TextField(
//  controller: _textFieldController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  hintText: "Search...",
                  icon: Image.asset(
                    'images/fastTrackSingleLogo.png',
                    height: 30,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor))),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(ExtraColors.DARK_BLUE_ACCENT),
          actions: <Widget>[
//            PopupMenuButton<String>(
//              onSelected: choiceAction,
//              itemBuilder: (BuildContext context) {
//                return Constants.choices.map((String choice) {
//                  return PopupMenuItem<String>(
//                    value: choice,
//                    child: Text(choice),
//                  );
//                }).toList();
//              },
//            )
          ],
        ),
        body: SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: isProgressBarShown,
            child: new Center(
                child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  color: Color(ExtraColors.DARK_BLUE),
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            placemark.isEmpty
                                ? Text(
                                    "Loading...",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "${placemark[0].name.toString()}",
                                    style: TextStyle(color: Colors.white),
                                  )
                          ],
                        ),
                      ),
                      Text(
                        "Change",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                promoList.isEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 190,
                        color: Colors.grey[300],
                      )
                    : CarouselSlider(
                        enlargeCenterPage: true,
//                  autoPlay: true,
//                  autoPlayInterval: Duration(seconds: 1),
                        height: 200.0,
                        items: promoList.map((i) {
                          print("${i.banner}");
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
//                                decoration: BoxDecoration(
//                                  color: Color(
//                                    0xFF1D1E33,
//                                  ),
//                                  borderRadius: BorderRadius.circular(20),
//                                ),
                                child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(11.0),
                                  child: Image.network(
                                    i.image,
                                    fit: BoxFit.fitHeight,
                                    height: 190,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                new GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    padding: const EdgeInsets.all(15.0),
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 4.0,
                    children: <Widget>[
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) =>
//                                              ServiceActivity()),
//                                    );
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => ServiceActivity()));

                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/ServicesLogo.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Service"))
                                    ],
                                  )))),
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostedSalesInvoiceScreen()),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/ServiceHistory.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Invoice Sales"))
                                    ],
                                  )))),
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OutletActivity()),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/outletLogo.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Outlet List"))
                                    ],
                                  )))),
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OfferPromo()),
                                    );
//showOffer();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/promotionLogo.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Promotions"))
                                    ],
                                  )))),
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
                                    _showAlert();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/distressCall.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Distress Call"))
                                    ],
                                  )))),
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
// Navigator.push(
//   context,
//   MaterialPageRoute(
//       builder: (context) => GoogleMapActivity()),
// );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LocateActivity()),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/LocationLogo.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Locate"))
                                    ],
                                  )))),
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShopAndGo()),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/shopAndGo.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Shop N Go"))
                                    ],
                                  )))),
                      Card(
                          child: Container(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CheckInventory()),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "images/inventoryLogo.png",
                                        height: 70,
                                        width: 50,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("Inventory Check"))
                                    ],
                                  )))),
                    ]),
              ],
            )),
          ),
        ));
  }

  void choiceAction(String choice) {
    if (choice == Constants.LOGOUT) {
      PrefsManager.clearSession().then((val) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginActivity()),
            ModalRoute.withName("/Login"));
      });
    }
  }

  void _showAlert() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 290,
            child: Column(
              children: <Widget>[
                Container(
                  height: 120,
//                  width: queryData.size.width,
                  color: Color(ExtraColors.DARK_BLUE),
                  child: Center(
                      child: Image.asset(
                        "images/message.png",
                        height: 90,
                      )),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                        child: Text("Need Help?"),
                      ),
                      Container(
                        width: 120,
                        child: RaisedButton(
                          onPressed: () {
                            print("Hello");
                            Navigator.pop(context);

                            getUserList();
                          },
                          color: Colors.blue[700],
                          child: Text(
                            'SEND ALERT',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );


//
//
//    queryData = MediaQuery.of(context);
//    AlertDialog dialog = new AlertDialog(
//      contentPadding: EdgeInsets.all(0.0),
//      content: Container(
//        height: queryData.size.height * 0.5,
//        child: Column(
//          children: <Widget>[
//            Container(
//              height: 120,
//              width: queryData.size.width,
//              color: Color(ExtraColors.DARK_BLUE),
//              child: Center(
//                  child: Image.asset(
//                "images/message.png",
//                height: 90,
//              )),
//            ),
//            Container(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Container(
//                    padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
//                    child: Text("Need Help?"),
//                  ),
//                  Container(
//                    width: queryData.size.width * 0.4,
//                    child: RaisedButton(
//                      onPressed: () {
//                        Navigator.pop(context);
//
//                        getUserList();
//                      },
//                      color: Colors.blue[700],
//                      child: Text(
//                        'SEND ALERT',
//                        style: TextStyle(
//                          color: Colors.white,
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//    showDialog(context: context, child: dialog);
  }

  showOffer() async {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
//    await http
//        .get("http://www.fasttrackemarat.com/feed/updates.json",
//            headers: header)

    //This is the new API for list of banners for the home page
    await http
        .get("https://www.fasttrackemarat.com/feed/images.json",
        headers: header)
        .then((res) {
      int status = res.statusCode;

      if (status == Rcode.SUCCESS_CODE) {
        var result = json.decode(res.body);
        var values = result["sliders"] as List;

        setState(() {
          promoList =
              values.map<Promo>((json) => Promo.fromJson(json)).toList();
        });
      } else {
        displaySnackbar(context, "An error has occured ");
      }
    });
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(minutes: 1),
      content: new Text(value),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.blue,
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    ));
  }

  void showProgressBar() {
    setState(() {
      isProgressBarShown = true;
    });
  }

  void hideProgressBar() {
    setState(() {
      isProgressBarShown = false;
    });
  }

  getUserList() async {
//    showProgressBar();
    NetworkOperationManager.getAdminUserList(client).then((val) {
      debugPrint("This is the response $val");
//      hideProgressBar();
      setState(() {
        userList = val;
      });
      print("This is the first token ${val[0].token}");
      calculateDistance();
    }).catchError((err) {
//      hideProgressBar();
      print("There is an error: $err");
    });
  }

  void calculateDistance() async {
//    showProgressBar();
    List<UserList> calculatedDistanceList = [];
    List<double> distList = [];

    debugPrint("This is user location $userLong");

    for (UserList item in userList) {
      double longitude = double.parse(item.longitude);
      double latitude = double.parse(item.latitude);
      debugPrint("long $longitude , lat : $latitude");

      double distanceInMeters = await Geolocator()
          .distanceBetween(userLatitude, userLong, latitude, longitude);
      // item.distanceInMeter = distanceInMeters;
      // calculatedDistanceList.add(item);
      // print("THis is from geolocator $distanceInMeters");
      distList.add(distanceInMeters);

      // var result = calculatedDistanceList
      //     .map((item) => (item.distanceInMeter))
      //     .reduce(min);
      // print("this is result $result");

      // distList.reduce(min);
    }
    int shortDistanceIndex = distList.indexOf(distList.reduce(min));
    print("This is the index $shortDistanceIndex");

    var shortDistanceToken = userList[shortDistanceIndex].token;
    print("This is the token $shortDistanceToken");
    String cusName = userList[shortDistanceIndex].userId;
    // print("Shorest distnace ${calculatedDistanceList.reduce(min)}");

    // calculatedDistanceList.reduce((item, index) => (item.distanceInMeter));

    NetworkOperationManager.sendNotification(shortDistanceToken).then((res) {
//      hideProgressBar();
      print(
          "status ${res.status} , response body ${res.responseBodyForFireBase["success"]}");
      if (res.responseBodyForFireBase["success"] == 1) {
        print("Notification has been sent");
        NetworkOperationManager.distressCall(customerNumber, cusName, client)
            .then((res) {
          hideProgressBar();
          if (res.status == Rcode.SUCCESS_CODE) {
            showInSnackBar(
                "Send alert successfully ! You will get call from the nearest branch ");
          } else {
//            showInSnackBar("Something went wrong while sending alert");
            showInSnackBar(
                "Send alert successfully ! You will get call from the nearest branch ");
          }
        });
      } else {
//        showInSnackBar("Failure in sending notification");
        showInSnackBar(
            "Send alert successfully ! You will get call from the nearest branch ");
      }
    }).catchError((err) {
//      hideProgressBar();
      ShowToast.showToast(context, " Error : $err");
    });
  }

  Future<String> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    customerNumber = await prefs.getString((Constants.CUSTOMER_MOBILE_NO));


    //  return serviceOrderNum;
  }
}

//Extra COde
//
//
