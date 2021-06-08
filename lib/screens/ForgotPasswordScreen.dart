import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/OTPActivity.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  NTLMClient client;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isProgressBarShown = false;
  String signature;
  String phoneCode = "971";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
    _getSignatureCode();
  }

  _getSignatureCode() async {
    signature = await SmsRetrieved.getAppSignature();
  }

  var fontSizeTextField = 14.0;
  TextEditingController mobileController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(ExtraColors.DARK_BLUE),
      appBar: AppBar(
        backgroundColor: Color(ExtraColors.DARK_BLUE),
        title: Text("Forgot Password"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        dismissible: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ReusableAppBar.getAppBar(0, 0, height, width),
//            Center(
//              child: Container(
//                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
//                child: Text(
//                  "Forgot Password",
//                  style: TextStyle(color: Colors.white, fontSize: 16),
//                ),
//              ),
//            ),
              SizedBox(
                height: 40,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    width: width * 0.9,
                    child: _buildCountryPickerDropdown(),
                  ),
                ],
              ),

              Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 5),
                  width: width * 0.45,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      // performLogin();
                      FocusScope.of(context).requestFocus(FocusNode());
                      submitMobileNum();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Color(ExtraColors.DARK_BLUE)),
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

  // void submitMobileNum() async {
  //   showProgressBar();
  //   await NetworkOperationManager.generateOTP(emailController.text, client)
  //       .then((res) {
  //         print("suraj ${res.responseBody}");
  //     hideProgressBar();
  //     if (res.status == 200) {
  //       if (res.responseBody == Constants.OTP_GENERATE_SUCCESS) {
  //         ShowToast.showToast(context, res.responseBody);
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: ((context) => OTP(emailController.text,2))));
  //       }
  //     } else {}
  //   }).catchError((err) {
  //     displaySnackbar(context, err);
  //   });
  // }

  void submitMobileNum() async {
    showProgressBar();
    await NetworkOperationManager.forgotPassOtp(
      mobileController.text,
      signature,
      client,
    ).then((res) {
      print("suraj ${res.responseBody}");
      hideProgressBar();
      if (res.status == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => OTP(
                    query: mobileController.text,
                    mode: 2,
                    signature: signature))));
      } else {}
    }).catchError((err) {
      displaySnackbar(context, err);
    });
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
        ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
          Text(
            '+971',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: mobileController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Phone...",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
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
}
