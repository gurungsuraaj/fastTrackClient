import 'dart:io';

import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/mainTab.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/Rstring.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:pin_code_fields/pin_code_fields.dart' as iosText;
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import 'ResetPasswordScreen.dart';

class OTP extends StatefulWidget {
  final String query, signature, loginPassword;
  final int mode;

  String customerName, mobileNum, customerNo;
  OTP(
      {this.query,
      this.mode,
      this.signature,
      this.loginPassword,
      this.customerName,
      this.mobileNum,
      this.customerNo});
  @override
  _OTP createState() => _OTP();
}

class _OTP extends State<OTP> {
  NTLMClient client;
  bool isProgressBarShown = false;
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _otpCodeLength = 6;
  // bool _isLoadingButton = false;
  // bool _enableButton = false;
  String _otpCode = "";

  @override
  void initState() {
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.ntlmUsername, Constants.ntlmPassword);

    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    // var _scaffoldKey = new GlobalKey<ScaffoldState>();
    bool isProgressBarShown = false;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double margin = 10.0;
    // double padding = 10.0;

    // TextEditingController controller = TextEditingController();

    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isProgressBarShown,
          child: Builder(
            builder: (context) => Container(
              color: Color(0xff253983),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ReusableAppBar.getAppBar(0, 0, height, width),
                  //Container
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          color: Color(0xff253983),
                          child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Container(
                                // margin: EdgeInsets.only(top: margin),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ENTER',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                        Text(
                                          ' OTP',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 20, top: 10),
                                      child: Text(
                                        'Please enter the OTP to proceed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    // Center(
                                    //   child: PinPut(
                                    //     autoFocus: false,
                                    //     actionButtonsEnabled: true,
                                    //     clearInput: true,
                                    //     fieldsCount: 6,
                                    //     onClear: (String pin) {
                                    //       debugPrint('$pin');
                                    //       setState(() {
                                    //         pin = '';
                                    //       });
                                    //     },
                                    //     onSubmit: (String pin) {
                                    //       //_showSnackBar(pin, context);
                                    //       if (widget.mode == 1) {
                                    //         submitOtpForRegistration(pin);
                                    //       } else if (widget.mode == 2) {
                                    //         submitOTP(pin);
                                    //       }
                                    //     },
                                    //   ),
                                    // ),
                                    Platform.isAndroid
                                        ? Container(
                                            width: width,
                                            child: TextFieldPin(
                                              filled: true,
                                              filledColor: Colors.white,
                                              codeLength: _otpCodeLength,
                                              boxSize: 35,
                                              filledAfterTextChange: true,
                                              textStyle:
                                                  TextStyle(fontSize: 16),
                                              borderStyle: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              onOtpCallback:
                                                  (code, isAutofill) =>
                                                      _onOtpCallBack(
                                                          code, isAutofill),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 50),
                                            child: iosText.PinCodeTextField(
                                              autoFocus: true,
                                              textInputType:
                                                  TextInputType.number,
                                              length: 6,
                                              obsecureText: false,
                                              animationType:
                                                  iosText.AnimationType.fade,
                                              shape: iosText
                                                  .PinCodeFieldShape.underline,
                                              animationDuration:
                                                  Duration(milliseconds: 300),
                                              fieldHeight: 50,
                                              fieldWidth: 30,
                                              onChanged: (value) {
                                                _otpCode = value;

                                                if (_otpCode.length == 6) {
                                                  if (widget.mode == 1) {
                                                    submitOtpForRegistration(
                                                        _otpCode);
                                                  } else if (widget.mode == 2) {
                                                    submitOTP(_otpCode);
                                                  } else if (widget.mode == 3) {
                                                    updateExistedCustomerInfo(
                                                        _otpCode);
                                                  }
                                                }
                                              },
                                            ),
                                          ),

                                    SizedBox(
                                      height: 32,
                                    ),
                                    Container(
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                                color: Colors.transparent)),
                                        onPressed: () {
                                          if (widget.mode == 1) {
                                            submitOtpForRegistration(_otpCode);
                                          } else if (widget.mode == 2) {
                                            submitOTP(_otpCode);
                                          } else if (widget.mode == 3) {
                                            updateExistedCustomerInfo(_otpCode);
                                          }
                                        },
                                        child: _setUpButtonChild(),
                                        color: Colors.orange,
                                        disabledColor: Colors.blue[100],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (widget.mode == 1) {
                                          resendOtpForSignUp();
                                        } else if (widget.mode == 2) {
                                          resendOtpForForgotPw();
                                        } else if (widget.mode == 3) {
                                          resendOtpForExistingCustomer();
                                        }
                                      },
                                      child: Text(
                                        "Resend OTP",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '1',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '2',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '4',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '5',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '6',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '7',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '8',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '9',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.orange,
                                                      // width: 5,
                                                    ),
                                                    color: Colors.transparent),
                                                child: Text(
                                                  '0',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              // decoration: BoxDecoration(
                                              //     shape: BoxShape.circle,
                                              //     border: Border.all(
                                              //       color: Colors.orange,
                                              //       // width: 5,
                                              //     ),
                                              //     color: Colors.transparent),
                                              // child: IconButton(
                                              //   icon: Icon(
                                              //     Icons.arrow_back_rounded,
                                              //     size: 20,
                                              //     color: Colors.white,
                                              // ),
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _setUpButtonChild() {
    return Text(
      "Verify",
      style: TextStyle(color: Colors.white),
    );
  }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      this._otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        // _enableButton = false;
        // _isLoadingButton = true;
        if (widget.mode == 1) {
          submitOtpForRegistration(_otpCode);
        } else if (widget.mode == 2) {
          submitOTP(_otpCode);
        } else {
          debugPrint("Nothing happened");
        }
      }
      //  else if (otpCode.length == _otpCodeLength && !isAutofill) {
      //   _enableButton = true;
      //   _isLoadingButton = false;
      // }
      else {
        // _enableButton = false;
      }
    });
  }

  // _verifyOtpCode() {
  //   FocusScope.of(context).requestFocus(new FocusNode());
  //   Timer(Duration(milliseconds: 4000), () {
  //     setState(() {
  //       // _isLoadingButton = false;
  //       // _enableButton = false;
  //     });

  //     _scaffoldKey.currentState.showSnackBar(
  //         SnackBar(content: Text("Verification OTP Code $_otpCode Success")));
  //   });
  // }

  submitOTP(String otpPin) async {
    showProgressBar();
    await NetworkOperationManager.submitOTP(widget.query, otpPin, client)
        .then((res) {
      hideProgressBar();
      if (res.status == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ResetPasswordScreen(widget.query))));
      } else {
        ShowToast.showToast(context, res.responseBody);
      }
    }).catchError((err) {
      ShowToast.showToast(context, err);
    });
  }

  submitOtpForRegistration(String otpPin) async {
    showProgressBar();

    NetworkOperationManager.submitSignUpOTP(widget.query, otpPin, client)
        .then((res) {
      hideProgressBar();

      if (res.status == Rcode.successCode) {
        // ShowToast.showToast(context, res.responseBody);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginActivity()),
        // );

        //Automatically login after register
        _performLogin();
      } else {
        ShowToast.showToast(context, "Error :" + "${res.responseBody}");
      }
    });
  }

  void _performLogin() async {
    showProgressBar();
    NetworkOperationManager.logIn(widget.query, widget.loginPassword, client)
        .then((res) {
      hideProgressBar();
      if (res.status == Rcode.successCode) {
        PrefsManager.saveLoginCredentialsToPrefs(res.customerNo,
            res.customerName, res.customerEmail, "", widget.query);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainTab()),
        );
        ShowToast.showToast(context, "Login Success");
      } else {
        ShowToast.showToast(context, res.errResponse);
      }
    }).catchError((err) {
      ShowToast.showToast(context, err);
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
    NetworkOperationManager.resendOtpForSignUp(
            widget.query, widget.signature, client)
        .then((res) {
      hideProgressBar();
    }).catchError((err) {
      hideProgressBar();
    });
  }

  resendOtpForForgotPw() async {
    showProgressBar();
    NetworkOperationManager.resendOtpForForgetPw(
            widget.query, widget.signature, client)
        .then((value) {})
        .catchError((err) {
      hideProgressBar();
    });
  }

  void updateExistedCustomerInfo(String otp) async {
    showProgressBar();

    NetworkOperationManager.verifyExistingCustomerOTP(
            widget.mobileNum,
            widget.customerName,
            widget.query,
            widget.loginPassword,
            otp,
            client)
        .then((res) {
      hideProgressBar();
      if (res.responseBody == Rstring.otpVerified || res.status == 200) {
        // Save the data locally and navigate to the Home screen.

        PrefsManager.saveLoginCredentialsToPrefs(widget.customerNo,
            widget.customerName, widget.query, "", widget.mobileNum);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainTab()),
        );
      } else {
        ShowToast.showToast(context, "Error :" + "${res.responseBody}");
      }
    }).catchError((e) {
      hideProgressBar();
      print("Error $e");
    });
  }

  void resendOtpForExistingCustomer() async {
    showProgressBar();

    NetworkOperationManager.resendExistingCustomerOTP(widget.mobileNum, client)
        .then((res) {
      hideProgressBar();
      if (res.responseBody == Rstring.otpSendSuccess) {
        ShowToast.showToast(context, "${res.responseBody}");
      } else {
        ShowToast.showToast(context, "Error :" + "${res.responseBody}");
      }
    }).catchError((e) {
      hideProgressBar();
      print(e);
    });
  }
}
