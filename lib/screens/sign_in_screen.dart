import 'package:flutter/material.dart';
import 'package:notes/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import '../providers/loading_provider.dart';
import '../services/auth_services.dart';
import '../utils/constants.dart';
import '../utils/custom_text_field.dart';
import '../utils/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthServices authServices = AuthServices();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signInUser(){

    if( _emailController.text.isEmpty || _passwordController.text.isEmpty) { 
      showSnackBar(context, 'Please fill all the fields', Constants.redColor);
      return;
    }
    if(_passwordController.text.length < 6) { 
      showSnackBar(context, 'Password must be at least 6 characters', Constants.redColor);
      return;
    }
    if(!isValidEmail(_emailController.text)) {
    showSnackBar(context, 'Please enter a valid email address', Constants.redColor);
    return;
    }
    Provider.of<LoadingProvider>(context, listen: false).startLoading();
    authServices.signInUser(
      context: context, 
      email: _emailController.text,
      password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 2.0,
                      color: Constants.yellowColor,
                    ),
                    color: Constants.noteCardBackgroundColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Notes!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Sign in to your account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Constants.greyTextColor,
                  ),
                ),
                const SizedBox(height: 14),
                CustomTextField(text: "Email", controller: _emailController),
                const SizedBox(height: 12),
                CustomTextField(
                  text: "Password",
                  controller: _passwordController,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Constants.yellowColor,
                  ),
                  child: TextButton(
                    onPressed: signInUser,
                    child: Consumer<LoadingProvider>(
                      builder: (context, value, child) {
                        if(value.isLoading){
                          return CircularProgressIndicator(color: Constants.whiteColor,);
                        } else {
                          return Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Constants.whiteColor,
                        ),
                      );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Constants.greyTextColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Constants.yellowColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}