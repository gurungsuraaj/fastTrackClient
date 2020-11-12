import 'package:fasttrackgarage_app/helper/NetworkOperationManager.dart';
import 'package:fasttrackgarage_app/helper/ntlmclient.dart';
import 'package:fasttrackgarage_app/screens/LoginActivity.dart';
import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:fasttrackgarage_app/utils/Toast.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ntlm/ntlm.dart';

import 'OutletActivity.dart';

class ResetPasswordScreen extends StatefulWidget {
  String mobile;
  ResetPasswordScreen(this.mobile);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
  TextEditingController passwordController =
      new TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      new TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(ExtraColors.DARK_BLUE),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: Column(
          children: <Widget>[
            ReusableAppBar.getAppBar(0, 0, height, width),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text(
                  "Reset Your Password",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              width: width * 0.7,
              child: TextField(
                obscureText: true,
                style:
                    TextStyle(fontSize: fontSizeTextField, color: Colors.white),
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'New password',
                  hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              width: width * 0.7,
              child: TextField(
                obscureText: true,
                style:
                    TextStyle(fontSize: fontSizeTextField, color: Colors.white),
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  hintStyle: TextStyle(color: Color(0xffb8b8b8)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
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
                    FocusScope.of(context).requestFocus(FocusNode());
                    submitPassword();
                  },
                  child: Text(
                    "Reset",
                    style: TextStyle(color: Color(ExtraColors.DARK_BLUE)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitPassword() async {
    showProgressBar();
    if (passwordController.text == confirmPasswordController.text) {
      await NetworkOperationManager.saveNewPassword(
              widget.mobile, passwordController.text, client)
          .then((res) {
        hideProgressBar();
        print("Response password ${res.responseBody}");
        if (res.status == 200) {
   
            ShowToast.showToast(context, res.responseBody);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginActivity()),
            );
         
        } else {
          ShowToast.showToast(context, res.responseBody);
        }
      }).catchError((err) {
        displaySnackbar(context, err);
      });
    } else {
      ShowToast.showToast(context, "Password didnt match");
      setState(() {
        passwordController.text = "";
        confirmPasswordController.text = "";
      });
    }
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
