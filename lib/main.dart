import 'dart:async';
import 'dart:io';

import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:fasttrackgarage_app/screens/CheckInventory.dart';
import 'package:fasttrackgarage_app/screens/GenerateOTPActivity.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/InquiryDetailScreen.dart';
import 'package:fasttrackgarage_app/screens/InventoryCheckActivity.dart';
import 'package:fasttrackgarage_app/screens/NextServiceDateScreen.dart';
import 'package:fasttrackgarage_app/screens/OTPActivity.dart';
import 'package:fasttrackgarage_app/screens/OutletActivity.dart';
import 'package:fasttrackgarage_app/screens/PostedSalesInvoiceScreen.dart';
import 'package:fasttrackgarage_app/screens/ServiceActivity.dart';
import 'package:fasttrackgarage_app/screens/ServiceHistoryActivity.dart';
import 'package:fasttrackgarage_app/screens/SignUpActivity.dart';
import 'package:fasttrackgarage_app/screens/StoreLocationScreen.dart';
import 'package:fasttrackgarage_app/screens/UsersProfileActivity.dart';
import 'package:fasttrackgarage_app/screens/WebViewScreen.dart';
import 'package:fasttrackgarage_app/screens/app.dart';
import 'package:fasttrackgarage_app/screens/mainTab.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrimaryKeyGenerator.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/screens/LoginActivity.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'database/AppDatabase.dart';

//GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        RoutesName.LOGIN_ACTIVITY: (BuildContext context) =>
            new LoginActivity(),
        RoutesName.SIGNUP_ACTIVITY: (BuildContext context) =>
            new SignUpActivity(),
        RoutesName.OTP_ACTIVITY: (BuildContext context) =>
            new OTP(query: '', mode: 0, signature: ''),
        RoutesName.GENERATE_OTP_ACTIVITY: (BuildContext context) =>
            new GenerateOTP(),
        RoutesName.HOME_ACTIVITY: (BuildContext context) => new Home(),
        RoutesName.CHECK_INVENTORY: (BuildContext context) =>
            new InventoryCheckActivity(),
        RoutesName.OUTLET_ACTIVITY: (BuildContext context) =>
            new OutletActivity(),
        RoutesName.SERVICE_HISTORY_ACTIVITY: (BuildContext context) =>
            new ServiceHistoryActivity(),
        RoutesName.SERVICE_ACTIVITY: (BuildContext context) =>
            new ServiceActivity(),
        RoutesName.MAIN_TAB: (BuildContext context) => new MainTab(),
        RoutesName.STORE_LOCATION: (BuildContext context) =>
            new StoreLocationScreen(),
      },
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    // String location = prefs.getString(Constants.location);
    String basicToken;

    final prefs = await SharedPreferences.getInstance();
    basicToken = prefs.getString(Constants.CUSTOMER_NUMBER);

    if (basicToken == null || basicToken == "") {
      print("Inside the null check condition");
      Navigator.of(context).pushReplacementNamed(RoutesName.LOGIN_ACTIVITY);
    } else {
      print("Inside the else condition");
      Navigator.of(context).pushReplacementNamed(RoutesName.MAIN_TAB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff253882),
      floatingActionButton: Container(
          child: Text(
        "All right reserved © 2020",
        style: TextStyle(color: Colors.white),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: null,
      body: Container(
          height: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  "My Fasttrack",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ),
              Container(
                width: 240,
                child: new Image.asset(
                  'images/fastTrackSplashLogo.png',
                ),
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                      ) //Your widget here,
                      )),
              //            Expanded(
              //              child: Container(
              ////                color: Colors.white,
              //                padding: EdgeInsets.only(bottom: 65),
              //                child: Row(
              //                  mainAxisAlignment: MainAxisAlignment.center,
              //                crossAxisAlignment: CrossAxisAlignment.end,
              //                  children: <Widget>[
              //                    Text(
              //                      "All right reserve © 2020",
              //                      style:
              //                      TextStyle(color: Colors.white),
              //                    ),
              //
              //                  ],
              //                ),
              //              ),
              //            ),
            ],
          )),
    );
  }
}
