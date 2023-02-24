import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//TODO da rivedere

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.0.w,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.all(2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
            side: BorderSide(color: color),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(fontSize: 11.0.sp, color: textColor),
        ),
      ),
    );
  }
}
