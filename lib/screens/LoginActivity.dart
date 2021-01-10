import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/ForgotPasswordScreen.dart';
import 'package:fasttrackgarage_app/screens/mainTab.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:fasttrackgarage_app/widgets/CustomClipper.dart';
import 'package:flutter/gestures.dart';
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
  String phoneCode = "971";

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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF39C1B),
        key: _scaffoldKey,
        resizeToAvoidBottomInset : false,
        body: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          dismissible: false,
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
                          ReusableAppBar.getAppBar(0, 0, height, width),
                          Container(
                            margin:
                                EdgeInsets.fromLTRB(0, height * 0.042, 0, 0),
                            child: Text(
                              "Login to your account",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ), //Container
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    Container(
                                      child: TextField(
                                        obscureText: true,
                                        style: TextStyle(
                                            fontSize: fontSizeTextField,
                                            color: Color(
                                                ExtraColors.DARK_BLUE_ACCENT)),
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            hintText: 'Your password',
                                            hintStyle: TextStyle(
                                                color: Color(0xffb8b8b8)),
                                            fillColor: Colors.white,
                                            filled: true,
                                            prefixIcon: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 20, 0),
                                              child: CircleAvatar(
                                                  // radius: 5,
                                                  backgroundColor:
                                                      Color(0xffe6a764),
                                                  child: Icon(
                                                    Icons.lock_outline,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey[300])),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey[300]))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Container(
                                      width: width * 0.45,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
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
                                          style: TextStyle(
                                              color:
                                                  Color(ExtraColors.DARK_BLUE)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Dont have account?",
                                          style: TextStyle(color: Colors.white),
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
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordScreen()));
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "All right reserve © 2020",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(width: 10),
                                        FutureBuilder(
                                          future: getVersionNumber(),
                                          builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) =>
                                              Text(
                                            snapshot.hasData
                                                ? "v${snapshot.data}"
                                                : "Loading ...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
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
    );
  }

  Widget customContainer(orientation) {
    if (orientation == Orientation.portrait) {
      return ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            color: Color(ExtraColors.DARK_BLUE),
          ));
    } else {
      return ClipPath(
          clipper: CustomShapeClipperLandscape(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            color: Color(ExtraColors.DARK_BLUE),
          ));
    }
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

    String mobileNumber = phoneCode + mobileController.text;
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
        // performLogin();
        _performLogin();
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

  _buildCountryPickerDropdown(
          {bool filtered = false,
          bool sortedByIsoCode = false,
          bool hasPriorityList = false}) =>
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
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
                Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Image.asset('icons/flags/png/ae.png',
                        package: 'country_icons')),
                SizedBox(width: 5),
                Text(
                  '+971(AE)',
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
                keyboardType: TextInputType.number,
                controller: mobileController,
                decoration: InputDecoration(
                  hintText: "Phone...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
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

  void _performLogin() async {
    showProgressBar();
    String mobileNumber = mobileController.text;
    NetworkOperationManager.logIn(mobileNumber, passwordController.text, client)
        .then((res) {
      hideProgressBar();
      if (res.status == Rcode.SUCCESS_CODE) {
        print("${res.customerEmail} ${res.customerName}");
        PrefsManager.saveLoginCredentialsToPrefs(res.customerNo,
            res.customerName, res.customerEmail, "", mobileController.text);

        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => MainTab())));
        ShowToast.showToast(context, "Login Success");
      } else {
        print(res.errResponse);
        ShowToast.showToast(context, res.errResponse);
      }
    }).catchError((err) {
      ShowToast.showToast(context, err);
    });
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print(version);

    return version;
  }
}
