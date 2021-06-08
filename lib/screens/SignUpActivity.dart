import 'dart:convert';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/models/CustomerModel.dart';
import 'package:fasttrackgarage_app/screens/ForgotPasswordScreen.dart';
import 'package:fasttrackgarage_app/screens/OTPActivity.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ModeConstants.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/Rstring.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:toast/toast.dart';
import '../utils/RoutesName.dart';
import 'HomeActivity.dart';
import 'GenerateOTPActivity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import "./TermsAndConditionScreen.dart";
import 'package:country_pickers/country_pickers.dart';
import 'package:fasttrackgarage_app/models/CustomerModel.dart';

class SignUpActivity extends StatefulWidget {
  final CustomerModel customerDetails;
  final String mobileNumber;

  const SignUpActivity({Key key, this.customerDetails, this.mobileNumber})
      : super(key: key);
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
  String signature;

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
    if (widget.customerDetails != null) {
      nameController.text = widget.customerDetails.name;
      mobileController.text = widget.customerDetails.phoneNumber;
      emailController.text = widget.customerDetails.email;
      passwordController.text = widget.customerDetails.password;
    }
    if (widget.mobileNumber != null) {
      mobileController.text = widget.mobileNumber;
    }
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    _getSignatureCode();
  }

  /// get signature code
  _getSignatureCode() async {
    signature = await SmsRetrieved.getAppSignature();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(ExtraColors.DARK_BLUE_ACCENT)));

    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff253983),
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        dismissible: false,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ReusableAppBar.getAppBar(20, 0, height, width),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                              width: width * 0.9,
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
                                    color: Color(ExtraColors.DARK_BLUE_ACCENT)),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 20, 0),
                                      child: CircleAvatar(
                                          // radius: 5,
                                          backgroundColor: Color(0xffe6a764),
                                          child: Icon(
                                            Icons.person_outline,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[300])),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[300])),
                                    hintText: 'Full name...',
                                    hintStyle: TextStyle(
                                      // color: Color(0xffb8b8b8),
                                      color: Colors.grey[500],
                                    )),
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
                              width: width * 0.9,
                              child: TextFormField(
                                validator: (val) =>
                                    !val.contains('@') ? 'Invalid Email' : null,
                                style: TextStyle(
                                    fontSize: fontSizeTextField,
                                    color: Color(ExtraColors.DARK_BLUE_ACCENT)),
                                controller: emailController,
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 20, 0),
                                      child: CircleAvatar(
                                          // radius: 5,
                                          backgroundColor: Color(0xffe6a764),
                                          child: Icon(
                                            Icons.mail_outline,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[300])),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[300])),
                                    hintText: 'Your e-mail',
                                    hintStyle: TextStyle(
                                      // color: Color(0xffb8b8b8),
                                      color: Colors.grey[500],
                                    )),
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
                              width: width * 0.9,
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
                              width: width * 0.9,
                              child: TextFormField(
                                validator: (val) => val.length < 6
                                    ? 'Please enter atleast 6 character '
                                    : null,
                                // key: passKey,
                                obscureText: true,
                                style: TextStyle(
                                    fontSize: fontSizeTextField,
                                    color: Color(ExtraColors.DARK_BLUE_ACCENT)),
                                controller: passwordController,
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 20, 0),
                                      child: CircleAvatar(
                                          // radius: 5,
                                          backgroundColor: Color(0xffe6a764),
                                          child: Icon(
                                            Icons.lock_outline,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[300])),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[300])),
                                    hintText: 'Your password',
                                    hintStyle:
                                        TextStyle(color: Color(0xffb8b8b8))),
                                onSaved: (val) => _password,
                              ),
                            ),

                            // Container(
                            //     margin: EdgeInsets.only(top: MARGIN),
                            //     height: 40,
                            //     child: Row(
                            //       children: <Widget>[
                            //         // CheckboxListTile(
                            //         //   title: new Text('Terms and Conditions'),
                            //         //   value: _termsChecked,
                            //         //   onChanged: (val) {
                            //         //     setState(() {
                            //         //       _termsChecked = val;
                            //         //       debugPrint("checkbox val $val");
                            //         //     });
                            //         //   },
                            //         //   controlAffinity:
                            //         //       ListTileControlAffinity.leading,
                            //         //   activeColor: Colors.green,
                            //         // ),
                            //         Checkbox(
                            //           value: checkBoxValue,
                            //           onChanged: (val) {
                            //             setState(() {
                            //               checkBoxValue = val;
                            //             });
                            //             debugPrint("$val");
                            //           },
                            //         ),
                            //         GestureDetector(
                            //             onTap: () {
                            //               final callback = Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         TermsAndConditionScreen()),
                            //               );

                            //               callback.then((res) {
                            //                 debugPrint(res);
                            //                 if (res == "Agree") {
                            //                   setState(() {
                            //                     checkBoxValue = true;
                            //                   });
                            //                 }
                            //               });
                            //             },
                            //             child: Text(
                            //               "Subscribe for share locally program to earn &\n redeem.Read Share terms and condition",
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 10),
                            //             )),
                            //       ],
                            //     )),
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
                            // Center(
                            //   child: Container(
                            //       padding: EdgeInsets.only(top: 25),
                            //       child: Text(
                            //         "By proceeding you accept the terms and condition",
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 12),
                            //       )),
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //         builder: (context) =>
                            //             ForgotPasswordScreen()));
                            //   },
                            //   child: Text(
                            //     "Forgot Password?",
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
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
      // if (checkBoxValue) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (widget.customerDetails == null) {
          _signUp();
        } else {
          sendExistingCustomerOTP();
        }
      } else {
        ShowToast.showToast(context, "No internet connection");
      }
      // } else {
      //   //show snackbar
      //   displaySnackbar(context,
      //       "You need to agree to our terms and condition to proceed further");
      // }
    }
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(minutes: 5),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {
          _scaffoldKey.currentState.removeCurrentSnackBar();
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void signUp() async {
    showProgressBar();
    String url = Api.POST_CUSTOMER_SIGNUP;

    String name = nameController.text;
    String email = emailController.text;
    String mobileNum = phoneCode + mobileController.text;
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
      "url": "DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory",
    };
    await http.post(url, body: body_json, headers: header).then((val) {
      var statusCode = val.statusCode;
      var result = json.decode(val.body);
      String message = result["message"];

      if (statusCode == Rcode.SUCCESS_CODE) {
        hideProgressBar();

        Navigator.of(context).pop();
        ShowToast.showToast(context, "Signed up successfully");
      } else {
        hideProgressBar();
        // ShowToast.showToast(context, "Error : " + message);
        displaySnackbar(context, "Error : $message");
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
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xffe6a764),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 25,
                  )),
            ),
            SizedBox(
              width: 3,
            ),
            Row(
              children: [
                // Container(
                //     height: 25,
                //     width: MediaQuery.of(context).size.width * 0.1,
                //     child: Image.asset('icons/flags/png/ae.png',
                //         package: 'country_icons')),
                // SizedBox(width: 5),
                Text(
                  '+971',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            // CountryPickerDropdown(
            //   initialValue: 'AE',
            //   itemBuilder: _buildDropdownItem,
            //   itemFilter: filtered
            //       ? (c) => ['AE', 'DE', 'GB', 'CN'].contains(c.isoCode)
            //       : null,
            //   priorityList: hasPriorityList
            //       ? [
            //           CountryPickerUtils.getCountryByIsoCode('GB'),
            //           CountryPickerUtils.getCountryByIsoCode('CN'),
            //         ]
            //       : null,
            //   sortComparator: sortedByIsoCode
            //       ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
            //       : null,
            //   onValuePicked: (Country country) {
            //     print(
            //       "${country.phoneCode}",
            //     );
            //     setState(() {
            //       phoneCode = country.phoneCode;
            //     });
            //   },
            // ),
            Expanded(
              child: TextField(
                enabled: false,
                controller: mobileController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Color(ExtraColors.DARK_BLUE_ACCENT)),
                decoration: InputDecoration(
                  hintText: "Phone",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  fillColor: Colors.white,
                  filled: true,
                  // prefixIcon: Container(
                  //   padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                  //   child: CircleAvatar(
                  //       radius: 18,
                  //       backgroundColor: Color(0xffe6a764),
                  //       child: Icon(
                  //         Icons.phone,
                  //         color: Colors.white,
                  //         size: 25,
                  //       )),
                  // ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
    // String mobileNum = phoneCode + mobileController.text;
    String mobileNum = mobileController.text;

    showProgressBar();
    NetworkOperationManager.signUp(mobileNum, nameController.text,
            emailController.text, passwordController.text, signature, client)
        .then((res) {
      hideProgressBar();
      if (res.status == Rcode.SUCCESS_CODE) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTP(
                    query: mobileNum,
                    mode: 1,
                    signature: signature,
                    loginPassword: passwordController.text,
                  )), // 1 is for sign up in otp screen
        );
      } else {
        displaySnackbar(context, "Error : ${res.responseBody}");
      }
    }).catchError((err) {
      hideProgressBar();
      ShowToast.showToast(context, "Error :" + err);
    });
  }

  void sendExistingCustomerOTP() async {
    showProgressBar();
    NetworkOperationManager.sendExistingCustomerOTP(
            mobileController.text, client)
        .then((res) {
      if (res.responseBody == Rstring.OTP_SEND_SUCCESS || res.status ==  200 ) {
        // ShowToast.showToast(context, res.responseBody);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTP(
                    query: emailController.text,
                    mode: 3,
                    signature: signature,
                    loginPassword: passwordController.text,
                    customerName: nameController.text,
                    mobileNum: mobileController.text,
                    customerNo: widget.customerDetails.customerNo,
                  )), // 3 is for sign up in existing customer
        );
      } else {
        displaySnackbar(context, "Error : ${res.responseBody}");
      }

      hideProgressBar();
    }).catchError((e) {
      hideProgressBar();
    });
  }
}
