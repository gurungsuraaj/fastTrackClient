import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/ReusableAppBar.dart';
import 'package:flutter/material.dart';


class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var fontSizeTextField = 14.0;
  TextEditingController passwordController =
  new TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(ExtraColors.DARK_BLUE),
      body: Column(children: <Widget>[

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
            style: TextStyle(
                fontSize: fontSizeTextField,
                color: Colors.white),
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'New password',
              hintStyle: TextStyle(
                  color: Color(0xffb8b8b8)),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          width: width * 0.7,
          child: TextField(
            obscureText: true,
            style: TextStyle(
                fontSize: fontSizeTextField,
                color: Colors.white),
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Confirm password',
              hintStyle: TextStyle(
                  color: Color(0xffb8b8b8)),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Colors.white),
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
                borderRadius:
                new BorderRadius.circular(18.0),
              ),
              color: Colors.white,
              onPressed: () {
                FocusScope.of(context)
                    .requestFocus(FocusNode());
              },
              child: Text(
                "Reset",
                style: TextStyle(
                    color: Color(ExtraColors.DARK_BLUE)),
              ),
            ),
          ),
        ),
      ],),
    );
  }
}
