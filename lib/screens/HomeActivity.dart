import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/Promo.dart';
import 'package:fasttrackgarage_app/models/UserList.dart';
import 'package:fasttrackgarage_app/screens/GoogleMap.dart';
import 'package:fasttrackgarage_app/screens/LocateActivity.dart';
import 'package:fasttrackgarage_app/screens/OfferPromo.dart';
import 'package:fasttrackgarage_app/screens/ShopNGo.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
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

class _HomeActivityState extends State<HomeActivity> {
  List<UserList> userList = List();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Promo> promoList = new List<Promo>();
  String customerNumber;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  NTLMClient client;
  double userLong, userLatitude; //  For location of client user
  bool isProgressBarShown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);

    // _messaging.getToken().then((token) {
    //   print("Your FCM Token is : $token");
    // });
    // suraj();
    getPrefs().then((val) {
      getLocationOfCLient();
    });
  }

  void getLocationOfCLient() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(
        "THis is the location latitude ${position.latitude}  location :${position.latitude}");

    userLong = position.longitude;
    userLatitude = position.latitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Home'),
          automaticallyImplyLeading: false,
          backgroundColor: Color(ExtraColors.DARK_BLUE),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          child: new Center(
            child: new GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                padding: const EdgeInsets.all(15.0),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 4.0,
                children: <Widget>[
                  Card(
                      child: Container(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceHistoryActivity()),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/setting.png",
                                    height: 70,
                                    width: 50,
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("Service History"))
                                ],
                              )))),
                  Card(
                      child: Container(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OutletActivity()),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/outlet.png",
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
                                      builder: (context) => CheckInventory()),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/cart.png",
                                    height: 70,
                                    width: 50,
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("Inventory Check"))
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfferPromo()),
                                );
                                //showOffer();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/offer.png",
                                    height: 70,
                                    width: 50,
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("offers & Promotions"))
                                ],
                              )))),
                  Card(
                      child: Container(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ServiceActivity()),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/service.png",
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => GoogleMapActivity()),
                                // );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocateActivity()),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/locate.png",
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/cart.png",
                                    height: 70,
                                    width: 50,
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("Shop N Go"))
                                ],
                              )))),
                ]),
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
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        height: queryData.size.height * 0.5,
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: queryData.size.width,
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
                    width: queryData.size.width * 0.4,
                    child: RaisedButton(
                      onPressed: () {
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
    showDialog(context: context, child: dialog);
  }

  showOffer() async {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get("http://www.fasttrackemarat.com/feed/updates.json",
            headers: header)
        .then((res) {
      int status = res.statusCode;

      if (status == Rcode.SUCCESS_CODE) {
        var result = json.decode(res.body);
        var values = result["promo"] as List;
        promoList = values.map<Promo>((json) => Promo.fromJson(json)).toList();
        debugPrint("${promoList[0].name}");
        AlertDialog dialog = new AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: queryData.size.height * 0.36,
            child: Column(
              children: <Widget>[
                Container(
                  width: queryData.size.width,
                  color: Color(ExtraColors.DARK_BLUE),
                  child: Image.network(
                    promoList[0].banner,
                    fit: BoxFit.fill,
                    height: 160,
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text(
                          promoList[0].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                        child: Text(
                          promoList[0].details,
                          style: TextStyle(
                            color: Colors.black,
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
        showDialog(context: context, child: dialog);
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
    showProgressBar();
    NetworkOperationManager.getAdminUserList(client).then((val) {
      debugPrint("This is the response $val");
      hideProgressBar();
      setState(() {
        userList = val;
      });
      print("This is the first token ${val[0].token}");
      calculateDistance();
    }).catchError((err) {
      hideProgressBar();
      print("There is an error: $err");
    });
  }

  void calculateDistance() async {
    showProgressBar();
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
            showInSnackBar("Something went wrong while sending alert");
          }
        });
      } else {
        print("Failure in sending notification");
      }
    });
  }

  Future<String> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    customerNumber = await prefs.getString((Constants.customerMobileNumber));
    debugPrint(" this is mobile number$customerNumber");
    //  return serviceOrderNum;
  }
}
