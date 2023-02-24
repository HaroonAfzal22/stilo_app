import 'package:contacta_pharmacy/models/reservation.dart';
import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';

class BottomSheetReservationSuccess extends StatefulWidget {
  final dynamic reservation;
  const BottomSheetReservationSuccess({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  State<BottomSheetReservationSuccess> createState() =>
      _BottomSheetReservationSuccessState();
}

class _BottomSheetReservationSuccessState
    extends State<BottomSheetReservationSuccess> {
  String language = "it";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Image.asset(
                  ic_successservice,
                  height: 35.0.h,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(translate(context, "Booked_up!"),
                        textAlign: TextAlign.center,
                        style: AppTheme.titleStyle
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: RichText(
                    text: TextSpan(
                        style: AppTheme.bodyText.copyWith(
                            fontSize: 10.0.sp, fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(
                              text:
                                  "${translate(context, "Booked_up_des")}${translateDate(widget.reservation['selectedDate']['date'], context)}",
                              style: AppTheme.bodyText.copyWith(
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.normal)),
//TODO ripristinare
/*                            TextSpan(
                                  text:
                                  "${DateFormat("dd/MM/yyyy", PreferenceUtils.getString("language")).format(DateFormat("yyyy-MM-dd").parse(list[0]['date']))}",
                                  style: AppTheme.bodyText.copyWith(
                                      fontSize: 10.0.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600)),*/
                          TextSpan(
                              text:
                                  " ${translate(context, "to_service_booking")} ${widget.reservation['selectedSlot']['start_time']} ",
                              style: AppTheme.bodyText.copyWith(
                                  fontSize: 10.0.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600)),
                          //TODO fix
                          /*           TextSpan(
                              text:
                                  "${list[0]["start_time"].toString().split(":")[0]}:${list[0]["start_time"].toString().split(":")[1]}",
                              style: AppTheme.bodyText.copyWith(
                                  fontSize: 10.0.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600)),*/
                        ]),
                  ))
                ],
              ),
            ),
            //TODO BOTTONI

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.routeName, (route) => false);
                  },
                  child: Text(
                    translate(context, "go_to_home"),
                    style:
                        AppTheme.h6Style.copyWith(color: AppColors.lightGrey),
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
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
}
