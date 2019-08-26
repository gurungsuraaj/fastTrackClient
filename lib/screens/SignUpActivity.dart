import 'package:circular_check_box/circular_check_box.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'HomeActivity.dart';
import 'GenerateOTPActivity.dart';

class SignUpActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpActivity();
  }
}

class _SignUpActivity extends State<SignUpActivity> {
  /*Variables and declarations region*/
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProgressBarShown = false;
  double MARGIN = 32;
  double PADDING = 10.0;

  var fontWeightText = FontWeight.w500;
  var fontSizeTextField = 14.0;
  var fontSizeText = 14.0;
  bool initialCheckBox = false;

  /*Variables and declarations end region*/

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(ExtraColors.DARK_BLUE_ACCENT)));

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
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(MARGIN),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Text(
                              'Full Name',
                              style: TextStyle(
                                fontWeight: fontWeightText,
                                fontSize: fontSizeText,
                              ),
                            ),
                          ),
                          Container(
                            child: TextField(
                              style: TextStyle(fontSize: fontSizeTextField),
                              decoration: InputDecoration(
                                  hintText: 'Full name...',
                                  hintStyle:
                                      TextStyle(color: Color(0xffb8b8b8))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: MARGIN),
                            child: Text(
                              'E-mail',
                              style: TextStyle(
                                  fontWeight: fontWeightText,
                                  fontSize: fontSizeText),
                            ),
                          ),
                          Container(
                            child: TextField(
                              style: TextStyle(
                                fontSize: fontSizeTextField,
                              ),
                              decoration: InputDecoration(
                                  hintText: 'Your e-mail',
                                  hintStyle:
                                      TextStyle(color: Color(0xffb8b8b8))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: MARGIN),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                  fontWeight: fontWeightText,
                                  fontSize: fontSizeText),
                            ),
                          ),
                          Container(
                            child: TextField(
                              style: TextStyle(
                                fontSize: fontSizeTextField,
                              ),
                              decoration: InputDecoration(
                                  hintText: 'Your password',
                                  hintStyle:
                                      TextStyle(color: Color(0xffb8b8b8))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: MARGIN),
                            child: Text(
                              'Retype Password',
                              style: TextStyle(
                                  fontWeight: fontWeightText,
                                  fontSize: fontSizeText),
                            ),
                          ),
                          Container(
                            child: TextField(
                              style: TextStyle(
                                fontSize: fontSizeTextField,
                              ),
                              decoration: InputDecoration(
                                  hintText: 'Retype password',
                                  hintStyle:
                                      TextStyle(color: Color(0xffb8b8b8))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: MARGIN),
                            child: Row(
                              children: <Widget>[
                                CircularCheckBox(
                                    activeColor: Colors.blue[700],
                                    value: initialCheckBox,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                    onChanged: (value) {
                                      setState(() {
                                        initialCheckBox = value;
                                      });
                                    }),
                                Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff7c7b7b)),
                                )
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 24.0),
                              width: width * 1,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/GenerateOTP');
                                },
                                color: Color(ExtraColors.DARK_BLUE),
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
