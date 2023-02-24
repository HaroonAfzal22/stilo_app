import 'package:flutter/material.dart';

Color? hexToColor(String code) {
  print("$code Text Color");
  try {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  } catch (e) {
    print(e);
  }
  return null;
}

class AppColors {
  // Color? text_color = hexToColor(PreferenceUtils.getString("primary"));

  //use button color from these colors only
  // static const Color primary = Color(0xff00837D);
  // static Color primary = hexToColor(
  //     PreferenceUtils.getString("primary") != "null"
  //         ? PreferenceUtils.getString("primary")
  //         : "#00837D");

  //static const Color primary = Color(0xff00837D);
  //static const Color lightPrimary = Color(0xff19b2a5);
  static const Color iconColor = Color(0xff1CBDCF);
  static const Color scaffoldBackground = Color(0xffC4E2E1);
  static const Color toastText = Color(0xff3699FF);

//use black color for title text
  static const Color black = Color(0xff000000);

//use light_grey in description text
  static const lightGrey = Color(0xff979797);
  static const grey = Color(0xFFD5D5D5);
  static const therapyGrey = Color(0xFFf7f4f4);
  static const Color white = Color(0xffffffff);
  static const Color darkGrey = Color(0xff3E3E3E);
  static const Color orderTextColor = Color.fromRGBO(74, 75, 77, 1);
  static const Color veryDarkGrey = Color(0xff4F4F4F);
  static const Color darkRed = Color(0xffFF443D);
  static const Color purple = Color(0xff9F87F7);

  static const Color facebookButtonColor = Color(0xff367FC0);
  static const Color googleButtonColor = Color(0xffDD4B39);

  static const Color blueColor = Color(0xFF3699FF);

  static const Color productBgColor = Color(0xFBE5C2C6);

  static const Color lightSaffron = Color(0xffFBF3E9);
  static const Color yellow = Color(0xffFFC107);

  static const Color lightBlue = Color(0xff5285F5);
}
