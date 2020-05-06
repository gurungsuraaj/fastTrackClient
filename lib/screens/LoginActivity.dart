import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/mainTab.dart';
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
import 'package:imei_plugin/imei_plugin.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  String _platformImei = 'Unknown';
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

  TextEditingController mobileController =
  new TextEditingController(text: "");
  TextEditingController passwordController =
      new TextEditingController(text: "");


  @override
  void initState() {
    super.initState();
    initPlatformState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);

    PrefsManager.checkSession().then((isSessionExist) {
      if (isSessionExist) {
        Navigator.pushReplacementNamed(context, RoutesName.MAIN_TAB);
      }
    });
  }

  Future<void> initPlatformState() async {
    String platformImei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(ExtraColors.DARK_BLUE_ACCENT)));

    return Scaffold(
      backgroundColor:  Color(ExtraColors.DARK_BLUE),
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        dismissible: false,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ReusableAppBar.getAppBar(0, 0, height, width),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text("Login to your account", style: TextStyle(color: Colors.white,fontSize: 16),),
                ),
              ) ,//Container
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

                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
//                                    Container(
//                                      margin: EdgeInsets.only(top: 40),
//                                      child: Text(
//                                        'Mobile number',
//                                        style: TextStyle(
//                                          fontWeight: fontWeightText,
//                                          fontSize: fontSizeText,
//                                        ),
//                                      ),
//                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 15),

                                      width: width * 0.7,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return 'Please enter your phone number';
                                          } else
                                            return null;
                                        },
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontSize: fontSizeTextField),
                                        controller: mobileController,
                                        decoration: InputDecoration(
                                            hintText: 'Your Number...',
                                            hintStyle: TextStyle(
                                                color: Color(0xffb8b8b8)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
//                                    Container(
//                                      margin: EdgeInsets.only(top: MARGIN),
//                                      child: Text(
//                                        'Password',
//                                        style: TextStyle(
//                                            fontWeight: fontWeightText,
//                                            fontSize: fontSizeText),
//                                      ),
//                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      width: width * 0.7,
                                      child: TextField(
                                        obscureText: true,
                                        style: TextStyle(
                                          fontSize: fontSizeTextField,
                                          color: Colors.white
                                        ),
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            hintText: 'Your password',
                                            hintStyle: TextStyle(
                                                color: Color(0xffb8b8b8)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),  ),


                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 35, 0, 5),
                                  width: width * 0.45,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                      // side: BorderSide(color: Colors.black),
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      // performLogin();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _submit();
                                    },
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(color: Color(ExtraColors.DARK_BLUE)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Dont have account?",
                                      style:
                                      TextStyle(color: Colors.white),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            RoutesName.SIGNUP_ACTIVITY);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(6),
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                color: Colors.yellow),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 65),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "All right reserve © 2020",
                                        style:
                                            TextStyle(color: Colors.white),
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
    debugPrint("This is  url : $url, IMEI $_platformImei");

    String mobileNumber = mobileController.text;
    String password = passwordController.text;
    String email = "";
    String custNum = "";
    String custName = "";

    debugPrint("email : $email");
    debugPrint("PW : $password");
    debugPrint("Mobile num : $mobileNumber");
    debugPrint("Number : $custNum");
    debugPrint("CustName : $custName");

    Map<String, String> body = {
      "mobileNo": mobileNumber,
      "passwordTxt": password,
      "customerNo": custNum,
      "customerName": custName,
      "custemail": email
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "url": "DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory",
      "imei": "$_platformImei",
    };
    await http.post(url, body: body_json, headers: header).then((val) {
      debugPrint("came to response after post url..");
      debugPrint("This is status code: ${val.statusCode}");
      debugPrint("This is body: ${val.body}");
      int statusCode = val.statusCode;
      var result = json.decode(val.body);

      debugPrint("This is after result: $result");

      String message = result["message"];

      String token = result["data"]["token"];

      String custNumber = result["data"]["customerNo"];
      String customerName = result["data"]["customerName"];
      String custEmail = result["data"]["custEmail"];

      if (statusCode == Rcode.SUCCESS_CODE) {
        debugPrint("THis is Customer number $custNumber");
        debugPrint("THis is token number $token");
        String basicToken = "Basic $token";
        debugPrint("Basic token : $basicToken");

        hideProgressBar();
        PrefsManager.saveLoginCredentialsToPrefs(custNumber, customerName,
            custEmail, basicToken, mobileController.text);
//        Navigator.pushReplacementNamed(context, RoutesName.MAIN_TAB);
//        Navigator.pushReplacementNamed(context, RoutesName.MAIN_TAB);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => MainTab())));
        ShowToast.showToast(context, message);
      } else {
        hideProgressBar();

        ShowToast.showToast(context, "Error : " + message);
      }
    }).catchError((val) {
      hideProgressBar();
      ShowToast.showToast(context, "Something went wrong!");
      //display snackbar
    });
  }

  void _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        performLogin();
      } else {
        ShowToast.showToast(context, "No internet connection");
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
