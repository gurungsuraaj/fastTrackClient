import 'dart:convert';

import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/models/ServiceHistoryItem.dart';
import 'package:fasttrackgarage_app/screens/ServiceHistoryPieChart.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class ServiceHistoryActivity extends StatefulWidget {
  @override
  _ServiceHistoryActivityState createState() => _ServiceHistoryActivityState();
}

class _ServiceHistoryActivityState extends State<ServiceHistoryActivity> {

  String basicToken = "";
  List<ServiceHistoryItem> serviceHistoriesList = new List<ServiceHistoryItem>();

  @override
  void initState() {
    super.initState();

    PrefsManager.getBasicToken().then((token){
      basicToken = token;
      getServiceHistoryList();
    });
  }


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

  void getServiceHistoryList() async{

    String url = Api.SERVICE_HISTORY_LIST;
    debugPrint("This is  url : $url");

    String customerNo = "CS000001";

    Map<String, String> body = {
      "Field": "Customer_No",
      "Criteria": customerNo,
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "username": "PSS",
      "password": "\$ky\$p0rt\$",
      "url":
      "http://202.166.211.230:7747/DynamicsNAV/ws/FT%20Support/Page/ServiceLedger",
      "Authorization": "$basicToken"
    };

    await http.post(url, body: body_json, headers: header).then((res) {
      debugPrint("This is body: ${res.body}");
      int statusCode = res.statusCode;

      var data = json.decode(res.body);

      String message = data['message'];
      debugPrint(">>message $message");

      if(statusCode == Rcode.SUCCESS_CODE){

        var values = data["data"] as List;
        debugPrint(">>>values $values");

        serviceHistoriesList = values.map<ServiceHistoryItem>((json) => ServiceHistoryItem.fromJson(json)).toList();
      }
      else {
        ShowToast.showToast(context, message);
      }
    }).catchError((val) {
      debugPrint("error $val");
      ShowToast.showToast(context, "Something went wrong!");
    });



  }
}
