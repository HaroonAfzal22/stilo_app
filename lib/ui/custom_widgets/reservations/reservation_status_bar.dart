import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/reservation_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReservationStatusBar extends StatelessWidget {
  final dynamic reservation;
  const ReservationStatusBar(this.reservation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //TODO fix
                /*
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 5),
                    decoration: BoxDecoration(
                        color: reservation['appointment_type'] == "waiting"
                            ? AppColors.blueColor
                            : ref.read(flavorProvider).primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 15),
                      child: Center(
                          child: reservation['appointment_type'] == "waiting"
                              ? Text(
                                  "Waiting",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.normal),
                                )
                              : Text(
                                  "Completed",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.normal),
                                )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),*/
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        ReservationDetailScreen.routeName,
                        arguments: reservation);
                  },
                  child: Row(
                    children: [
                      Text(
                        translate(context, "View_booking"),
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11.0.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward_sharp,
                        color: Colors.blue,
                        size: 19,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
