import 'dart:convert';

import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'GoogleMap.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import '../models/OutletList.dart';

class OutletActivity extends StatefulWidget {
  @override
  _OutletActivity createState() => _OutletActivity();
}

class _OutletActivity extends State<OutletActivity> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProgressBarShown = false;
  List<OutletList> outletlist = new List<OutletList>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOutletList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Outlet"),
        backgroundColor: Color(ExtraColors.DARK_BLUE),
      ),
      body: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: outletlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  //\n  19 May 2019

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleMapActivity()),
                      );
                    },
                    child: ListTile(
                      onTap: null,
                      title: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          outletlist[index].Name,
                          style: TextStyle(color: Color(ExtraColors.DARK_BLUE)),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                outletlist[index].Address,
                              )),
                          Text(
                            outletlist[index].City,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(
                          Icons.location_on,
                          size: 55,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  new Divider(
                    color: Colors.black,
                  ),
                ],
              );
            },
          )),
    );
  }

  getOutletList() async {
    showProgressBar();
    String url = Api.LOCCATION_LIST;
    debugPrint("---url---$url");

    Map<String, String> body = {"Key": "", "Code": "", "Name": ""};
    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "username": "PSS",
      "password": "\$ky\$p0rt\$",
      "url":
          "http://202.166.211.230:7747/DynamicsNAV/ws/FT%20Support/Page/LocationList",
    };
    await http.post(url, body: body_json, headers: header).then((res) {
      hideProgressBar();
      debugPrint("this is status code ${res.statusCode}");
      var result = json.decode(res.body);
      var values = result['data'] as List;

      if (res.statusCode == Rcode.SUCCESS_CODE) {
        outletlist = values
            .map<OutletList>((json) => OutletList.fromJson(json))
            .toList();
      }
    }).catchError((onError) {
      debugPrint("$onError");
    });
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
}
