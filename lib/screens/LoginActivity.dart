import 'dart:convert';

import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import '../helper/NetworkOperationManager.dart';
import 'package:http/http.dart' as http;
import 'SignUpActivity.dart';
import 'package:flutter/services.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  double MARGIN = 22.0;
  double PADDING = 10.0;
  var fontWeightText = FontWeight.w500;
  var fontSizeTextField = 14.0;
  var fontSizeText = 16.0;
  NTLMClient client;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool isProgressBarShown = false;

  TextEditingController emailController = new TextEditingController(text: "thisisdellcorp@gmail.com");
  TextEditingController passwordController = new TextEditingController(text: "aabbccddee");
  TextEditingController mobileController = new TextEditingController(text: "9819166741");
  TextEditingController nameController = new TextEditingController(text: "Test Dell");
  TextEditingController customerNumController = new TextEditingController(text: "121");

  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    PrefsManager.checkSession().then((isSessionExist){
      if(isSessionExist){
        Navigator.pushNamed(context, RoutesName.HOME_ACTIVITY);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(ExtraColors.DARK_BLUE_ACCENT)));

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
                                        'Mobile number',
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
                                        controller: mobileController,
                                        decoration: InputDecoration(
                                            hintText: 'Your Number...',
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
                                        controller: passwordController,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: MARGIN),
                                      child: Text(
                                        'Customer number',
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
                                        controller: customerNumController,
                                        decoration: InputDecoration(
                                            hintText: 'Customer number...',
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
                                        controller: emailController,
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
                                        'Customer name',
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
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            hintText: 'Customer name...',
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
                                      performLogin();
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

  void performLogin() async {
    showProgressBar();
    String url = Api.POST_CUSTOMER_LOGIN;
    debugPrint("This is  url : $url");


    String email = emailController.text;
    String password = passwordController.text;
    String mobileNumber = mobileController.text;
    String custNum = customerNumController.text;
    String custName = nameController.text;

    debugPrint("email : $email");
    debugPrint("PW : $password");
    debugPrint("Mobile num : $mobileNumber");
    debugPrint("Number : $custNum");
    debugPrint("CustName : $custName");

    Map<String, String> body = {
      "mobileNo": mobileNumber,
      "passwordTxt":password,
      "customerNo":custNum,
      "customerName":custName,
      "custemail":email
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "username": "PSS",
      "password": "\$ky\$p0rt\$",
      "url":
          "http://202.166.211.230:7747/DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory",
    };
    await http.post(url, body: body_json, headers: header).then((val) {
      debugPrint("came to response after post url..");
      debugPrint("This is status code: ${val.statusCode}");
      debugPrint("This is body: ${val.body}");
      int statusCode = val.statusCode;
      var result = json.decode(val.body);

      debugPrint("This is after result: $result");

      String message = result["message"];


      String custNumber = result["data"]["customerNo"];
      String customerName = result["data"]["customerName"];
      String custEmail = result["data"]["custEmail"];

      if(statusCode == Rcode.SUCCESS_CODE){
        debugPrint("THis is Customer number $custNumber");

        hideProgressBar();
        PrefsManager.saveLoginCredentialsToPrefs(custNumber, customerName, custEmail);
        Navigator.pushNamed(context, RoutesName.HOME_ACTIVITY);
        ShowToast.showToast(context, message);
      }
      else {
        hideProgressBar();
        // display snackbar
      }
    }).catchError((val) {
      hideProgressBar();
      ShowToast.showToast(context, "Something went wrong!");
      //display snackbar
    });
  }

/*  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      NetworkOperationManager.logIn("9806503355", "12345", "9806503355", "Ram", "test@example.com", client).then((val) {
        debugPrint("This is status code:: ${val.status}");
        debugPrint("This is response body:: ${val.responseBody}");
      });

    }
  }*/

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
