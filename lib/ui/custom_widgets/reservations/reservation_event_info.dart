import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/flavor.dart';

class ReservationEventInfo extends ConsumerWidget {
  final dynamic reservation;
  const ReservationEventInfo(this.reservation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: translate(context, "Event"),
                  style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            " ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(reservation['date']))}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
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
                          Text(translate(context, "event_name"),
                              style: AppTheme.bodyText.copyWith(
                                  fontSize: 14,
                                  color: ref.read(flavorProvider).primary,
                                  fontWeight: FontWeight.w600)),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reservation["title"],
                              style: AppTheme.bodyText.copyWith(
                                  color: ref.read(flavorProvider).lightPrimary,
                                  fontSize: 14))
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
                                  .format(double.parse(reservation['price'])),
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
    );
  }
}
