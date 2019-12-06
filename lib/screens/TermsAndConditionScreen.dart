import "package:flutter/material.dart";
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';

class TermsAndConditionScreen extends StatefulWidget {
  TermsAndConditionScreen({Key key}) : super(key: key);

  @override
  _TermsAndConditionScreenState createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  double MARGIN = 32;
  double PADDING = 10.0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          ReusableAppBar.getAppBar(0, PADDING, height, width),
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "TERMS & CONDITIONS",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
              child: Text(
                termAndConditionText,
                style: TextStyle(fontSize: 16, letterSpacing: 1, height: 1.8),
              )),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 30),
            child: RaisedButton(
              color: Color(0xFF264A92),
              onPressed: () {
                Navigator.of(context).pop("Agree");
              },
              child: Text(
                "I Agree",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  String termAndConditionText =
      "END USER LICENSE AGREEMENT(EULA) Important - Read Carefully. This End User License Agreement (“Agreement”) is a legal and binding contract between you and Fasttrack LLC for software product purchased  from Navision Web Services. (“Product”), which includes computer software and may include printed materials, and online or electronic documentation. By installing, copying, or otherwise using the Product, End User agrees to be bound by the terms of this Agreement.";
}
