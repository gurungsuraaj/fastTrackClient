import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class ServiceActivity extends StatefulWidget {
  @override
  _ServiceActivityState createState() => _ServiceActivityState();
}

class _ServiceActivityState extends State<ServiceActivity> {
  var textDecoration = TextDecoration.underline;
  var fontSize = 18.0;
  var imageWidth = 35.0;
  var imageHeight = 35.0;
  var checkBoxVal = false;
  var checkboxVal2 = false;
  var checkboxVal3 = false;
  var listHeight = 170.0;
  List serviceList = new List();
  bool isProgressBarShown = false;

  @override
  void initState() {
    super.initState();
    getServiceList();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBarWithTitle.getAppBar('Services'),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: Container(
          child: ListView.builder(
              itemCount: serviceList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.settings,
                            color: Color(ExtraColors.DARK_BLUE),
                            size: 35,
                          ),
                          // Image(
                          //   height: imageHeight,
                          //   width: imageWidth,
                          //   image: AssetImage('images/maintenance_icon.png'),
                          // ),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            serviceList[index],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                  ],
                );
              }),
        ),
      ),
    );
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

  getServiceList() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    await http
        .get("http://www.fasttrackemarat.com/feed/updates.json",
            headers: header)
        .then((res) {
      var result = json.decode(res.body);
      var values = result["facilities"] as List;
      String services = values[0]["services"];
      setState(() {
        serviceList = services.split(",");
      });
      hideProgressBar();
      debugPrint("$serviceList");
    });
  }
}
