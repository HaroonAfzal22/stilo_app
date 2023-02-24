import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';

class PharmaHeader extends StatelessWidget {
  const PharmaHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imgUrl,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Image.asset(imgUrl)),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: AppTheme.h6Style.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  subtitle,
                  style: AppTheme.h3Style.copyWith(
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey.withOpacity(.5),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PharmaHeaderSVG extends StatelessWidget {
  const PharmaHeaderSVG({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.imgUrl,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Color color;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: FittedBox(
                  child: SvgPicture.asset(
                    imgUrl,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: AppTheme.h6Style.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  subtitle,
                  style: AppTheme.h3Style.copyWith(
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey.withOpacity(.5),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
