import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class AppBarWithTitle{
  static getAppBar(String title) {
    return  AppBar(
        backgroundColor: Color(ExtraColors.DARK_BLUE),
        title: Text(title),
      );
  }

}