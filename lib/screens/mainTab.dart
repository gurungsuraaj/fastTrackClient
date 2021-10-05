import 'dart:io';

import 'package:fasttrackgarage_app/database/AppDatabase.dart';
import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/NotificationScreen.dart';
import 'package:fasttrackgarage_app/screens/UsersProfileActivity.dart';
import 'package:fasttrackgarage_app/screens/WebViewScreen.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrimaryKeyGenerator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainTab extends StatefulWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int bottomSelectedIndex = 0;
  var bottomTabBarText = TextStyle(fontSize: 12);

  PageController pageController;

  final FirebaseMessaging _messaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var googleID;
  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    _messaging.getToken().then((token) {
      debugPrint("Your FCM Token is : $token");
    });

    _messaging.subscribeToTopic('Notification');
    _messaging.requestNotificationPermissions();
    _messaging.configure(
      onMessage: (Map<String, dynamic> msg) {
        print("Inside message ------------------- $msg");

        if (Platform.isAndroid) {
          showBackGroundNotification(msg['data']['title'], msg['data']['body']);
        } else {
          if (googleID == msg['google.c.sender.id']) {
            googleID = null;
          } else {
            if (googleID == null) {
              googleID = msg['google.c.sender.id'];
            }
            showBackGroundNotification(msg['title'], msg['body']);
          }
        }
      },
      onLaunch: (Map<String, dynamic> msg) async {
        if (Platform.isAndroid) {
          saveBackgorundNotificatonDataOnDB(
              msg['data']['title'], msg['data']['body']);
        } else {
          saveBackgorundNotificatonDataOnDB(msg['title'], msg['body']);
        }
      },
      onResume: (Map<String, dynamic> msg) async {
        if (Platform.isAndroid) {
          saveBackgorundNotificatonDataOnDB(
              msg['data']['title'], msg['data']['body']);
        } else {
          if (googleID == msg['google.c.sender.id']) {
            print("Do nothing");
            googleID = null;
            setState(() {});
          } else {
            if (googleID == null) {
              setState(() {
                googleID = msg['google.c.sender.id'];
              });
            }

            saveBackgorundNotificatonDataOnDB(msg['title'], msg['body'])
                .whenComplete(() {
              Future.delayed(const Duration(seconds: 3), () => googleID = null);
            });
          }
        }
      },
      // onBackgroundMessage: onBackgroundMessage
    );

    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      debugPrint('called from local notificaiton');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: Container(
        
        
        child: BottomNavigationBar(
           type: BottomNavigationBarType.fixed,
          
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomeActivity(),
        UsersProfileActivity(),
        WebViewScreen(),
        NotificationScreen(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> 
  
  buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        backgroundColor: Color(0xff19378d),
        icon: new Icon(
          Icons.home,
          color: Color(0xff88acd0),
        ),
        activeIcon: new Icon(
          Icons.home,
          color: Color(0xffef773c),
        ),
        // label:'Home'
        label: '',

        //  Padding(
        //   padding: const EdgeInsets.only(top: 2.0),
        //   child: new Text(
        //     'Home',
        //     style: bottomTabBarText,
        //   ),
        // )
      ),
      BottomNavigationBarItem(
        backgroundColor: Color(0xff19378d),
          icon: Icon(Icons.person, color: Color(0xff88acd0),),
          activeIcon: new Icon(
          Icons.person,
          color: Color(0xffef773c),
        ),
          // label: 'Profile'
          label: '',

          // title: Padding(
          //   padding: const EdgeInsets.only(top: 2.0),
          //   child: Text(
          //     'Profile',
          //     style: bottomTabBarText,
          //   ),
          // )
          ),
      BottomNavigationBarItem(
        backgroundColor: Color(0xff19378d),
          icon: new Icon(Icons.public, color: Color(0xff88acd0),),
          activeIcon: new Icon(
          Icons.public,
          color: Color(0xffef773c),
        ),
          // label: 'Web'
          label: '',
          // title: Padding(
          //   padding: const EdgeInsets.only(top: 2.0),
          //   child: new Text(
          //     'Web',
          //     style: bottomTabBarText,
          //   ),
          // ),
          ),
      BottomNavigationBarItem(
        backgroundColor: Color(0xff19378d),
        icon: new Icon(Icons.notifications,color: Color(0xff88acd0),),
        activeIcon: new Icon(
          Icons.notifications,
          color: Color(0xffef773c),
        ),
        // label: 'Notifications',
        label: '',
        // title: Padding(
        //   padding: const EdgeInsets.only(top: 2.0),
        //   child: new Text(
        //     'Notifications',
        //     style: bottomTabBarText,
        //   ),
        // ),
      ),
    ];
  }

  void bottomTapped(int index) {
    debugPrint("this is index");
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
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

  showBackGroundNotification(String title, String body) async {
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

    // if (Platform.isAndroid) {
    //   await flutterLocalNotificationsPlugin.show(0, msg['data']['title'],
    //       msg['data']['body'], platformChannelSpecifics,
    //       payload: 'item x');
    // } else if (Platform.isIOS) {
    //   await flutterLocalNotificationsPlugin.show(
    //       0, msg['title'], msg['body'], platformChannelSpecifics,
    //       payload: 'item x');
    // }

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');

    saveBackgorundNotificatonDataOnDB(title, body).whenComplete(() {});
  }

  // Future onBackgroundMessage(Map<String, dynamic> message) async {
  //   print("on background messae");
  //   debugPrint(message.toString());
  //   showBackGroundNotification(message);
  // }

  void saveNotificatonDataOnDB(Map<String, dynamic> msg) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    NotificationDbModel notification = new NotificationDbModel(1, "", "", "");
    notification.id = PrimaryKeyGenerator.generateKey();
    notification.notificationTitle = msg['notification']['title'];
    notification.notificationBody = msg['notification']['body'];
    notification.dateTime = DateTime.now().toString();
    await database.notificationDao.insertNotification(notification);
  }

  Future<void> saveBackgorundNotificatonDataOnDB(
      String title, String body) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    NotificationDbModel notification = new NotificationDbModel(1, "", "", "");
    notification.id = PrimaryKeyGenerator.generateKey();

// if(Platform.isAndroid){
//   notification.notificationTitle = msg['data']['title'];
//   notification.notificationBody = msg['data']['body'];
// }else if(Platform.isIOS){
//     notification.notificationTitle = msg['title'];
//   notification.notificationBody = msg['body'];
// }

    notification.notificationTitle = title;
    notification.notificationBody = body;

    notification.dateTime = DateTime.now().toString();
    await database.notificationDao.insertNotification(notification);
  }
}
