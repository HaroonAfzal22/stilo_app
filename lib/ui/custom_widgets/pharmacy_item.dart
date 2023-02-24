import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme.dart';

class PharmacyItemIcon extends StatelessWidget {
  const PharmacyItemIcon({
    Key? key,
    required this.imgUrl,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  final IconData imgUrl;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: color,
                ),
                child: FittedBox(
                  child: Icon(
                    imgUrl,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTheme.bodyText
                  .copyWith(fontSize: 9.0.sp, color: AppColors.darkGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class PharmacyItemSVG extends StatelessWidget {
  const PharmacyItemSVG({
    Key? key,
    required this.imgUrl,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  final String imgUrl;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: color,
              ),
              child: FittedBox(
                child: SvgPicture.asset(
                  imgUrl,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTheme.bodyText
                  .copyWith(fontSize: 9.0.sp, color: AppColors.darkGrey),
            ),
          ],
        ),
      ),
    );
  }
}
