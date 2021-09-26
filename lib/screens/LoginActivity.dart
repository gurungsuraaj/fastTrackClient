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
import 'package:fasttrackgarage_app/widgets/CustomClipper.dart';
import "package:flutter/material.dart";
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:package_info/package_info.dart';
import '../helper/NetworkOperationManager.dart';
import 'package:http/http.dart' as http;
import 'SignUpActivity.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:fasttrackgarage_app/models/CustomerModel.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  String _platformImei = 'Unknown';
  double margin = 22.0;
  double padding = 10.0;
  var fontWeightText = FontWeight.w500;
  var fontSizeTextField = 14.0;
  var fontSizeText = 16.0;
  NTLMClient client;
  String phoneCode = "971";
  CustomerModel customeretails;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool isProgressBarShown = false;

  TextEditingController mobileController = new TextEditingController(text: "");
  TextEditingController passwordController =
      new TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    initPlatformState();
    client =
        NTLM.initializeNTLM(Constants.ntlmUsername, Constants.ntlmPassword);

    PrefsManager.checkSession().then((isSessionExist) {
      if (isSessionExist) {
        Navigator.pushReplacementNamed(context, RoutesName.mainTab);
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
        statusBarColor: Color(ExtraColors.darkBlueAccent)));

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xffF39C1B),
        backgroundColor: Color(0xff253983),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          dismissible: false,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                OrientationBuilder(builder: (context, orientation) {
                  return customContainer(orientation);
                }),
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Center(
                      child: Container(
                        height: height,
                        width: width * 0.87,
                        padding: EdgeInsets.only(bottom: height * 0.05),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),

                            Container(
                              height: height / 4,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Text(
                                      "WELCOME TO",
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                          // fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    // margin: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "MY FASTTRACK",
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          // fontStyle: FontStyle.values(80),
                                          color: Colors.orange),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ReusableAppBar.getAppBar(20, 0, height, width),
                            // SizedBox(
                            //   height: height * 0.1,
                            // ),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(0, height * 0.04, 0, 0),
                              child: Text(
                                "Login to your account",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                            ), //Container
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: _buildCountryPickerDropdown(),
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.only(top: 15),
                                      //   width: width * 0.7,
                                      //   child: TextFormField(
                                      //     keyboardType: TextInputType.number,
                                      //     validator: (val) {
                                      //       if (val.isEmpty) {
                                      //         return 'Please enter your phone number';
                                      //       } else
                                      //         return null;
                                      //     },
                                      //     style: TextStyle(
                                      //         color: Colors.white, fontSize: fontSizeTextField),
                                      //     controller: mobileController,
                                      //     decoration: InputDecoration(
                                      //       hintText: 'Your Number...',
                                      //       hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                                      //       enabledBorder: UnderlineInputBorder(
                                      //         borderSide: BorderSide(color: Colors.white),
                                      //       ),
                                      //       focusedBorder: UnderlineInputBorder(
                                      //         borderSide: BorderSide(color: Colors.white),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Container(
                                      //   margin: EdgeInsets.only(top: MARGIN),
                                      //   child: Text(
                                      //     'Password',
                                      //     style: TextStyle(
                                      //         fontWeight: fontWeightText,
                                      //         fontSize: fontSizeText),
                                      //   ),
                                      // ),
                                      // Container(
                                      //   child: TextField(
                                      //     obscureText: true,
                                      //     style: TextStyle(
                                      //         fontSize: fontSizeTextField,
                                      //         color: Color(
                                      //             ExtraColors.darkBlueAccent)),
                                      //     controller: passwordController,
                                      //     decoration: InputDecoration(
                                      //         hintText: 'Your password',
                                      //         hintStyle: TextStyle(
                                      //             color: Color(0xffb8b8b8)),
                                      //         fillColor: Colors.white,
                                      //         filled: true,
                                      //         prefixIcon: Container(
                                      //           padding: EdgeInsets.fromLTRB(
                                      //               10, 0, 20, 0),
                                      //           child: CircleAvatar(
                                      //               // radius: 5,
                                      //               backgroundColor:
                                      //                   Color(0xffe6a764),
                                      //               child: Icon(
                                      //                 Icons.lock_outline,
                                      //                 color: Colors.white,
                                      //                 size: 30,
                                      //               )),
                                      //         ),
                                      //         enabledBorder: OutlineInputBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(30),
                                      //             borderSide: BorderSide(
                                      //                 width: 1,
                                      //                 color: Colors.grey[300])),
                                      //         focusedBorder: OutlineInputBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(30),
                                      //             borderSide: BorderSide(
                                      //                 width: 1,
                                      //                 color: Colors.grey[300]))),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: height * 0.03,
                                      // ),
                                      Container(
                                        width: width * 0.45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      18.0),
                                            ),
                                            primary: Colors.orange,
                                          ),
                                          onPressed: () {
                                            // performLogin();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            _submit();
                                          },
                                          child: Text(
                                            "Continue",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.1,
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: <Widget>[
                                      //     Text(
                                      //       "Dont have account?",
                                      //       style: TextStyle(color: Colors.white),
                                      //     ),
                                      //     InkWell(
                                      //       onTap: () {
                                      //         Navigator.pushNamed(context,
                                      //             RoutesName.SIGNUP_ACTIVITY);
                                      //       },
                                      //       child: Container(
                                      //           padding: EdgeInsets.all(6),
                                      //           child: Text(
                                      //             "Register",
                                      //             style: TextStyle(
                                      //                 color: Colors.yellow),
                                      //           )),
                                      //     )
                                      //   ],
                                      // ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.of(context).push(
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 ForgotPasswordScreen()));
                                      //   },
                                      //   child: Text(
                                      //     "Forgot Password?",
                                      //     style: TextStyle(color: Colors.white),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      SizedBox(
                                        height: 60,
                                      ),

                                      Image.asset(
                                        'images/fast_track_logo.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      // Row(
                                      //   // mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     Row(
                                      //       children: <Widget>[
                                      //         Text(
                                      //           "All rights reserved © 2020",
                                      //           // textAlign: TextAlign.start,
                                      //           style: TextStyle(
                                      //               color: Colors.white,
                                      //               fontSize: 10),
                                      //         ),
                                      //         // SizedBox(width: 10),
                                      //         FutureBuilder(
                                      //           future: getVersionNumber(),
                                      //           builder: (BuildContext context,
                                      //                   AsyncSnapshot<String>
                                      //                       snapshot) =>
                                      //               Text(
                                      //             snapshot.hasData
                                      //                 ? "Version ${snapshot.data}"
                                      //                 : "Loading ...",
                                      //             style: TextStyle(
                                      //                 color: Colors.white,
                                      //                 fontSize: 10),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "All Rights Reserved © 2020",
                      // textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    // SizedBox(width: 10),
                    FutureBuilder(
                      future: getVersionNumber(),
                      builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) =>
                          Text(
                        snapshot.hasData
                            ? "Version ${snapshot.data}"
                            : "Loading ...",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customContainer(orientation) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/handle.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
    // if (orientation == Orientation.portrait) {
    //   return ClipPath(
    //       clipper: CustomShapeClipper(),
    //       child: Container(
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.height * 0.7,
    //         color: Color(0xff253983),
    //       ));
    // } else {
    //   return ClipPath(
    //       clipper: CustomShapeClipperLandscape(),
    //       child: Container(
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.height * 0.75,
    //         color: Color(0xff253983),
    //       ));
    // }
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
    String url = Api.postCustomerLogin;

    String mobileNumber = phoneCode + mobileController.text;
    String password = passwordController.text;
    String email = "";
    String custNum = "";
    String custName = "";

    Map<String, String> body = {
      "mobileNo": mobileNumber,
      "passwordTxt": password,
      "customerNo": custNum,
      "customerName": custName,
      "custemail": email
    };

    var dbodyJson = json.encode(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "url": "DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory",
      "imei": "$_platformImei",
    };
    await http.post(url, body: dbodyJson, headers: header).then((val) {
      int statusCode = val.statusCode;
      var result = json.decode(val.body);

      String message = result["message"];

      String token = result["data"]["token"];

      String custNumber = result["data"]["customerNo"];
      String customerName = result["data"]["customerName"];
      String custEmail = result["data"]["custEmail"];

      if (statusCode == Rcode.successCode) {
        String basicToken = "Basic $token";

        hideProgressBar();
        PrefsManager.saveLoginCredentialsToPrefs(custNumber, customerName,
            custEmail, basicToken, mobileController.text);
//        Navigator.pushReplacementNamed(context, RoutesName.MAIN_TAB);
//        Navigator.pushReplacementNamed(context, RoutesName.MAIN_TAB);
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => MainTab())));
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
        _navAuthentication();
        // _performLogin();
      } else {
        ShowToast.showToast(context, "No internet connection");
      }
    }
  }

  displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _buildCountryPickerDropdown(
          // {bool filtered = false,
          // bool sortedByIsoCode = false,
          // bool hasPriorityList = false}
          ) =>
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orange,
              // width: 5,
            ),
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
              child: CircleAvatar(
                  radius: 18,
                  // backgroundColor: Color(0xffe6a764),
                  backgroundColor: Colors.orange,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w300
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
            //   disabledHint: Container(),
            //   onValuePicked: (Country country) {
            //     print(
            //       "${country.phoneCode}",
            //     );
            //     setState(() {
            //       phoneCode = country.phoneCode;
            //     });
            //   },
            // ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                keyboardType: TextInputType.number,
                controller: mobileController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Phone",
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  // fillColor: Colors.white,
                  // filled: true,
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(30),
                  //   borderSide: BorderSide(
                  //     width: 1,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(30),
                  //   borderSide: BorderSide(
                  //     width: 1,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your phone number';
                  } else
                    return null;
                },
              ),
            )
          ],
        ),
      );

  // Widget _buildDropdownItem(Country country) => Container(
  //       child: Row(
  //         children: <Widget>[
  //           CountryPickerUtils.getDefaultFlagImage(country),
  //           SizedBox(
  //             width: 8.0,
  //           ),
  //           Text(
  //             "+${country.phoneCode}(${country.isoCode})",
  //             style: TextStyle(color: Colors.grey),
  //           ),
  //         ],
  //       ),
  //     );

  // void _performLogin() async {
  //   showProgressBar();
  //   String mobileNumber = mobileController.text;
  //   NetworkOperationManager.logIn(mobileNumber, passwordController.text, client)
  //       .then((res) {
  //     hideProgressBar();
  //     if (res.status == Rcode.successCode) {
  //       PrefsManager.saveLoginCredentialsToPrefs(res.customerNo,
  //           res.customerName, res.customerEmail, "", mobileController.text);

  //       Navigator.push(
  //           context, MaterialPageRoute(builder: ((context) => MainTab())));
  //       ShowToast.showToast(context, "Login Success");
  //     } else {
  //       ShowToast.showToast(context, res.errResponse);
  //     }
  //   }).catchError((err) {
  //     ShowToast.showToast(context, err);
  //   });
  // }

  void _navAuthentication() async {
    showProgressBar();
    String mobileNumber = mobileController.text;
    NetworkOperationManager.getCustomerList(mobileNumber, client).then((res) {
      hideProgressBar();
      if (res.status == Rcode.successCode) {
        customeretails = res;
        String message =
            'Dear ${customeretails.name}, We have recognized you as an existing customer of Fasttrack.';
        String message1 = 'Please click "Proceed" to update/confirm your details and choose a password.';
        showAlert(message, customeretails, message1);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpActivity(
                      mobileNumber: mobileController.text,
                    )));
      }
    }).catchError((err) {
      ShowToast.showToast(context, err);
    });
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    return version;
  }

  showAlert(String message, CustomerModel customerDetails, String message1) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff0c2d8a),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom:15.0),
                child: Container(
                  width: 140,
                  
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpActivity(
                                    customerDetails: customerDetails,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        side: BorderSide(
                          color:  Color(0xffef773c),
                          width: 2,
                        ),
                      ),
                      primary:  Color(0xffef773c),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          title: Text(
            'NOTICE',
            style: TextStyle(
              fontSize: 20,
              color:  Color(0xffef773c),
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            color: Color(0xff0c2d8a),
            height: 190,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 35, 0, 5),
                        child: Text(message,textAlign: TextAlign.center,style: TextStyle(color:Colors.white)),

                      ),
                      // SizedBox(height:5.0),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: Text(message1,textAlign: TextAlign.center,style: TextStyle(color:Colors.white)),
                        
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
