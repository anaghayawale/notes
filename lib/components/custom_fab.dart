import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';

class CustomFAB extends StatelessWidget {
  final Function() onPressed;

  const CustomFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Constants.blackColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      onPressed: onPressed,
      child: Icon(Icons.add, color: Constants.whiteColor),
    );
  }
}
