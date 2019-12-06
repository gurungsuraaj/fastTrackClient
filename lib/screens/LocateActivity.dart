import 'dart:convert';

import 'package:fasttrackgarage_app/models/LocateModel.dart' as prefix0;
import 'package:fasttrackgarage_app/screens/GoogleMap.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models//LocateModel.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LocateActivity extends StatefulWidget {
  LocateActivity({Key key}) : super(key: key);

  @override
  _LocateActivityState createState() => _LocateActivityState();
}

class _LocateActivityState extends State<LocateActivity> {
  List<LocateModel> locationlist = List<LocateModel>();
  bool isProgressBarShown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBranchList();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
    return Scaffold(
        appBar: AppBar(
          title: Text("Locate"),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          child: ListView.builder(
            itemCount: locationlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child:
                                        Text("Branch Name :", style: textStyle),
                                  ),
                                  Container(
                                    child: Text(locationlist[index].name,
                                        style: textStyle),
                                  ),
                                ],
                              ),
                              Wrap(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Address : ${locationlist[index].address}",
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Telephone No. :",
                                      style: textStyle,
                                    ),
                                  ),
                                  Container(
                                    child: Text(locationlist[index].telephone,
                                        style: textStyle),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Opening Hours :",
                                      style: textStyle,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                        locationlist[index].openinghours,
                                        style: textStyle),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        var location = locationlist[index]
                                            .latlng
                                            .split(",");
                                        double longitude =
                                            double.parse(location[0]);
                                        double latitude =
                                            double.parse(location[1]);
                                        debugPrint(
                                            "here is the location $longitude , $latitude");

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GoogleMapActivity(
                                                     longitude,latitude)),
                                        );
                                      },
                                      child: Text(
                                        "Find Branch",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Divider(
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ));
  }

  getBranchList() async {
    String url = "";
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    final response = await http
        .get('http://www.fasttrackemarat.com/feed/updates.json',
            headers: header)
        .then((res) {
      int status = res.statusCode;

      if (status == Rcode.SUCCESS_CODE) {
        hideProgressBar();
        var result = json.decode(res.body);
        var branches = result['branches'] as List;
        debugPrint("$branches");

        locationlist = branches
            .map<LocateModel>((json) => LocateModel.fromJson(json))
            .toList();
      } else {
        hideProgressBar();
      }
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
