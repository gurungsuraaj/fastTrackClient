import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class ReusableAppBar {
  static getAppBar(double margin,double padding, double height, double width) {
    return  Container(
      margin: EdgeInsets.only(bottom: margin),
      padding: EdgeInsets.only(bottom: padding),
      color: Color(ExtraColors.DARK_BLUE),
//    color: Colors.white,
      height: height/6,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 310,
          child: new Image(
            image: AssetImage(
              'images/fast_track_logo.png',
            ),
          ),
        ),
      ),
    );
  }
}
