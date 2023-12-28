import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Constants.blackColor,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.loadingQuotes[
              Random().nextInt(Constants.loadingQuotes.length)],
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Constants.greyTextColor,
          ),
        ),
      ],
    );
  }
}
