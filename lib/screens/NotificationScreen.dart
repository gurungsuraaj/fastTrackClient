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
  List<NotificationModel> notificationList = List();
  Completer<void> _refreshCompleter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshCompleter = Completer<void>();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(ExtraColors.darkBlueAccent),
        title: Text("Notifications"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              notificationList = [];
              getDataFromDB();
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: notificationList.length == 0
          ? Center(
              child: Text("Notification List is empty"),
            )
          : ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: notificationList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Title : ${notificationList[index].notificationTitle} "),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "Message Body : ${notificationList[index].notificationBody} ")
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(timeAgoSinceDate(
                                      notificationList[index].dateTime))
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
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
