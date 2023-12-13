import 'package:flutter/material.dart';
import 'constants.dart';

void showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: color),textAlign: TextAlign.center,),
      duration: const Duration(seconds: 3),
      backgroundColor: Constants.greyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.all(15.0),
      behavior: SnackBarBehavior.floating,
      elevation: 0.0,
    ),
  );
}

