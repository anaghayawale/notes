import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  const CustomTextField(
      {super.key, required this.text, required this.controller});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.text == 'Password' ? !isPasswordVisible : false,
      controller: widget.controller,
      style: TextStyle(
        fontSize: 18.0,
        color: Constants.greyTextColor,
      ),
      cursorColor: Constants.blackColor,
      decoration: InputDecoration(
        suffixIcon: widget.text == 'Password'
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Constants.greyTextColor,
                ),
              )
            : null,
        labelText: widget.text,
        labelStyle: TextStyle(
          color: Constants.greyTextColor,
          fontWeight: FontWeight.w500,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Constants.blackColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Constants.blackColor,
          ),
        ),
        floatingLabelStyle: TextStyle(
          color: Constants.blackColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
