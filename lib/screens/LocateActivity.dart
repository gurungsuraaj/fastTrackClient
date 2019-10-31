import 'package:flutter/material.dart';

class LocateActivity extends StatefulWidget {
  LocateActivity({Key key}) : super(key: key);

  @override
  _LocateActivityState createState() => _LocateActivityState();
}

class _LocateActivityState extends State<LocateActivity> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
    return Scaffold(
        appBar: AppBar(
          title: Text("Locate"),
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text("Posting Date :", style: textStyle),
                            ),
                            Container(
                              child: Text(
                                "Document no. :",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Make :",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Model :",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Vehicle serial no. :",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Location :",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "No. :",
                                style: textStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text("", style: textStyle),
                            ),
                            Container(
                              child: Text(
                                "",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "",
                                style: textStyle,
                              ),
                            ),
                            Container(
                              child: Text(
                                "",
                                style: textStyle,
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
            );
          },
        ));
  }
}
