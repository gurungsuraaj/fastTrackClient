import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
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
  String email;
  OTP(this.email);
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
                                      submitOTP(pin);
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
    await NetworkOperationManager.SubmitOTP(widget.email, otpPin, client)
        .then((res) {
      hideProgressBar();
      print("response ${res.responseBody}");
      if (res.status == 200) {
        if (res.responseBody == "true") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ResetPasswordScreen(widget.email))));
        }else{
          ShowToast.showToast(context, "No response ${res.responseBody}");
        }
      } else {
       ShowToast.showToast(context, res.responseBody);
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
}
