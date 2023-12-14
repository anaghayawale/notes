import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/loading_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class AuthServices{

  //method to sign up user
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {

    try{
      
      User user = User(
        id: '', 
        name: name, 
        email: email, 
        password: password, 
        token: '');

      http.Response res = await http.post(
        Uri.parse(dotenv.env['NODE_API_POST_SIGNUP']!),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json'
        }
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        context: context, 
        response: res, 
        onSuccess: (){
          showSnackBar(context, 'Account created! Login with the same credentials', Constants.greenColor);
        }
      );
    } catch(e){
      showSnackBar(context, e.toString(), Constants.redColor);
    } finally {
      Provider.of<LoadingProvider>(context, listen: false).stopLoading();
    }

  }

}
