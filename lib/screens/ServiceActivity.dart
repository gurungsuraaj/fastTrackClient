import 'package:fasttrackgarage_app/screens/ServiceDetailActivity.dart';
import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
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
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
//    getServiceList();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWithTitle.getAppBar('Services'),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: Container(
          child:   new GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(15.0),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 4.0,
              children: <Widget>[
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailActivity("Air Conditioning")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/air-conditioning.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Air-Conditioning"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailActivity("Brakes")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/brakes.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Brakes"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailActivity("Electrics")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/electrics.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Electrics"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceDetailActivity("Oil Filter")),
                              );
//showOffer();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/oil-filter.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Oil Filter"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) =>
                                  ServiceDetailActivity("Servicing")));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/servicing.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Servicing"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
// Navigator.push(
//   context,
//   MaterialPageRoute(
//       builder: (context) => GoogleMapActivity()),
// );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailActivity("Steering")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/steering.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Steering"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceDetailActivity("Suspension")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/suspension.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Suspension"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailActivity("Tone Up")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/tone-up.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Tone-up"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailActivity("Tyre-S")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/tyre-s.png",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Tyre-S"))
                              ],
                            )))),
                Card(
                    child: Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailActivity("Other")),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/other.gif",
                                  height: 70,
                                  width: 50,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text("Other"))
                              ],
                            )))),


              ]),


            // For later dynamic list
//
//          GridView.builder(
//              padding: const EdgeInsets.all(15.0),
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                childAspectRatio: 1.9,
//                mainAxisSpacing: 5.0,
//                crossAxisSpacing: 4.0,
//              ),
//              itemCount: serviceList.length,
//              itemBuilder: (BuildContext context, int index) {
//                return GestureDetector(
//                  onTap: (){
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) =>
//                              ServiceDetailActivity(serviceList[index])),
//                    );
//                  },
//                  child: Card(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          padding: EdgeInsets.all(15),
//                          child: Column(
//                            children: <Widget>[
//                              SizedBox(
//                                width: 15,
//                              ),
//                              Icon(
//                                Icons.settings,
//                                color: Color(ExtraColors.DARK_BLUE),
//                                size: 35,
//                              ),
//                              // Image(
//                              //   height: imageHeight,
//                              //   width: imageWidth,
//                              //   image: AssetImage('images/maintenance_icon.png'),
//                              // ),
//                              SizedBox(
//                                width: 25,
//                              ),
//                              Text(
//                                serviceList[index],
//                                style: TextStyle(
//                                    fontSize: 18, fontWeight: FontWeight.bold),
//                              ),
//                            ],
//                          ),
//                        ),
//
//                      ],
//                    ),
//                  ),
//                );
//              }),
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
      int status = res.statusCode;
      if (status == Rcode.SUCCESS_CODE) {
        var result = json.decode(res.body);
        var values = result["facilities"] as List;
        String services = values[0]["services"];
        hideProgressBar();

        setState(() {
          serviceList = services.split(",");
        });
      } else {
        displaySnackbar(context, "An error has occured");
      }
    });
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
