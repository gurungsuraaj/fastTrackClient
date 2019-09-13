import 'package:fasttrackgarage_app/screens/ServiceHistoryPieChart.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceHistoryActivity extends StatefulWidget {
  @override
  _ServiceHistoryActivityState createState() => _ServiceHistoryActivityState();
}

class _ServiceHistoryActivityState extends State<ServiceHistoryActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service history"),
        backgroundColor: Color(ExtraColors.DARK_BLUE),
      ),
      body: Column(
        children: <Widget>[
          //\n  19 May 2019
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ServiceHistoryPieChart()),
              );
            },
            child: ListTile(
              title: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  "Bur Dubai",
                  style: TextStyle(color: Color(ExtraColors.DARK_BLUE)),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "DEC123400001",
                        style: TextStyle(color: Colors.black),
                      )),
                  Text(
                    "19 May 2019",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Colors.grey),
                  )
                ],
              ),
              isThreeLine: true,
              trailing: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "AED 120.4",
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          ),
          new Divider(
            color: Colors.black,
          ),
          ListTile(
            onTap: () {},
            title: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                "Bur Dubai",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "DEC123400001",
                      style: TextStyle(color: Colors.black),
                    )),
                Text(
                  "19 May 2019",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.grey),
                )
              ],
            ),
            isThreeLine: true,
            trailing: Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "AED 120.4",
                  style: TextStyle(color: Colors.red),
                )),
          ),
          new Divider(
            color: Colors.black,
          ),
          ListTile(
            onTap: () {},
            title: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                "Bur Dubai",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "DEC123400001",
                      style: TextStyle(color: Colors.black),
                    )),
                Text(
                  "19 May 2019",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.grey),
                )
              ],
            ),
            isThreeLine: true,
            trailing: Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "AED 120.4",
                  style: TextStyle(color: Colors.red),
                )),
          ),
          new Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
