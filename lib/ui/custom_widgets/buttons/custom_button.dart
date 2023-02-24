import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';

class CustomButton extends ConsumerWidget {
  final String text;
  final double? fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final VoidCallback onTap;

  const CustomButton({
    required this.text,
    required this.onTap,
    this.fontSize,
    this.color = AppColors.white,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.w800,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 30),
      width: 70.0.w,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0.h),
          child: Card(
            margin: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.6.h),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  (ref.read(flavorProvider).lightPrimary),
                  (ref.read(flavorProvider).lightPrimary),
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
              )),
              child: Text(
                text,
                textAlign: textAlign,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: color,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
