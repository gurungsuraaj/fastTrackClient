import 'dart:convert';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'HomeActivity.dart';
import 'GenerateOTPActivity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import "./TermsAndConditionScreen.dart";

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

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  /*Variables and declarations end region*/

  String _email;
  String _password;

  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(ExtraColors.DARK_BLUE_ACCENT)));

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        dismissible: false,
        child: SafeArea(
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
                                controller: nameController,
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
                                controller: emailController,
                                decoration: InputDecoration(
                                    hintText: 'Your e-mail',
                                    hintStyle:
                                        TextStyle(color: Color(0xffb8b8b8))),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: MARGIN),
                              child: Text(
                                'Mobile number',
                                style: TextStyle(
                                    fontWeight: fontWeightText,
                                    fontSize: fontSizeText),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: fontSizeTextField,
                                ),
                                controller: mobileController,
                                decoration: InputDecoration(
                                    hintText: 'Your number',
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
                                controller: passwordController,
                                decoration: InputDecoration(
                                    hintText: 'Your password',
                                    hintStyle:
                                        TextStyle(color: Color(0xffb8b8b8))),
                                onSaved: (val) => _password,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: MARGIN),
                                height: 40,
                                child: Row(
                                  children: <Widget>[
                                    // CheckboxListTile(
                                    //   title: new Text('Terms and Conditions'),
                                    //   value: _termsChecked,
                                    //   onChanged: (val) {
                                    //     setState(() {
                                    //       _termsChecked = val;
                                    //       debugPrint("checkbox val $val");
                                    //     });
                                    //   },
                                    //   controlAffinity:
                                    //       ListTileControlAffinity.leading,
                                    //   activeColor: Colors.green,
                                    // ),
                                    Checkbox(
                                      value: checkBoxValue,
                                      onChanged: (val) {
                                        setState(() {
                                          checkBoxValue = val;
                                        });
                                        debugPrint("$val");
                                      },
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          final callback = Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TermsAndConditionScreen()),
                                          );

                                          callback.then((res) {
                                            debugPrint(res);
                                            if (res == "Agree") {
                                              setState(() {
                                                checkBoxValue = true;
                                              });
                                            }
                                          });
                                        },
                                        child: Text("Terms and Conditions")),
                                  ],
                                )),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 24.0),
                                width: width * 1,
                                child: RaisedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
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
      if (checkBoxValue) {
        //proceed to post
        form.save();
        debugPrint("password Saved succesfully");
        //  Navigator.of(context).pushNamed('/GenerateOTP');
        signUp();
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

  void signUp() async {
    showProgressBar();
    debugPrint("Came to check inventory");
    String url = Api.POST_CUSTOMER_SIGNUP;
    debugPrint("This is  url : $url");

    String name = nameController.text;
    String email = emailController.text;
    String mobileNum = mobileController.text;
    String password = passwordController.text;

    Map<String, String> body = {
      "mobileNo": mobileNum,
      "customerName": name,
      "email": email,
      "passwordTxt": password,
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "url":
          "DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory",
    };
    await http.post(url, body: body_json, headers: header).then((val) {
      debugPrint("came to response after post url..");
      debugPrint("This is status code: ${val.statusCode}");
      debugPrint("This is body: ${val.body}");
      var statusCode = val.statusCode;
      var result = json.decode(val.body);
      String message = result["message"];

      if (statusCode == Rcode.SUCCESS_CODE) {
        hideProgressBar();

        Navigator.of(context).pushNamed('/LoginActivity');
        ShowToast.showToast(context, "Signed up successfully");
      } else {
        hideProgressBar();
        ShowToast.showToast(context,"Error : " + message);
      }
    }).catchError((val) {
      hideProgressBar();
      ShowToast.showToast(context, "Something went wrong");
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
