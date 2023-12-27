import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/utils/constants.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color textColor;

  const CustomToast({
    super.key,
    required this.message,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      textColor: textColor,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Constants.yellowColor.withOpacity(0.1),
      fontSize: 16.0,
    );

    return Container();
  }
}
