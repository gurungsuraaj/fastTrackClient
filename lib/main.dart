import 'dart:async';
import 'dart:io';

import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:fasttrackgarage_app/screens/CheckInventory.dart';
import 'package:fasttrackgarage_app/screens/GenerateOTPActivity.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/InventoryCheckActivity.dart';
import 'package:fasttrackgarage_app/screens/OTPActivity.dart';
import 'package:fasttrackgarage_app/screens/OutletActivity.dart';
import 'package:fasttrackgarage_app/screens/ServiceActivity.dart';
import 'package:fasttrackgarage_app/screens/ServiceHistoryActivity.dart';
import 'package:fasttrackgarage_app/screens/SignUpActivity.dart';
import 'package:fasttrackgarage_app/screens/StoreLocationScreen.dart';
import 'package:fasttrackgarage_app/screens/app.dart';
import 'package:fasttrackgarage_app/screens/mainTab.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrimaryKeyGenerator.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/screens/LoginActivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'database/AppDatabase.dart';

//GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
final FirebaseMessaging _messaging = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _messaging.getToken().then((token) {
    debugPrint("Your FCM Token is : $token");
  });
  _messaging.subscribeToTopic('Notification');
  _messaging.requestNotificationPermissions();
  _messaging.configure(
      onMessage: (Map<String, dynamic> msg) {
        print("Inside message ------------------- $msg");
        // showNotification(msg);
        showBackGroundNotification(msg);
      },
      onLaunch: (Map<String, dynamic> msg) async {
        print(msg);
        print("on launch");
      },
      onResume: (Map<String, dynamic> msg) async {
        print(msg);
        print("on resume");
        saveBackgorundNotificatonDataOnDB(msg);
        //  showBackGroundNotification(msg);
      },
      onBackgroundMessage: onBackgroundMessage);

  var initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    debugPrint('called from local notificaiton');
  });
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

showNotification(Map<String, dynamic> msg) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fcm_default_channel',
      'default_notification_channel_id',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, msg['notification']['title'],
      msg['notification']['body'], platformChannelSpecifics,
      payload: 'item x');

  saveNotificatonDataOnDB(msg);
}

showBackGroundNotification(Map<String, dynamic> msg) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fcm_default_channel',
      'default_notification_channel_id',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

// print("Local notification ${msg['aps']['alert']}");

  if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.show(
      0, msg['data']['title'], msg['data']['body'], platformChannelSpecifics,
      payload: 'item x');
  } else if (Platform.isIOS) {
  await flutterLocalNotificationsPlugin.show(
      0, msg['title'], msg['body'], platformChannelSpecifics,
      payload: 'item x');
  }

  // await flutterLocalNotificationsPlugin.show(0, msg['aps']['alert']['title'],
  //     msg['aps']['alert']['body'], platformChannelSpecifics,
  //     payload: 'item x');

  saveBackgorundNotificatonDataOnDB(msg);
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

void saveBackgorundNotificatonDataOnDB(Map<String, dynamic> msg) async {
  print(DateTime.now().toString());

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  NotificationDbModel notification = new NotificationDbModel(1, "", "", "");
  notification.id = PrimaryKeyGenerator.generateKey();

if(Platform.isAndroid){
  notification.notificationTitle = msg['data']['title'];
  notification.notificationBody = msg['data']['body'];
}else if(Platform.isIOS){
    notification.notificationTitle = msg['title'];
  notification.notificationBody = msg['body'];
}


  notification.dateTime = DateTime.now().toString();
  await database.notificationDao.insertNotification(notification);
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
                  "My FastTrack",
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

Future onBackgroundMessage(Map<String, dynamic> message) async {
  print("on background messae");
  debugPrint(message.toString());
  showBackGroundNotification(message);
}
