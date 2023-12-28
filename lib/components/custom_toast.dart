import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/utils/constants.dart';

class CustomToast {
  static void showToast({
    required String message,
    required Color textColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      textColor: textColor,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Constants.yellowColor.withOpacity(0.1),
      fontSize: 16.0,
    );
  }
}
