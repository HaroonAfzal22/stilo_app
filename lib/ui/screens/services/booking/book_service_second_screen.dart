import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/app_provider.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/constant.dart';
import '../../../../models/flavor.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/theme.dart';
import '../../../../translations/translate_string.dart';
import '../../../../utils/ImageString.dart';
import '../../../custom_widgets/bottom_sheets/bottom_sheet_reservation_success.dart';
import '../../coupons_screen.dart';

class BookServiceSecondScreen extends ConsumerStatefulWidget {
  const BookServiceSecondScreen({Key? key}) : super(key: key);

  static const routeName = '/book-service-second-screen';

  @override
  _BookServiceSecondScreenState createState() =>
      _BookServiceSecondScreenState();
}

class _BookServiceSecondScreenState
    extends ConsumerState<BookServiceSecondScreen> {
  dynamic data;
  final ApisNew _apisNew = ApisNew();
  String language = "it";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      data = ModalRoute.of(context)!.settings.arguments as dynamic;
      final provider = ref.read(appProvider);
      if (provider.locale == null) {
        var lang = await provider.getLocale();
        language = lang == null ? "it" : lang.languageCode;
      }
      setState(() {});
    });
  }

  Future<void> createServiceReservation() async {
    var splitted = data['selectedSlot']['date'].split('-');
    String date = splitted[2] + '/' + splitted[1] + '/' + splitted[0];
    final result = await _apisNew.createServiceReservation({
      "user_id": ref.read(authProvider).user?.userId,
      "slot_id": data['selectedSlot']['id'],
      "offer_id": null,
      "reservation_date": date,
      "sede_id": ref.read(siteProvider)!.id,
    });
    if (result != null) {
      showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext context) =>
            BottomSheetReservationSuccess(reservation: data),
      );
    }
  }

  String translateDate(String date, BuildContext context) {
    var translatedDate = "";
    var splittedDate = date.split(" ");
    if (language == "it") {
      translatedDate =
          translate(context, splittedDate.first) + " " + splittedDate.last;
    } else {
      translate(context, splittedDate.first) + " " + splittedDate.last;
    }
    return translatedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    ref.read(flavorProvider).lightPrimary),
              ),
              child: const Text(
                'Prosegui',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              onPressed: () {
                createServiceReservation();
              }),
        )
      ],
      appBar: AppBar(
        title: Text(
          translate(context, "Booking_Summary"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(context, "Booking_Summary"),
                    style:
                        AppTheme.h5Style.copyWith(fontWeight: FontWeight.w600),
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
                  if (data != null && data['service'] != null)
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
                              horizontalInside:
                                  BorderSide(color: AppColors.grey)),
                          children: [
                            TableRow(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Image.asset(ic_calender, height: 20),
                              ),
                              //TODO fix
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  translateDate(
                                      data['selectedDate']['date'], context),
                                  style: AppTheme.bodyText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.black),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Image.asset(
                                  ic_plan_watch,
                                  height: 15,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  translate(context, "from_service_booking") +
                                      ' ' +
                                      data['selectedSlot']['start_time'],
                                  style: AppTheme.bodyText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.black),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Image.asset(
                                  ic_outlined_location,
                                  height: 20,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  data['service']['address'] ?? 'N/D',
                                  style: AppTheme.bodyText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.black),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11.0),
                                child: Center(
                                  child: Image.asset(
                                    ic_cash,
                                    height: 13,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "${translate(context, "Cost")}  ${NumberFormat.currency(locale: 'it_IT', symbol: '€').format(double.tryParse(data['service']['price']))} ${translate(context, "booking")}",
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
                  if (Constant.isCouponActive == true)
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
                  if (Constant.isCouponActive == true)
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
      ),
    );
  }
}
