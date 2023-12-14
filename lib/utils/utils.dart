import 'dart:convert';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

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

bool isValidEmail(String email) {
  RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

void httpErrorHandle({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess
}){

  switch(response.statusCode){
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['message'], Colors.red);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error'], Colors.red);
      break;
    default:
      showSnackBar(context, jsonDecode(response.body)['message'], Colors.red);
      break;
  }
}

