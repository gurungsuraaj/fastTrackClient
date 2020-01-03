import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ShowToast {
  static showToast(BuildContext context, String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Color(ExtraColors.DARK_BLUE),
        textColor: Colors.white);
  }
}
