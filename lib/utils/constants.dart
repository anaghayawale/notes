import 'package:flutter/material.dart';

class Constants{

  static Color lightYellowColor = const Color.fromARGB(255, 253, 233, 157);
  static Color extraLightYellowColor = const Color.fromARGB(255, 252, 250, 217);
  static Color lightPinkColor = const Color.fromARGB(255, 255, 216, 244);
  static Color lightBlueColor = const Color.fromARGB(255, 217, 232, 252);
  static Color lightGreenColor = const Color.fromARGB(255, 176, 233, 202);
  static Color lightBrownColor = const Color.fromARGB(255, 255, 234, 221);
  static Color lightBlackColor = const Color.fromARGB(255, 171, 170, 170);
  static Color appBackgroundColor = const Color.fromARGB(255, 247, 247, 247);
  static Color greyColor = const Color.fromARGB(255, 238, 238, 238);
  static Color blackColor = const Color.fromARGB(255, 0, 0, 0);
  static Color noteCardBackgroundColor = const Color.fromARGB(255, 248, 249, 249);
  static Color whiteColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color yellowColor = const Color.fromARGB(255, 255, 179, 0);
  static Color greyTextColor = const Color.fromARGB(255, 129, 129, 129);
  static Color redColor = const Color.fromARGB(255, 255, 0, 0);
  static Color greenColor = const Color.fromARGB(255, 15, 190, 27);

  static List<Color> noteColors = [
    Constants.lightBlueColor,
    Constants.lightPinkColor,
    Constants.lightYellowColor,
    Constants.lightGreenColor,
    Constants.lightBrownColor,
    Constants.extraLightYellowColor
  ];

  static List<String> loadingQuotes = [
    "Loading your notes...",
    "Hang tight! Your notes are on the way.",
    "Did you know? Patience is a virtue!",
    // Add more quotes as needed
  ];
}

