import 'dart:io';

import 'package:fasttrackgarage_app/database/AppDatabase.dart';
import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/LocateModel.dart';
import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:fasttrackgarage_app/models/Promo.dart';
import 'package:fasttrackgarage_app/models/UserList.dart';
import 'package:fasttrackgarage_app/screens/LocateActivity.dart';
import 'package:fasttrackgarage_app/screens/NextServiceDateScreen.dart';
import 'package:fasttrackgarage_app/screens/OfferPromo.dart';
import 'package:fasttrackgarage_app/screens/PostedSalesInvoiceScreen.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/PrimaryKeyGenerator.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoder/geocoder.dart';
import 'package:ntlm/ntlm.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/PrefsManager.dart';
import 'InquiryListScreen.dart';
import 'LoginActivity.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'ServiceActivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeActivity();
  }
}

const APP_STORE_URL =
    'https://apps.apple.com/us/app/pokhara-food-delivery/id1487359029?ls=1';
const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=pokharafooddelivery.nipuna';

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity>
    with AutomaticKeepAliveClientMixin<HomeActivity> {
  @override
  bool get wantKeepAlive => true;
  List<UserList> userList = [];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Promo> promoList = <Promo>[];
  String customerNumber;
  // final FirebaseMessaging _messaging = FirebaseMessaging();
  NTLMClient client;
  double userLong, userLatitude; //  For location of client user
  bool isProgressBarShown = false;
  // List<Placemark> placemark = List<Placemark>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  List<double> branchDistanceList = [];
  List<LocateModel> branchList = [];
  int shortDistanceIndex;
  double androidVersion, iosVersion;
  var userCurrentLocation;

  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.ntlmUsername, Constants.ntlmPassword);

    // _messaging.getToken().then((token) {
    //   print("Your FCM Token is : $token");
    // });
    // // ignore: missing_return

    // var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    // var ios = new IOSInitializationSettings();
    // var platform = new InitializationSettings(android, ios);
    // flutterLocalNotificationsPlugin.initialize(platform);

    // // ignore: missing_return
    // _messaging.configure(
    //   onMessage: (Map<String, dynamic> msg) {
    //     print("Inside message -------------------");
    //     showNotification(msg);
    //   },
    //   onLaunch: (Map<String, dynamic> msg) async {
    //     print(msg);
    //     print("on launch");
    //   },
    //   onResume: (Map<String, dynamic> msg) async {
    //     print(msg);
    //     print("on resume");
    //   },
    // );

    getPrefs().then((val) async {
      getLocationOfCLient().whenComplete(() {
        fetchBranchList();

        // Enable the code when the app is pushed to the appstore
        checkVersionUpdate();
      });
      showOffer();
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, msg['notification']['title'],
        msg['notification']['body'], platformChannelSpecifics,
        payload: 'item x');

    saveNotificatonDataOnDB(msg);
  }

  Future<void> getLocationOfCLient() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    userCurrentLocation =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    userLong = position.longitude;
    userLatitude = position.latitude;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Container(
              height: 35,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'images/fastTrackSingleLogo.png',
                        height: 30,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "   My Fasttrack",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          )))
                ],
              )),
          automaticallyImplyLeading: false,
          backgroundColor: Color(ExtraColors.darkBlueAccent),
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
          child: new Center(
              child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                color: Color(ExtraColors.darkBlue),
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
                          userCurrentLocation == null
                              ? Text(
                                  "Loading...",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  "${userCurrentLocation.first.featureName}",
                                  style: TextStyle(color: Colors.white),
                                )
                        ],
                      ),
                    ),
                    Text(
                      "",
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
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                      ),

                      //                  autoPlay: true,
                      //                  autoPlayInterval: Duration(seconds: 1),
                      // height: 200.0,
                      items: promoList.map((i) {
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
                                  fit: BoxFit.cover,
                                  // height: BoxFit.fitHeight,
                                  // width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
              Wrap(
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,

                  // new GridView.count(
                  // physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  // crossAxisCount: 2,
                  // childAspectRatio: 1,
                  // padding: const EdgeInsets.all(15.0),
                  // mainAxisSpacing: 10.0,
                  // crossAxisSpacing: 4.0,
                  children: <Widget>[
                    Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
                            child: InkWell(
                                onTap: () {
                                  //                                    Navigator.push(
                                  //                                      context,
                                  //                                      MaterialPageRoute(
                                  //                                          builder: (context) =>
                                  //                                              ServiceActivity()),
                                  //                                    );
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ServiceActivity()));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/service1.png",
                                      height: 90,
                                      width: 60,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text("Services"))
                                  ],
                                )))),
                    Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/invoiceSales1.png",
                                      height: 100,
                                      width: 80,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text("Check History"))
                                  ],
                                )))),
                    // Card(
                    //     child: Container(
                    //         child: InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         OutletActivity()),
                    //               );
                    //             },
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.center,
                    //               children: <Widget>[
                    //                 Image.asset(
                    //                   "images/outletLogo.png",
                    //                   height: 70,
                    //                   width: 50,
                    //                 ),
                    //                 Container(
                    //                     padding: EdgeInsets.only(top: 5),
                    //                     child: Text("Outlet List"))
                    //               ],
                    //             )))),
                    Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
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
                                      "images/promotions1.png",
                                      height: 90,
                                      width: 60,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text("Promotions"))
                                  ],
                                )))),
                    Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NextServiceDateScreen()),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/inquiry.png",
                                      height: 90,
                                      width: 60,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "Next Service Date",
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                )))),

                    Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
                            child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => GoogleMapActivity()),
                                  // );

                                  getLocationOfCLient().whenComplete(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LocateActivity(
                                                userLat: userLatitude,
                                                userLong: userLong,
                                              )),
                                    );
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/locate1.png",
                                      height: 90,
                                      width: 60,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text("Locate A Branch"))
                                  ],
                                )))),

                    Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
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
                                            InquiryListScreen()),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/inquiry1.png",
                                      height: 90,
                                      width: 60,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text("Make An Inquiry"))
                                  ],
                                )))),

                    Card(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
                            child: InkWell(
                                onTap: () {
                                  getLocationOfCLient().whenComplete(() {
                                    _showAlert();
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "images/distress.png",
                                      height: 90,
                                      width: 60,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text("Distress Call"))
                                  ],
                                )))),

                    // Card(
                    //     child: Container(
                    //         child: InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) => ShopAndGo()),
                    //               );
                    //             },
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.center,
                    //               children: <Widget>[
                    //                 Image.asset(
                    //                   "images/shopAndGo.png",
                    //                   height: 70,
                    //                   width: 50,
                    //                 ),
                    //                 Container(
                    //                     padding: EdgeInsets.only(top: 5),
                    //                     child: Text("Shop N Go"))
                    //               ],
                    //             )))),
                    // Card(
                    //     child: Container(
                    //         child: InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) =>
                    //                         CheckInventory()),
                    //               );
                    //             },
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.center,
                    //               children: <Widget>[
                    //                 Image.asset(
                    //                   "images/inventoryLogo.png",
                    //                   height: 70,
                    //                   width: 50,
                    //                 ),
                    //                 Container(
                    //                     padding: EdgeInsets.only(top: 5),
                    //                     child: Text("Inventory Check"))
                    //               ],
                    //             )))),
                  ]),
            ],
          )),
        ));
  }

  void choiceAction(String choice) {
    if (choice == Constants.logout) {
      PrefsManager.clearSession().then((val) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginActivity()),
            ModalRoute.withName("/Login"));
      });
    }
  }

  void _showAlert() {
    // MediaQueryData queryData;
    // queryData = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 400,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 120,
                    //                  width: queryData.size.width,
                    color: Color(ExtraColors.darkBlue),
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
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pop(context);

                              getUserList();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[700],
                            ),
                            child: Text(
                              'SEND ALERT',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: Text('By clicking this button,nearest location will call you within half an hour'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "OR",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  String nearestPhoneNo = SpUtil.getString(
                                          Constants.nearestStorePhoneNo)
                                      .replaceAll(
                                          new RegExp(r"\s+\b|\b\s"), "");
                                  var url = "tel:$nearestPhoneNo";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Image.asset(
                                  "images/call.png",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  String whatappNO = SpUtil.getString(
                                      Constants.whatsAppNumber);
                                  print("Whats app number $whatappNO");
                                  var whatsappUrl =
                                      "whatsapp://send?phone=$whatappNO";
                                  await canLaunch(whatsappUrl)
                                      ? launch(whatsappUrl)
                                      : showAlert();
                                },
                                child: Image.asset(
                                  "images/whatsapp.png",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
    //              color: Color(ExtraColors.darkBlue),
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
    //                    child: ElevatedButton(
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

  showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            Container(
              width: 100,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                // color: Colors.blue[700],
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ),
          ],
          content: Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                        child: Text(
                            "There is no whatsapp installed on your mobile device"),
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
  }

  showOffer() async {
    // MediaQueryData queryData;
    // queryData = MediaQuery.of(context);
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

      if (status == Rcode.successCode) {
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

  displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      duration: Duration(minutes: 1),
      content: new Text(value),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.blue,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
    NetworkOperationManager.getAdminUserList(client).then((val) async {
      debugPrint("This is the response $val");
      hideProgressBar();
      setState(() {
        userList = val;
      });

      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (isLocationEnabled != false) {
        calculateDistance();
      } else {
        Navigator.pop(context);
        showInSnackBar("Couldn't locate your position. Is your GPS turned on?");
      }
    }).catchError((err) {
      hideProgressBar();
    });
  }

  void calculateDistance() async {
    //    showProgressBar();
    // List<UserList> calculatedDistanceList = [];
    List<double> distList = [];

    debugPrint("This is user location $userLatitude $userLong");

    for (UserList item in userList) {
      double longitude = double.parse(item.longitude);
      double latitude = double.parse(item.latitude);
      debugPrint("");

      double distanceInMeters = Geolocator.distanceBetween(
          userLatitude, userLong, latitude, longitude);
      // item.distanceInMeter = distanceInMeters;
      // calculatedDistanceList.add(item);
      // print("THis is from geolocator $distanceInMeters");

      print(
          "Username ${item.userId} Distance in meters $distanceInMeters  long $longitude , lat : $latitude");
      distList.add(distanceInMeters);

      // var result = calculatedDistanceList
      //     .map((item) => (item.distanceInMeter))
      //     .reduce(min);
      // print("this is result $result");

      // distList.reduce(min);
    }
    int shortDistanceIndex = distList.indexOf(distList.reduce(min));

    var shortDistanceToken = userList[shortDistanceIndex].token;
    String cusName = userList[shortDistanceIndex].userId;
    // print("Shorest distnace ${calculatedDistanceList.reduce(min)}");

    // calculatedDistanceList.reduce((item, index) => (item.distanceInMeter));

    NetworkOperationManager.sendNotification(shortDistanceToken).then((res) {
      //      hideProgressBar();

      // print("${res.responseBodyForFireBase["results"][0]['']}")
      // print(
      //     "Response +++++++++++++++++++++++++++++++++ ${res.responseBodyForFireBase["success"].toString()}");
      Navigator.pop(context);

      if (res.responseBodyForFireBase["success"] == 1) {
        print("Notification has been sent");
        NetworkOperationManager.distressCall(customerNumber, cusName, client)
            .then((res) {
          hideProgressBar();
          if (res.status == Rcode.successCode) {
            showInSnackBar(
                "Send alert successfully ! You will get call from the nearest branch ");
          } else {
            //            showInSnackBar("Something went wrong while sending alert");
            showInSnackBar("Error: ${res.responseBody}");
          }
        });
      } else {
        //        showInSnackBar("Failure in sending notification");
        showInSnackBar("There was a problem sending notification");
      }
    }).catchError((err) {
      //      hideProgressBar();
      print(err);
      ShowToast.showToast(context, " Error : $err");
    });
  }

  Future<void> getPrefs() async {
    customerNumber = SpUtil.getString((Constants.customerMobileNo));
    //  return serviceOrderNum;
  }

  void saveNotificatonDataOnDB(Map<String, dynamic> msg) async {
    print(DateTime.now().toString());
    print("${msg['notification']['title']} ${msg['notification']['body']}");
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    NotificationDbModel notification = new NotificationDbModel(1, "", "", "");
    notification.id = PrimaryKeyGenerator.generateKey();
    notification.notificationTitle = msg['notification']['title'];
    notification.notificationBody = msg['notification']['body'];
    notification.dateTime = DateTime.now().toString();
    await database.notificationDao.insertNotification(notification);
  }

  Future<void> fetchBranchList() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get('http://www.fasttrackemarat.com/feed/updates.json',
            headers: header)
        .then((res) {
      hideProgressBar();
      int status = res.statusCode;
      if (status == Rcode.successCode) {
        var result = json.decode(res.body);
        var value = result["branches"] as List;

        branchList = value
            .map<LocateModel>((json) => LocateModel.fromJson(json))
            .toList();

        calculateDistanceForPhone();
      } else {
        hideProgressBar();
      }
    }).catchError((err) {
      print("Error $err ");
      hideProgressBar();
    });
  }

  void calculateDistanceForPhone() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    print("!!!!!!!!!!!!!!!!!!!! $isLocationEnabled");
    if (isLocationEnabled != false) {
      for (LocateModel branch in branchList) {
        var location = branch.latlng.split(",");
        double branchLatitude = double.parse(location[0]);
        double branchLongitude = double.parse(location[1]);

        double distanceInMeters = Geolocator.distanceBetween(position.latitude,
            position.longitude, branchLatitude, branchLongitude);

        branchDistanceList.add(distanceInMeters);
      }
      shortDistanceIndex =
          branchDistanceList.indexOf(branchDistanceList.reduce(min));

      SpUtil.putString(Constants.nearestStorePhoneNo,
          "${branchList[shortDistanceIndex].telephone}");
      SpUtil.putString(Constants.whatsAppNumber,
          "${branchList[shortDistanceIndex].whatsAppNum}");
      // print(
      //     "the shorted distance is ${branchList[shortDistanceIndex].telephone}");

      // var shortestDistancebranch =
      // branchList[shortDistanceIndex].latlng.split(",");
      // shortDistBranchlat = double.parse(shortestDistancebranch[0]);
      // shortDistBranchLong = double.parse(shortestDistancebranch[1]);

      setState(() {
        // _center = LatLng(shortDistBranchlat, shortDistBranchLong);
      });
    } else {
      Navigator.pop(context);

      showInSnackBar("Couldn't locate your position. Is your GPS turned on?");
    }

    hideProgressBar();
    // zoomInMarker();
  }

  void checkVersionUpdate() async {
    NetworkOperationManager.getCompanyInfo(client).then((res) async {
      if (res.length > 0) {
        double newVersionNo;

        final PackageInfo info = await PackageInfo.fromPlatform();
        androidVersion =
            double.parse(res[0].androidVersion.trim().replaceAll(".", ""));
        iosVersion =
            double.parse(res[0].iOSversionNo.trim().replaceAll(".", ""));
        // double newVersionNo =
        //     double.parse(res[0].androidVersion.trim().replaceAll(".", ""));
        double currentVersion =
            double.parse(info.version.trim().replaceAll(".", ""));

        if (Platform.isIOS) {
          print("iosversion $iosVersion");
          newVersionNo = iosVersion;
        } else {
          newVersionNo = androidVersion;
        }
        print(
            "New version $newVersionNo and $currentVersion ${res[0].appStoreUrl} ${res[0].playStoreUrl}");

        if (newVersionNo > currentVersion) {
          _showVersionDialog(context, res[0].appStoreUrl, res[0].playStoreUrl);
        }
      }
    }).catchError((err) {
      displaySnackbar(context, err);
    });
  }

  _showVersionDialog(context, String appStoreUrl, String playStoreUrl) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      btnLabel,
                      style: TextStyle(color: Color(0xFF007AFF)),
                    ),
                    onPressed: () => _launchURL(appStoreUrl)
                    //  StoreRedirect.redirect(androidAppId: "com.ebt.ftclient",
                    // iOSAppId: "1487359029")
                    ,
                  ),
                  TextButton(
                    child: Text(btnLabelCancel,
                        style: TextStyle(color: Color(0xFF007AFF))),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(playStoreUrl),
                  ),
                  TextButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
