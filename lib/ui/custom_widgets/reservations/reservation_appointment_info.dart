import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/flavor.dart';

class ReservationAppointmentInfo extends ConsumerWidget {
  final dynamic reservation;
  const ReservationAppointmentInfo(this.reservation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${translate(context, "Appointment")} ',
                      style: const TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                            text: reservation['date'] != null
                                ? DateFormat("dd/MM/yyyy").format(
                                    DateFormat("yyyy-MM-dd")
                                        .parse(reservation['date']))
                                : "--/--",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' ${translate(context, "at")} '),
                        TextSpan(
                            text: reservation['start_time'] != null
                                ? DateFormat("HH:mm").format(
                                    DateFormat("HH:mm:ss")
                                        .parse(reservation['start_time']))
                                : "",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                    },
                    children: [
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Category:"),
                                  style: AppTheme.bodyText.copyWith(
                                      fontSize: 14,
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reservation["category"] ?? '',
                                  style: AppTheme.bodyText.copyWith(
                                      color: AppColors.black, fontSize: 14))
                            ]),
                      ]),
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Service:"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reservation["service"],
                                  style: AppTheme.bodyText.copyWith(
                                      color: AppColors.black, fontSize: 14))
                            ]),
                      ]),
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Total_cost:"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  NumberFormat.currency(
                                          locale: 'it_IT', symbol: '€')
                                      .format(
                                          double.parse(reservation['price'])),
                                  style: AppTheme.bodyText.copyWith(
                                      color: AppColors.black, fontSize: 14))
                            ]),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
