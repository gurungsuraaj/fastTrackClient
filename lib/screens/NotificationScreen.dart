import 'dart:async';

import 'package:fasttrackgarage_app/database/AppDatabase.dart';
import 'package:fasttrackgarage_app/models/NotificationDbModel.dart';
import 'package:fasttrackgarage_app/models/NotificationModel.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/TimeAgo.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notificationList = [];
  Completer<void> _refreshCompleter;
  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ExtraColors.scaffoldColor),
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: Color(ExtraColors.appBarColor),
        title: Center(
            child: Text("NOTIFICATIONS",
                style: TextStyle(fontStyle: FontStyle.italic))),
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () {
        //       notificationList = [];
        //       getDataFromDB();
        //     },
        //     icon: Icon(Icons.refresh),
        //   )
        // ],
      ),
      body:
          // Container(
          //   margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
          //   child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Expanded(
          //                 child: Text(
          //                   "HAPPY NEW YEAR ",
          //                   style: TextStyle(
          //                     color: Color(ExtraColors.orange),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Text(
          //                   "Just now",
          //                   style: TextStyle(
          //                     color: Color(ExtraColors.orange),
          //                   ),
          //                 ),
          //               ),
          //               // Text(
          //               //     "${notificationList[index].notificationTitle} "),
          //               // Text(timeAgoSinceDate(
          //               //     notificationList[index].dateTime))
          //             ],
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Text(
          //             "FASTTRACK WISHES A HAPPY NEW YEAR ",
          //             style: TextStyle(
          //               color: Colors.white,
          //             ),
          //           ),

          //           // Text(
          //           //
          //           //   "${notificationList[index].notificationBody} "),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Divider(
          //             color: Color(ExtraColors.orange),
          //             thickness: 0.9,
          //           ),
          //         ],
          //       )),
          // )
          notificationList.length == 0
              ? Center(
                  child: Text(
                    "Notification List is empty",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: notificationList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${notificationList[index].notificationTitle} ",
                                      style: TextStyle(
                                          color: Color(ExtraColors.orange)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      timeAgoSinceDate(
                                          notificationList[index].dateTime),
                                      style: TextStyle(
                                          color: Color(ExtraColors.orange)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${notificationList[index].notificationBody} ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Divider(
                                color: Color(ExtraColors.orange),
                                height: 10,
                              ),
                            ],
                          )),
                    );
                  }),
    );
  }

  Future<void> getDataFromDB() async {
    DateTime currentTime = DateTime.now();
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    await database.notificationDao.findAllNotification().then((res) async {
      for (NotificationDbModel item in res) {
        DateTime notifcationDate = DateTime.parse(item.dateTime);

        final difference = currentTime.difference(notifcationDate).inDays;

        if (difference > 2) {
          await database.notificationDao.deleteNotification(item.id);
        } else {
          NotificationModel model = NotificationModel();
          model.id = item.id;
          model.notificationTitle = item.notificationTitle;
          model.notificationBody = item.notificationBody;
          model.dateTime = item.dateTime;
          notificationList.add(model);
        }
      }
      setState(() {});
      return _refreshCompleter.future;
    }).catchError((err) {});
  }
}
