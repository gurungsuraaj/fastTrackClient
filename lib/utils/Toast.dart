import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ShowToast {
  static showToast(BuildContext context, String message) {
    Toast.show(message, context,
        duration: 3,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }
}
