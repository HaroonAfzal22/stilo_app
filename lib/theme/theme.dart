import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../models/flavor.dart';
import 'app_colors.dart';

class AppTheme {
  const AppTheme();

  static getTheme(Flavor flavor) {
    return ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: AppColors.white,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: flavor.primary),
          iconColor: flavor.primary,
          prefixIconColor: flavor.primary,
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(style: BorderStyle.solid, color: flavor.primary),
          ),
        ),
        //TODO ancora qualche bug
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarContrastEnforced: false,
            systemStatusBarContrastEnforced: false,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: flavor.primary,
            fontFamily: GoogleFonts.poppins().fontFamily,
            //TODO rivedere
            fontSize: 20.5,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black54,
          ),
        ),
        primaryColor: flavor.lightPrimary,
        cardTheme: CardTheme(color: flavor.lightPrimary),
        textTheme:
            const TextTheme(bodyText1: TextStyle(color: AppColors.black)),
        iconTheme: const IconThemeData(color: AppColors.darkGrey),
        bottomAppBarColor: flavor.lightPrimary,
        dividerColor: AppColors.lightGrey,
        primaryTextTheme: TextTheme(
          bodyText1: const TextStyle(color: AppColors.white),
          headline1: titleStyle,
          headline2: h1Style(flavor.lightPrimary),
          subtitle2: h5Style,
        ));
  }

  static TextStyle titleStyle = TextStyle(
      color: AppColors.black, fontSize: 20.0.sp, fontWeight: FontWeight.w500);

  static TextStyle bodyText =
      TextStyle(color: AppColors.lightGrey, fontSize: 12.0.sp);

  static TextStyle subTitleStyle = TextStyle(
      color: AppColors.grey, fontSize: 12.0.sp, fontWeight: FontWeight.w400);

  static TextStyle h1Style(Color lightPrimary) {
    return TextStyle(
        fontSize: 22.0.sp, fontWeight: FontWeight.bold, color: lightPrimary);
  }

  static TextStyle h2Style = TextStyle(
    fontSize: 22.0.sp,
  );

  static TextStyle h3Style = TextStyle(
    fontSize: 20.0.sp,
  );

  static TextStyle h4Style = TextStyle(
    fontSize: 18.0.sp,
  );
  static TextStyle h5Style = TextStyle(
    fontSize: 16.0.sp,
  );
  static TextStyle h6Style =
      TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w400);

  static List<BoxShadow> shadow = <BoxShadow>[
    const BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
