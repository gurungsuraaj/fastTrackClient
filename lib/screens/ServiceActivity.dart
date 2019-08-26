import 'package:fasttrackgarage_app/utils/AppBarWithTitle.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class ServiceActivity extends StatefulWidget {
  @override
  _ServiceActivityState createState() => _ServiceActivityState();
}

class _ServiceActivityState extends State<ServiceActivity> {
  var textDecoration = TextDecoration.underline;
  var fontSize = 18.0;
  var imageWidth = 50.0;
  var imageHeight = 50.0;
  var checkBoxVal = false;
  var checkboxVal2 = false;
  var checkboxVal3 = false;
  var listHeight = 170.0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBarWithTitle.getAppBar('Services'),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: queryData.size.width * 0.27,
                            height: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  child: Image(
                                    height: imageHeight,
                                    width: imageWidth,
                                    image: AssetImage(
                                        'images/maintenance_icon.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Checkbox(
                                    activeColor: Colors.blue[700],
                                    value: checkBoxVal,
                                    onChanged: (value) {
                                      setState(() {
                                        checkBoxVal = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 130,
                        child: ListView(
                          children: <Widget>[
                            Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Preventive Maintenance",
                                        style: TextStyle(
                                            color: Colors.yellow[700],
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: queryData.size.width * 0.73,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Oil Exchange",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "AC Services",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  width: queryData.size.width * 0.73,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Batteries",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Fleet Services",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  width: queryData.size.width * 0.73,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Air Filter",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "View All",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new Divider(
                  color: Colors.black,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: queryData.size.width * 0.27,
                            height: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Image(
                                    height: imageHeight,
                                    width: imageWidth,
                                    image: AssetImage('images/tyre.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),

                                  child: Checkbox(
                                    activeColor: Colors.blue[700],
                                    value: checkboxVal2,
                                    onChanged: (value) {
                                      setState(() {
                                        checkboxVal2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 140,
                        child: ListView(
                          children: <Widget>[
                            Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Tyre Services",
                                        style: TextStyle(
                                            color: Colors.yellow[700],
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: queryData.size.width * 0.73,
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Alignment",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Tyre Balancing",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  width: queryData.size.width * 0.73,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Tyre Rotation",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "TPMS Services",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: queryData.size.width * 0.73,
                                  padding: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Flat Tyre Repair",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "View All",
                                            style: TextStyle(
                                                color: Colors.blue[700],
                                                decoration: textDecoration,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new Divider(
                  color: Colors.black,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: queryData.size.width * 0.27,
                            height: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  child: Image(
                                    height: imageHeight,
                                    width: imageWidth,
                                    image: AssetImage('images/carrepair.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  
                                  child: Checkbox(
                                    activeColor: Colors.blue[700],
                                    value: checkboxVal3,
                                    onChanged: (value) {
                                      setState(() {
                                        checkboxVal3 = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: listHeight,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Repair Services",
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Brakes",
                                  style: TextStyle(
                                      color: Colors.blue[700],
                                      decoration: textDecoration,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Belt and Radiator",
                                  style: TextStyle(
                                      color: Colors.blue[700],
                                      decoration: textDecoration,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Steering and Suspension",
                                  style: TextStyle(
                                      color: Colors.blue[700],
                                      decoration: textDecoration,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Engine Diagnostics",
                                  style: TextStyle(
                                      color: Colors.blue[700],
                                      decoration: textDecoration,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Transmission and Clutch",
                                  style: TextStyle(
                                      color: Colors.blue[700],
                                      decoration: textDecoration,
                                      fontSize: 16),
                                ),
                              ),
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
            )
          ],
        ),
      ),
    );
  }
}
