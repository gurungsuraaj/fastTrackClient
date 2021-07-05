import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'OTPActivity.dart';

class GenerateOTP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GenerateOTP();
  }
}

class _GenerateOTP extends State<GenerateOTP> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var fontWeightText = FontWeight.w500;
  var fontSizeTextField = 18.0;
  var fontSizeText = 16.0;
  double PADDING = 10.0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var MARGIN = 24.0;
    bool isProgressBarShown = false;
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ReusableAppBar.getAppBar(0, PADDING, height, width), //Container
//Container
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: MARGIN),
                              child: Text(
                                'GENERATE OTP',
                                style: TextStyle(
                                    color: Colors.blue[900], fontSize: 25.0),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: MARGIN),
                              child: Text(
                                'Please enter you mobile number to proceed!',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 10,
                          ),
                          Text(
                            'Mobile No.',
                            style: TextStyle(
                                fontWeight: fontWeightText,
                                fontSize: fontSizeText),
                          ),
                          Container(
                            child: TextField(
                              style: TextStyle(
                                fontSize: fontSizeTextField,
                              ),
                              decoration: InputDecoration(
                                  hintText: 'Enter your number'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: width / 2,
                              margin: EdgeInsets.only(top: MARGIN + 6),
                              child: RaisedButton(
                                onPressed: () {
                                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OTP()),
                                  );*/
                                  Navigator.pushNamed(context, RoutesName.otp);
                                },
                                color: Color(ExtraColors.darkBlue),
                                child: Text(
                                  'Generate OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: Container(
          height: 80.0,
          child: Center(
            child: Text(
              'Pin Submitted. Value: $pin',
              style: TextStyle(fontSize: 25.0),
            ),
          )),
      backgroundColor: Colors.greenAccent,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
