import 'dart:convert';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:toast/toast.dart';
import 'HomeActivity.dart';
import 'GenerateOTPActivity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import "./TermsAndConditionScreen.dart";
import 'package:country_pickers/country_pickers.dart';

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
  String phoneCode = "971", mobileNumber;
  NTLMClient client;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  /*Variables and declarations end region*/

  String _email;
  String _password;

  bool checkBoxValue = false;
  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(ExtraColors.DARK_BLUE_ACCENT)));

    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(ExtraColors.DARK_BLUE),
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
                  child: Text(
                    "Create new account",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ), ////Container
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Container(
                        margin: EdgeInsets.all(MARGIN),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

//                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
//                            Container(
//                              margin: EdgeInsets.only(top: 16),
//                              child: Text(
//                                'Full Name',
//                                style: TextStyle(
//                                  fontWeight: fontWeightText,
//                                  fontSize: fontSizeText,
//                                ),
//                              ),
//                            ),
                            Container(
                              width: width * 0.8,
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
                                style: TextStyle(
                                    fontSize: fontSizeTextField,
                                    color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    hintText: 'Full name...',
                                    hintStyle:
                                        TextStyle(color: Color(0xffb8b8b8))),
                              ),
                            ),
//                            Container(
//                              margin: EdgeInsets.only(top: MARGIN),
//                              child: Text(
//                                'E-mail',
//                                style: TextStyle(
//                                    fontWeight: fontWeightText,
//                                    fontSize: fontSizeText),
//                              ),
//                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              width: width * 0.8,
                              child: TextFormField(
                                validator: (val) =>
                                    !val.contains('@') ? 'Invalid Email' : null,
                                style: TextStyle(
                                    fontSize: fontSizeTextField,
                                    color: Colors.white),
                                controller: emailController,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    hintText: 'Your e-mail',
                                    hintStyle:
                                        TextStyle(color: Color(0xffb8b8b8))),
                              ),
                            ),
//                            Container(
//                              margin: EdgeInsets.only(top: MARGIN),
//                              child: Text(
//                                'Mobile number',
//                                style: TextStyle(
//                                    fontWeight: fontWeightText,
//                                    fontSize: fontSizeText),
//                              ),
//                            ),
//                            Container(
//                              padding: EdgeInsets.only(top: 15),
//                              width: width * 0.7,
//                              child: TextFormField(
//
//                                validator: (val) => val.length < 10
//                                    ? 'Please enter atleast 10 character '
//                                    : null,
//                                keyboardType: TextInputType.number,
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: fontSizeTextField,
//                                ),
//                                controller: mobileController,
//                                decoration: InputDecoration(
//                                    enabledBorder: UnderlineInputBorder(
//                                      borderSide: BorderSide(color: Colors.white),
//                                    ),
//                                    focusedBorder: UnderlineInputBorder(
//                                      borderSide: BorderSide(color: Colors.white),),
//                                    hintText: 'Your number',
//                                    hintStyle:
//                                        TextStyle(color: Color(0xffb8b8b8))),
//                              ),
//                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              width: width * 0.8,
                              child: _buildCountryPickerDropdown(),
                            ),

//                            Container(
//                              margin: EdgeInsets.only(top: MARGIN),
//                              child: Text(
//                                'Password',
//                                style: TextStyle(
//                                    fontWeight: fontWeightText,
//                                    fontSize: fontSizeText),
//                              ),
//                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              width: width * 0.8,
                              child: TextFormField(
                                validator: (val) => val.length < 6
                                    ? 'Please enter atleast 6 character '
                                    : null,
                                // key: passKey,
                                obscureText: true,
                                style: TextStyle(
                                    fontSize: fontSizeTextField,
                                    color: Colors.white),
                                controller: passwordController,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
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
                                        child: Text(
                                          "Subscribe for share locally program to earn & redeem.\n Read Share terms and condition",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )),
                                  ],
                                )),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 45.0),
                                width: width * 0.5,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    // side: BorderSide(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _submit();
                                  },
                                  color: Colors.white,
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Color(ExtraColors.DARK_BLUE),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                  padding: EdgeInsets.only(top: 25),
                                  child: Text(
                                    "By proceeding you accept the terms and condition",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )),
                            )
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
//  Widget _buildDropdownItem(Country country) => Container(
//    child: Row(
//      children: <Widget>[
//        CountryPickerUtils.getDefaultFlagImage(country),
//        SizedBox(
//          width: 8.0,
//        ),
//        Text("+${country.phoneCode}(${country.isoCode})"),
//      ],
//    ),
//  );

  void _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      if (checkBoxValue) {
        //proceed to post
        debugPrint("password Saved succesfully");
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          // signUp();
          _signUp();
        } else {
          ShowToast.showToast(context, "No internet connection");
        }
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

    String name = nameController.text;
    String email = emailController.text;
    String mobileNum = phoneCode + mobileController.text;
    String password = passwordController.text;
    debugPrint("This is  url : $mobileNum");

    Map<String, String> body = {
      "mobileNo": mobileNum,
      "customerName": name,
      "email": email,
      "passwordTxt": password,
    };

    var body_json = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "url": "DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory",
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

        Navigator.of(context).pop();
        ShowToast.showToast(context, "Signed up successfully");
      } else {
        hideProgressBar();
        ShowToast.showToast(context, "Error : " + message);
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

  _buildCountryPickerDropdown(
          {bool filtered = false,
          bool sortedByIsoCode = false,
          bool hasPriorityList = false}) =>
      Row(
        children: <Widget>[
          CountryPickerDropdown(
            initialValue: 'AE',
            itemBuilder: _buildDropdownItem,
            itemFilter: filtered
                ? (c) => ['AE', 'DE', 'GB', 'CN'].contains(c.isoCode)
                : null,
            priorityList: hasPriorityList
                ? [
                    CountryPickerUtils.getCountryByIsoCode('GB'),
                    CountryPickerUtils.getCountryByIsoCode('CN'),
                  ]
                : null,
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              print(
                "${country.phoneCode}",
              );
              setState(() {
                phoneCode = country.phoneCode;
              });
            },
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextField(
              controller: mobileController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Phone",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      );

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text(
              "+${country.phoneCode}(${country.isoCode})",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );

  void _signUp() async {
    String mobileNum = phoneCode + mobileController.text;

    showProgressBar();
    NetworkOperationManager.signUp(mobileNum, nameController.text,
            emailController.text, passwordController.text, client)
        .then((res) {
      hideProgressBar();
      if (res.status == Rcode.SUCCESS_CODE) {
        Navigator.of(context).pop();
        ShowToast.showToast(context, "Signed up successfully");
      } else {
        print("suraj ${res.responseBody}");
        ShowToast.showToast(context, "Error :" + "${res.responseBody}");
      }
    }).catchError((err) {
      ShowToast.showToast(context, "Error :" + err);
    });
  }
}
