import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var fontSizeTextField = 14.0;
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(ExtraColors.DARK_BLUE),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ReusableAppBar.getAppBar(0, 0, height, width),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              width: width * 0.8,
              child: TextFormField(
                validator: (val) =>
                !val.contains('@') ? 'Invalid Email' : null,
                style: TextStyle(
                    fontSize: fontSizeTextField,
                    color: Colors.white),
                controller: emailController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.white),
                    ),
                    hintText: 'Your e-mail',
                    hintStyle:
                    TextStyle(color: Color(0xffb8b8b8))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitEmail() async{

  }
}
