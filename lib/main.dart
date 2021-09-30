import 'dart:async';
import 'package:fasttrackgarage_app/screens/GenerateOTPActivity.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/InventoryCheckActivity.dart';
import 'package:fasttrackgarage_app/screens/OTPActivity.dart';
import 'package:fasttrackgarage_app/screens/OutletActivity.dart';
import 'package:fasttrackgarage_app/screens/ServiceActivity.dart';
import 'package:fasttrackgarage_app/screens/ServiceHistoryActivity.dart';
import 'package:fasttrackgarage_app/screens/SignUpActivity.dart';
import 'package:fasttrackgarage_app/screens/StoreLocationScreen.dart';
import 'package:fasttrackgarage_app/screens/mainTab.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/screens/LoginActivity.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:flutter/material.dart';

//GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();
  // await FlutterConfig.loadValueForTesting({'AES_KEY': '9z\$C&F)J@McQfTjW'});

  await SpUtil.getInstance();
  print("Log ${FlutterConfig.get("AES_KEY").toString()}");

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
        appBarTheme: AppBarTheme(
          backwardsCompatibility: false, // 1
          systemOverlayStyle: SystemUiOverlayStyle.light, // 2
        ),
      ),
      
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        RoutesName.login: (BuildContext context) => new LoginActivity(),
        RoutesName.signUp: (BuildContext context) => new SignUpActivity(),
        RoutesName.otp: (BuildContext context) =>
            new OTP(query: '', mode: 0, signature: ''),
        RoutesName.generateOtp: (BuildContext context) => new GenerateOTP(),
        RoutesName.home: (BuildContext context) => new Home(),
        RoutesName.checkInventory: (BuildContext context) =>
            new InventoryCheckActivity(),
        RoutesName.outlet: (BuildContext context) => new OutletActivity(),
        RoutesName.serviceHistory: (BuildContext context) =>
            new ServiceHistoryActivity(),
        RoutesName.service: (BuildContext context) => new ServiceActivity(),
        RoutesName.mainTab: (BuildContext context) => new MainTab(),
        RoutesName.storeLocation: (BuildContext context) =>
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

    basicToken = SpUtil.getString(Constants.customerNo);
    debugPrint("this is basicToke $basicToken");
    if (basicToken == null || basicToken.isEmpty) {
      print("Inside the null check condition");
      Navigator.of(context).pushReplacementNamed(RoutesName.login);
    } else {
      print("Inside the else condition");
      Navigator.of(context).pushReplacementNamed(RoutesName.mainTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff253882),
      floatingActionButton: Container(
          child: Text(
        "All rights reserved © 2020",
        style: TextStyle(color: Colors.white),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: null,
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/car.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  "My Fasttrack",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      // fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ),
              Divider(
                indent: 100,
                endIndent: 100,
                color: Colors.orange,
                thickness: 1.5,
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Text(
                      "YOUR CAR GARAGE",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          // fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "IN YOUR ",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              // fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                        Text(
                          "MOBILE",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              // fontStyle: FontStyle.italic,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 90),
                width: 170,
                child: new Image.asset(
                  'images/fastTrack_launcher.png',
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
