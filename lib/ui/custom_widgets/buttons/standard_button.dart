import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';

class StandardButton extends ConsumerWidget {
  const StandardButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ref.read(flavorProvider).lightPrimary,
        minimumSize: Size(
          MediaQuery.of(context).size.width,
          40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onTap,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}

class StandardButtonLight extends ConsumerWidget {
  const StandardButtonLight({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0.h),
        child: MaterialButton(
            elevation: 0,
            minWidth: 50.0.w,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0.h),
                side: BorderSide(
                  color: (ref.read(flavorProvider).lightPrimary),
                )),
            color: AppColors.white,
            textColor: (ref.read(flavorProvider).lightPrimary),
            onPressed: onTap,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: ref.read(flavorProvider).lightPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )));
  }
}
