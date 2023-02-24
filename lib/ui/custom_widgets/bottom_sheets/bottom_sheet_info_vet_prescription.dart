import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';

class BottomSheetInfoVetPrescription extends ConsumerWidget {
  const BottomSheetInfoVetPrescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 0, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      ic_cancel,
                      height: 20,
                      width: 20,
                      color: AppColors.darkGrey,
                    )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "info_send_Recipes"),
                  style: AppTheme.titleStyle.copyWith(
                      fontSize: 16.0.sp, fontWeight: FontWeight.bold)),
              Text(
                  translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? "info_send_Recipes_des_parapharmacy"
                          : "info_send_Recipes_des_pharmacy"),
                  style: AppTheme.h3Style.copyWith(
                      color: AppColors.darkGrey.withOpacity(.7),
                      fontSize: 12.0.sp))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "info_veterinary_send_Recipes"),
                  style: AppTheme.h1Style(ref.read(flavorProvider).lightPrimary)
                      .copyWith(fontSize: 12.0.sp)),
              const SizedBox(
                height: 5,
              ),
              Text(translate(context, "info_veterinary_send_Recipes_des"),
                  style: AppTheme.h3Style
                      .copyWith(color: AppColors.darkGrey, fontSize: 12.0.sp))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(ic_Veterinary_infoimage),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "recipe_via_photo"),
                  style: AppTheme.h1Style(ref.read(flavorProvider).lightPrimary)
                      .copyWith(fontSize: 12.0.sp)),
              Text(translate(context, "recipe_via_photo_des"),
                  style: AppTheme.h6Style)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
