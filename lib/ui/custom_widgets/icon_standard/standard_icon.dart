import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IconStandard extends StatelessWidget {
  const IconStandard({
    Key? key,
    required this.icon,
    required this.backgroundColor,
    this.text,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Color backgroundColor;
  final String? text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: FittedBox(
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          if (text != null)
            Text(
              text!,
              textAlign: TextAlign.center,
              //maxLines: 1,
              //overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                height: 1,
                fontSize: 9.0.sp,
                color: const Color(0xff454545),
              ),
            )
        ],
      ),
    );
  }
}
