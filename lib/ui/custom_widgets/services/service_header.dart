import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';

class ServiceHeader extends StatelessWidget {
  const ServiceHeader(
      {Key? key,
      required this.title,
      required this.icon,
      required this.color,
      required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 3,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
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

class ServiceHeaderSVG extends StatelessWidget {
  const ServiceHeaderSVG(
      {Key? key,
      required this.title,
      required this.image,
      required this.color,
      required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;
  final String image;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 3,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    image,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
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
