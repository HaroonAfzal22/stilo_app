import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/flavor.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/theme.dart';
import '../../../../translations/translate_string.dart';
import '../../../../utils/ImageString.dart';
import '../../coupons_screen.dart';

class BookServiceSummaryBooking extends ConsumerStatefulWidget {
  const BookServiceSummaryBooking({Key? key}) : super(key: key);

  @override
  _BookServiceSummaryBookingState createState() =>
      _BookServiceSummaryBookingState();
}

class _BookServiceSummaryBookingState
    extends ConsumerState<BookServiceSummaryBooking> {
  final ApisNew _apisNew = ApisNew();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(context, "Booking_Summary"),
                  style: AppTheme.h5Style.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(
                          context,
                          ref.read(flavorProvider).isParapharmacy
                              ? "Booking_Summary_des_parapharmacy"
                              : "Booking_Summary_des_pharmacy"),
                      style: AppTheme.h6Style.copyWith(fontSize: 10.0.sp),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(context, "Details"),
                  style: AppTheme.h5Style
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  color: AppColors.white,
                  child: Container(
                    color: AppColors.white,
                    margin: const EdgeInsets.all(0),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(8),
                      },
                      border: const TableBorder(
                          bottom: BorderSide(color: AppColors.grey),
                          horizontalInside: BorderSide(color: AppColors.grey)),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.asset(ic_calender, height: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '--/--/--',
                              style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.black),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Image.asset(
                              ic_plan_watch,
                              height: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              translate(context, "from_service_booking"),
                              style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.black),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.asset(
                              ic_outlined_location,
                              height: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'ADDRESS',
                              style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.black),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 11.0),
                            child: Center(
                              child: Image.asset(
                                ic_cash,
                                height: 13,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "${translate(context, "Cost")}   '5,00' ${translate(context, "booking")}",
                              style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.black),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Coupon',
                        style: AppTheme.h4Style.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(CouponsScreen.routeName);
                      },
                      child: Text(
                        translate(context, 'view_all'),
                        style: AppTheme.h6Style.copyWith(
                            color: ref.read(flavorProvider).lightPrimary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5)
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            hintText: translate(context, 'promocode'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Colors.black,
                            height: 50,
                            child: Center(
                              child: Text(
                                translate(context, 'apply'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
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
