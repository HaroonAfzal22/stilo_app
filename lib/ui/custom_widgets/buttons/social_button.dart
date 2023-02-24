import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_colors.dart';

class SocialButtons extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;
  final String image;

  const SocialButtons(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.color,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0.w,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 1.0.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.h))),
        ),
        onPressed: onTap,
        label: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0.h),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: AppColors.white,
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        icon: Image.asset(
          image,
          height: 2.8.h,
          width: 2.8.h,
        ),
      ),
    );
  }
}
