import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

class AppBarWithTitle {
  static getAppBar(String title) {
    return AppBar(
       centerTitle: true,
      backgroundColor: Color(ExtraColors.darkBlue),
      title: Text(title),
    );
  }
}
