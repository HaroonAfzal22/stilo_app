import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/therapies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../models/pill.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../dialogs/custom_dialog.dart';
import '../dialogs/custom_edit_therapy_dialog.dart';

class PillTile extends ConsumerStatefulWidget {
  const PillTile({
    Key? key,
    required this.pill,
  }) : super(key: key);
  final Pill pill;

  @override
  ConsumerState<PillTile> createState() => _PillTileState();
}

class _PillTileState extends ConsumerState<PillTile> {
  TimeOfDay? selectedTime;

  Future<void> showTimePickerForTherapy() async {
    selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    ref.read(therapiesProvider).changeHourForPill({
      'user_id': ref.read(authProvider).user?.userId,
      'pill_id': widget.pill.id,
      'time': selectedTime!.format(context),
    });
  }

  Future<void> openEditModal() async {
    showDialog(
      context: context,
      builder: (context) => CustomEditPillDialog(
        pill: widget.pill,
      ),
    );
  }

  Color getColorFromStatus() {
    switch (widget.pill.status) {
      case 'upcomming':
        return Colors.amber.shade600;
      case 'skipped':
        return Colors.red;
      case 'taken':
        return Colors.green;
      default:
        return Colors.amber.shade600;
    }
  }

  String getLabelFromStatus() {
    switch (widget.pill.status) {
      case 'upcomming':
        return 'Da prendere';
      case 'skipped':
        return 'Saltata';
      case 'taken':
        return 'Presa';
      default:
        return 'Da prendere';
    }
  }

  Future<void> openSkipModal() async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: translate(context, 'skip'),
        children: [
          //TODO tradurre e fix
          const Text('Sei sicuro di voler saltare questa pillola?'),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    ref.read(therapiesProvider).skipPill({
                      'user_id': ref.read(authProvider).user?.userId,
                      'pill_id': widget.pill.id,
                    });
                    Navigator.of(context).pop();
                  },
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
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      //TODO passare l'orario quando aggiornano l'endpoint
                      final now = TimeOfDay.now().format(context);
                      ref.read(therapiesProvider).takePill({
                        'user_id': ref.read(authProvider).user?.userId,
                        'pill_id': widget.pill.id,
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 50),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: Center(
                            child: Text(
                              translate(context, 'Now'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(therapiesProvider).takePill({
                        'user_id': ref.read(authProvider).user?.userId,
                        'pill_id': widget.pill.id,
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.alarm_on,
                            color: Color.fromARGB(255, 0, 20, 31), size: 50),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: Text(
                            translate(context, 'At_scheduled_time'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  )
                ],
              ))
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
            decoration: BoxDecoration(
              color: getColorFromStatus(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  convertToDate(widget.pill.date ?? '--/--/----'),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  getLabelFromStatus(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                //TODO magari dopo
                /*      GestureDetector(
                  onTap: () {
                    openEditModal();
                  },
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                ),*/
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
                if (widget.pill.photoUrl == null)
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
                    imageUrl: widget.pill.photoUrl!,
                  )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pill.productName ?? 'prodotto',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.h3Style.copyWith(
                              fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                        ),
                        //TODO fixare con formatter da utils
                        Text(widget.pill.hour?.substring(0, 5) ?? '--:--'),
                        Text(
                            'Da prendere ${widget.pill.qty} ${widget.pill.qtyUnit}'),
                      ],
                    ),
                    flex: 8),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          if (widget.pill.status == 'upcomming')
            const Divider(
              height: 1,
            ),
          if (widget.pill.status == 'upcomming')
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
            ),
        ],
      ),
    );
  }
}

String convertToDate(String s) {
  final result = DateTime.parse(s);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(result);
  return formatted;
}
