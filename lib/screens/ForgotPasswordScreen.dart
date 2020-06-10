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

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  NTLMClient client;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isProgressBarShown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client =
        NTLM.initializeNTLM(Constants.NTLM_USERNAME, Constants.NTLM_PASSWORD);
  }

  var fontSizeTextField = 14.0;
  TextEditingController emailController = new TextEditingController();
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
              Container(
                padding: EdgeInsets.only(top: 15),
                width: width * 0.8,
                child: TextFormField(
                  validator: (val) =>
                      !val.contains('@') ? 'Invalid Email' : null,
                  style: TextStyle(
                      fontSize: fontSizeTextField, color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'Your e-mail',
                      hintStyle: TextStyle(color: Color(0xffb8b8b8))),
                ),
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
                      submitEmail();
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

  void submitEmail() async {
    showProgressBar();
    await NetworkOperationManager.generateOTP(emailController.text, client)
        .then((res) {
          print("suraj ${res.responseBody}");
      hideProgressBar();
      if (res.status == 200) {
        if (res.responseBody == Constants.OTP_GENERATE_SUCCESS) {
          ShowToast.showToast(context, res.responseBody);
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => OTP(emailController.text))));
        }
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
}
