import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double? height;

  const TitleText(
      {Key? key,
      required this.text,
      this.fontSize = 18,
      this.height = 1,
      this.color = AppColors.white,
      required this.textAlign,
      this.fontWeight = FontWeight.w800})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: fontSize,
          height: height,
          fontWeight: fontWeight,
          color: color),
    );
  }
}
