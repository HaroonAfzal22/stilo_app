import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../models/therapy.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../dialogs/custom_dialog.dart';
import '../dialogs/custom_edit_therapy_dialog.dart';

class TherapyTile extends ConsumerStatefulWidget {
  const TherapyTile({Key? key, required this.therapy}) : super(key: key);
  final Therapy therapy;

  @override
  ConsumerState<TherapyTile> createState() => _TherapyTileState();
}

class _TherapyTileState extends ConsumerState<TherapyTile> {
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> showTimePickerForTherapy() async {
    final result =
        await showTimePicker(context: context, initialTime: selectedTime);
  }

  Future<void> openEditModal() async {
    showDialog(
      context: context,
      builder: (context) => CustomEditTherapyDialog(
        therapy: widget.therapy,
      ),
    );
  }

  Future<void> openSkipModal() async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: translate(context, 'skip'),
        children: [
          //TODO tradurre
          const Text('Sei sicuro di voler saltare questa terapia?'),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                      height: 4.0.h,
                      width: 20.0.w,
                      decoration: BoxDecoration(
                        color: ref.read(flavorProvider).primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        translate(context, "skip"),
                        style: AppTheme.bodyText.copyWith(
                          color: AppColors.white,
                          fontSize: 10.0.sp,
                        ),
                        textAlign: TextAlign.center,
                      ))),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 4.0.h,
                    width: 20.0.w,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.read(flavorProvider).primary)),
                    child: Center(
                      child: Text(
                        translate(context, "cancel"),
                        style: AppTheme.bodyText.copyWith(
                          color: AppColors.black,
                          fontSize: 10.0.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> openTakeModal() async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: translate(context, 'Take'),
        children: [
          //TODO finire
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity * 0.5,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: ref.read(flavorProvider).primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4))),
                    child: Center(
                      child: Text(
                        translate(context, 'Now'),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity * 0.5,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: ref.read(flavorProvider).primary,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Center(
                      child: Text(
                        translate(context, 'At_scheduled_time'),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      color: Colors.white,
      elevation: 1,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.therapy.asWhatTime}' +
                      ' ' +
                      widget.therapy.whenToTake,
                  style: const TextStyle(color: Colors.white),
                ),
                InkWell(
                  onTap: () {
                    openEditModal();
                  },
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                if (widget.therapy.productImage == null ||
                    widget.therapy.productImage != null &&
                        widget.therapy.productImage!.isEmpty)
                  Expanded(
                      child: Image.asset(
                        'assets/images/noImage.png',
                        height: 10.0.h,
                        width: 20.0.w,
                      ),
                      flex: 4)
                else
                  Expanded(
                      child: CachedNetworkImage(
                        imageUrl: widget.therapy.productImage!,
                        height: 10.0.h,
                        width: 20.0.w,
                        errorWidget: (context, url, error) {
                          return Image.asset("assets/images/noImage.png");
                        },
                      ),
                      flex: 4),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Text(
                      widget.therapy.product.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.h3Style.copyWith(
                          fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                    ),
                    flex: 8),
              ],
            ),
          ),
          /*  const SizedBox(
            height: 2,
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    openSkipModal();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.highlight_remove,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        translate(context, "skip"),
                        style: AppTheme.h3Style.copyWith(
                            color: Colors.red,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
*/ /*
                InkWell(
                  onTap: () {
                    showTimePickerForTherapy();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.alarm_on,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        translate(context, 'change_now'),
                        style: AppTheme.h3Style.copyWith(
                            color: Colors.black,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
*/ /*
                InkWell(
                  onTap: () {
                    openTakeModal();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        translate(context, 'Take'),
                        style: AppTheme.h3Style.copyWith(
                            color: Colors.green,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
