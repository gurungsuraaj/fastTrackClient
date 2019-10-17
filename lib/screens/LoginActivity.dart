import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import '../helper/NetworkOperationManager.dart';
import 'SignUpActivity.dart';
import 'package:flutter/services.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  double MARGIN = 24.0;
  double PADDING = 10.0;
  var fontWeightText = FontWeight.w500;
  var fontSizeTextField = 14.0;
  var fontSizeText = 16.0;
  NTLMClient client;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();


  @override
  void initState() {
    super.initState();
    client = NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    debugPrint("This is the password: ${Constants.NTLM_PASSWORD}");
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool isProgressBarShown = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(ExtraColors.DARK_BLUE_ACCENT)));

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
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: MARGIN),
                          height: height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: MARGIN),
                                child: Center(
                                  child: Text(
                                    'Welcome',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 26.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: MARGIN),
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          fontWeight: fontWeightText,
                                          fontSize: fontSizeText,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.8,
                                      child: TextFormField(
                                       /* validator: (val) {
                                          if (val.isEmpty) {
                                            return 'Please enter your email';
                                          } else
                                            return null;
                                        },*/
                                        style: TextStyle(
                                            fontSize: fontSizeTextField),
                                        decoration: InputDecoration(
                                            hintText: 'Your Email...',
                                            hintStyle: TextStyle(
                                                color: Color(0xffb8b8b8))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
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
                                      width: width * 0.8,
                                      child: TextFormField(
                                        obscureText: true,
                                       /* validator: (val) {
                                          if (val.isEmpty) {
                                            return 'Please enter your Password';
                                          } else
                                            return null;
                                        },*/
                                        style: TextStyle(
                                          fontSize: fontSizeTextField,
                                        ),
                                        decoration: InputDecoration(
                                            hintText: 'Your password',
                                            hintStyle: TextStyle(
                                                color: Color(0xffb8b8b8))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 40, 0, 5),
                                  width: width * 0.55,
                                  child: RaisedButton(
                                    color: Color(ExtraColors.DARK_BLUE),
                                    onPressed: () {
                                      Navigator.pushNamed(context, RoutesName.HOME_ACTIVITY);
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 65),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Dont have account?",
                                        style:
                                            TextStyle(color: Color(0xff7c7b7b)),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              RoutesName.SIGNUP_ACTIVITY);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(6),
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: Color(
                                                      ExtraColors.DARK_BLUE)),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 /* void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      NetworkOperationManager.logIn("9806503355", "12345", "9806503355", "Ram", "test@example.com", client).then((val) {
        debugPrint("This is status code:: ${val.status}");
        debugPrint("This is response body:: ${val.responseBody}");
      });

    }
  }*/
}
