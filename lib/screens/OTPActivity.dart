import 'dart:async';
import 'dart:io';

import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/LoginActivity.dart';
import 'package:fasttrackgarage_app/screens/mainTab.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/PrefsManager.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:pin_code_fields/pin_code_fields.dart' as iosText;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import 'ResetPasswordScreen.dart';

class OTP extends StatefulWidget {
  final String query, signature, loginPassword;
  final int mode;
  OTP({this.query, this.mode, this.signature, this.loginPassword});
  @override
  _OTP createState() => _OTP();
}

class _OTP extends State<OTP> {
  NTLMClient client;
  bool isProgressBarShown = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _otpCodeLength = 6;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);

    // FocusScope.of(context).requestFocus(FocusNode());
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
      backgroundColor: Colors.grey[100],
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
                                    ? TextFieldPin(
                                        filled: true,
                                        filledColor: Colors.white,
                                        codeLength: _otpCodeLength,
                                        boxSize: 46,
                                        filledAfterTextChange: false,
                                        textStyle: TextStyle(fontSize: 16),
                                        borderStyle: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        onOtpCallback: (code, isAutofill) =>
                                            _onOtpCallBack(code, isAutofill),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: iosText.PinCodeTextField(
                                          autoFocus: true,
                                          textInputType: TextInputType.number,
                                          length: 6,
                                          obsecureText: false,
                                          animationType:
                                              iosText.AnimationType.fade,
                                          shape: iosText
                                              .PinCodeFieldShape.underline,
                                          animationDuration:
                                              Duration(milliseconds: 300),
                                          fieldHeight: 50,
                                          fieldWidth: 35,
                                          onChanged: (value) {
                                            _otpCode = value;
                                            print(_otpCode);

                                            if (_otpCode.length == 6) {
                                              if (widget.mode == 1) {
                                                submitOtpForRegistration(
                                                    _otpCode);
                                              } else if (widget.mode == 2) {
                                                submitOTP(_otpCode);
                                              } else {
                                                debugPrint("Nothing happened");
                                              }
                                            }
                                          },
                                        ),
                                      ),

                                SizedBox(
                                  height: 32,
                                ),
                                Container(
                                  width: double.maxFinite,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (widget.mode == 1) {
                                        submitOtpForRegistration(_otpCode);
                                      } else if (widget.mode == 2) {
                                        submitOTP(_otpCode);
                                      }
                                    },
                                    child: _setUpButtonChild(),
                                    color: Color(ExtraColors.DARK_BLUE),
                                    disabledColor: Colors.blue[100],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (widget.mode == 1) {
                                      resendOtpForSignUp();
                                    } else if (widget.mode == 2) {
                                      resendOtpForForgotPw();
                                    }
                                  },
                                  child: Text(
                                    "Resend OTP",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                )
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
        _enableButton = false;
        _isLoadingButton = true;
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
        _enableButton = false;
      }
    });
  }

  _verifyOtpCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    Timer(Duration(milliseconds: 4000), () {
      setState(() {
        _isLoadingButton = false;
        _enableButton = false;
      });

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Verification OTP Code $_otpCode Success")));
    });
  }

  submitOTP(String otpPin) async {
    showProgressBar();
    await NetworkOperationManager.SubmitOTP(widget.query, otpPin, client)
        .then((res) {
      hideProgressBar();
      print("response ${res.responseBody}");
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

    NetworkOperationManager.SubmitSignUpOTP(widget.query, otpPin, client)
        .then((res) {
      if (res.status == Rcode.SUCCESS_CODE) {
        hideProgressBar();
        if (res.responseBody == "Login created successfully.") {
          ShowToast.showToast(context, res.responseBody);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginActivity()),
          // );

          //Automatically login after register
          _performLogin();
        }
      } else {
        print("suraj ${res.responseBody}");
        ShowToast.showToast(context, "Error :" + "${res.responseBody}");
      }
    });
  }

  void _performLogin() async {
    showProgressBar();
    NetworkOperationManager.logIn(widget.query, widget.loginPassword, client)
        .then((res) {
      hideProgressBar();
      if (res.status == Rcode.SUCCESS_CODE) {
        print("${res.customerEmail} ${res.customerName}");
        PrefsManager.saveLoginCredentialsToPrefs(res.customerNo,
            res.customerName, res.customerEmail, "", widget.query);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainTab()),
        );
        ShowToast.showToast(context, "Login Success");
      } else {
        print(res.errResponse);
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
}
