import 'package:circular_check_box/circular_check_box.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'HomeActivity.dart';
import 'GenerateOTPActivity.dart';
import 'dart:async';

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
  final formKey = new GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool isProgressBarShown = false;
  double MARGIN = 32;
  double PADDING = 10.0;

  var fontWeightText = FontWeight.w500;
  var fontSizeTextField = 14.0;
  var fontSizeText = 14.0;
  bool _termsChecked = false;

  TextEditingController passwordController = TextEditingController();

  /*Variables and declarations end region*/

  String _email;
  String _password;
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
                    Form(
                      key: formKey,
                      child: Container(
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
                              child: TextFormField(
                                // validator: (val) => val.length && val.isEmpty > 20
                                //     ?
                                //     : null,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "Please provide us your Full Name";
                                  } else {
                                    return null;
                                  }
                                },
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
                              child: TextFormField(
                                validator: (val) =>
                                    !val.contains('@') ? 'Invalid Email' : null,
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
                              child: TextFormField(
                                key: passKey,
                                obscureText: true,
                                validator: (String val) {
                                  if (val.isEmpty) {
                                    return 'Use atleast 6 characters to create your password';
                                  } else
                                    return null;
                                },
                                style: TextStyle(
                                  fontSize: fontSizeTextField,
                                ),
                                decoration: InputDecoration(
                                    hintText: 'Your password',
                                    hintStyle:
                                        TextStyle(color: Color(0xffb8b8b8))),
                                onSaved: (val) => _password,
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
                              child: TextFormField(
                                validator: (val) {
                                  var password = passKey.currentState.value;
                                  if (val.isEmpty) {
                                    return null;
                                  } else if (val == password) {
                                  } else {
                                    return "Password didn't match";
                                  }
                                },
                                obscureText: true,
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
                              child: CheckboxListTile(
                                title: new Text('Terms and Conditions'),
                                value: _termsChecked,
                                onChanged: (val) {
                                  setState(() {
                                    _termsChecked = val;
                                    debugPrint("checkbox val $val");
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.green,
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 24.0),
                                width: width * 1,
                                child: RaisedButton(
                                  onPressed: () {
                                    _submit();
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

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      if (_termsChecked) {
        //proceed to post
        form.save();
        debugPrint("password Saved succesfully");
        Navigator.of(context).pushNamed('/GenerateOTP');
      } else {
        //show snackbar
        displaySnackbar(context,
            "You need to agree to our terms and condition to proceed further");
      }
    }
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
