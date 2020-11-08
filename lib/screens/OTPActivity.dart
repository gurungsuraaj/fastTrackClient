import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/LoginActivity.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'ResetPasswordScreen.dart';

class OTP extends StatefulWidget {
  String query;
  int mode;
  OTP(this.query, this.mode);
  @override
  _OTP createState() => _OTP();
}

class _OTP extends State<OTP> {
  NTLMClient client;
  bool isProgressBarShown = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
  }

  @override
  Widget build(BuildContext context) {
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    bool isProgressBarShown = false;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double MARGIN = 24.0;
    double PADDING = 10.0;

    TextEditingController controller = TextEditingController();

    // TODO: implement build
    return Scaffold(
      // key: _scaffoldKey,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          child: Builder(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ReusableAppBar.getAppBar(0, PADDING, height, width),
                //Container
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            margin: EdgeInsets.only(top: MARGIN),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'ENTER OTP',
                                  style: TextStyle(
                                      color: Colors.blue[800], fontSize: 25),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 35, top: 10),
                                  child: Text(
                                    'Please enter the OTP to proceed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Center(
                                  child: PinPut(
                                    autoFocus: false,
                                    actionButtonsEnabled: true,
                                    clearInput: true,
                                    fieldsCount: 6,
                                    onClear: (String pin) {
                                      debugPrint('$pin');
                                      setState(() {
                                        pin = '';
                                      });
                                    },
                                    onSubmit: (String pin) {
                                      //_showSnackBar(pin, context);
                                      if (widget.mode == 1) {
                                        submitOtpForRegistration(pin);
                                      } else if (widget.mode == 2) {
                                        submitOTP(pin);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submitOTP(String otpPin) async {
    showProgressBar();
    await NetworkOperationManager.SubmitOTP(widget.query, otpPin, client)
        .then((res) {
      hideProgressBar();
      print("response ${res.responseBody}");
      if (res.status == 200) {
        if (res.responseBody == "true") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ResetPasswordScreen(widget.query))));
        } else {
          ShowToast.showToast(context, "No response ${res.responseBody}");
        }
      } else {
        ShowToast.showToast(context, res.responseBody);
      }
    }).catchError((err) {
      ShowToast.showToast(context, err);
    });
  }

  submitOtpForRegistration(String otpPin) async {
    showProgressBar();

    NetworkOperationManager.SubmitSignUpOTP(widget.query, otpPin, client)
        .then((res) {
      if (res.status == Rcode.SUCCESS_CODE) {
        hideProgressBar();
        if (res.responseBody == "Login created successfully.") {
          ShowToast.showToast(context, res.responseBody);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginActivity()),
              ModalRoute.withName("/LoginActivity"));
        }
      } else {
        print("suraj ${res.responseBody}");
        ShowToast.showToast(context, "Error :" + "${res.responseBody}");
      }
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

  resendOtpForSignUp() async {
    showProgressBar();
    NetworkOperationManager.resendOtpForSignUp(widget.query, client)
        .then((res) {
      hideProgressBar();
    }).catchError((err) {
      hideProgressBar();
    });
  }

  resendOtpForForgotPw() async {
    showProgressBar();
    NetworkOperationManager.resendOtpForForgetPw(widget.query, client)
        .then((value) {})
        .catchError((err) {
      hideProgressBar();
    });
  }
}
