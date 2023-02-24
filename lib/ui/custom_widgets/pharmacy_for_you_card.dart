import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme.dart';

class PharmacyForYouCard extends StatelessWidget {
  const PharmacyForYouCard({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.color,
  }) : super(key: key);
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: FittedBox(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 7,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTheme.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0.sp,
                    color: AppColors.darkGrey),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2.0,
              blurRadius: 2.0,
            )
          ],
        ),
      ),
    );
  }
}
