import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/utils/utils.dart';

import '../models/note.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class ApiService{
  
  void addNewNote({
    required BuildContext context,
    required Note note, 
    required User user,
  }) async {
  try {
    Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_ADD']!);
    final String token = user.token;
    
    var response = await http.post(
      requestUri,
      body: jsonEncode(note.toMap()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    // ignore: use_build_context_synchronously
    httpErrorHandle(
      context: context, 
      response: response, 
      onSuccess: (){
        return;
      });

  } catch (e) {
    print(e);
    showSnackBar(context, e.toString(), Constants.redColor);
    
  }
}

void deleteNote({
    required BuildContext context,
    required Note note, 
    required User user,
  }) async {
  try {
    Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_DELETE']!);
    final String token = user.token;
    
    var response = await http.delete(
      requestUri,
      body: note.toMap(),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    // ignore: use_build_context_synchronously
    httpErrorHandle(
      context: context, 
      response: response, 
      onSuccess: (){
        showSnackBar(context, 'Note Deleted Successfully', Constants.greenColor);
      });

  } catch (e) {
    showSnackBar(context, e.toString(), Constants.redColor);
    
  }
}

}