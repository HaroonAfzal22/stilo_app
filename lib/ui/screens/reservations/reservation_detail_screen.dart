import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/preference_utils.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/time_tables_provider.dart';
import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:contacta_pharmacy/utils/ImageString.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class ReservationDetailScreen extends ConsumerStatefulWidget {
  const ReservationDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/reservation-detail-screen';

  @override
  ConsumerState<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState
    extends ConsumerState<ReservationDetailScreen> {
  bool isHide = false;
  bool isCancel = true;
  bool loading = false;
  dynamic reservation;
  String formattedPhone = "";
  final ApisNew _apisNew = ApisNew();

  settypesimages() {
    if (reservation['category'] == "General Services") {
      return Image.asset(ic_service_general);
    }

    if (reservation['category'] == "Aesthetic Cabin") {
      return Image.asset(ic_service_aesthetic);
    }
    if (reservation['category'] == "Covid-19 Tests and Vaccin") {
      return Image.asset(ic_service_covid);
    }
    if (reservation['category'] == "Medical analyzes and tess") {
      return Image.asset(ic_service_medical_analyst);
    } else {
      return Image.asset(ic_service_event);
    }
  }

  getCategory() {
    if (reservation['category'] == "General Services") {
      return translate(context, "General_Services");
    }

    if (reservation['category'] == "Aesthetic Cabin") {
      return translate(context, "service_Aesthetic");
    }
    if (reservation['category'] == "Covid-19 Tests and Vaccin") {
      return translate(context, "service_covid");
    }
    if (reservation['category'] == "Medical analyzes and tess") {
      return translate(context, "service_medical_analyz");
    } else {
      return translate(context, "service_event");
    }
  }

  openAlertBox() {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => Theme(
              data: ThemeData.dark(),
              child: CupertinoAlertDialog(
                title: Text(
                  translate(context, "Attention"),
                  style: const TextStyle(color: Colors.white),
                ),
                content: Text(translate(
                    context,
                    ref.read(flavorProvider).isParapharmacy
                        ? "cancel_appoinment_parapharmacy"
                        : "cancel_appoinment_pharmacy")),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (PreferenceUtils.getString("pharmacy_phone")
                          .isNotEmpty) {
                        launch(
                            "tel://${PreferenceUtils.getString("pharmacy_phone").toString().replaceAll(' ', '')}");
                      }

                      // launch(
                      //     "tel://${PreferenceUtils.getString("pharmacy_phone").toString()}");
                      // Navigator.pop(context);
                    },
                    child: Text(
                      translate(context, "Who_loves"),
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteServiceReservation();

                      Navigator.pop(context);
                    },
                    child: Text(
                      translate(context, "All_right"),
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ));
  }

  cancelReservationList(int id) async {
    if (reservation['event'] != null) {
      final result = await _apisNew.deleteEventReservation({
        "user_id": ref.read(authProvider).user?.userId,
        //TODO check this
        "event_id": reservation['id'],
      });
    }
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);

    /*   MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          loading = true;
        });

        EncodeDecode enc = EncodeDecode();

        var dataToBesent = enc.encode({
          '"user_id" : "${PreferenceUtils.getInt("user_id").toString()}","user_device_id":"${PreferenceUtils.getString("user_device_id").toString()}","access_token":"${PreferenceUtils.getString("accesstoken").toString()}","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}","reservation_id":"$id" , "count":"${reservation['number'] ?? 1}"'
        });

        try {
          Dio dio = Dio();

          dio
              .post(
            Constant.cancel_reservation,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = json.decode(enc.decode(value.toString()));
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                showgreenToast(
                    translate(context, "appointment_cancle"), context);

                PreferenceUtils.remove("reservation_waiting");
                PreferenceUtils.remove("reservation_completed");
                PreferenceUtils.remove("reservation_cancelled");
                setState(() {
                  loading = false;
                });
                Navigator.pop(
                  context,
                );
              } else if (temp['code'] == 999) {
                setState(() {
                  loading = false;
                });
                showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                setState(() {
                  loading = false;
                });
              }
            }
          });
        } catch (e) {
          showInSnackBar(translate(context, "no_order_cancle"), context);
          setState(() {
            loading = false;
          });
        }
      }
    });*/
  }

  Future<void> deleteServiceReservation() async {
    EasyLoading.show(status: 'Caricamento');
    EasyLoading.instance.userInteractions = false;
    final result = await _apisNew.deleteServiceReservation({
      'user_id': ref.read(authProvider).user?.userId,
      'service_id': reservation['id'],
    });
    EasyLoading.dismiss();
    if (result.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
    }
  }

  //TODO finire
  Future<void> deleteEventReservation() async {
    EasyLoading.show(status: 'Caricamento');
    EasyLoading.instance.userInteractions = false;
    final result = await _apisNew.deleteEventReservation({
      'user_id': ref.read(authProvider).user?.userId,
      'event_id': reservation['id'],
    });
    EasyLoading.dismiss();
    if (result.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      reservation = ModalRoute.of(context)!.settings.arguments as dynamic;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          translate(context, 'booking_details'),
        ),
      ),
      body: reservation != null
          ? Column(
              children: [
/*
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 40.0.w,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.blueColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 15),
                          child: Center(
                            child: Text(
                              //todo status reservation
                              "in lavorazione",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                            // child: status != null
                            //     ? Text(
                            //         "${status.capitalize()}",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 11.0.sp,
                            //             fontWeight: FontWeight.normal),
                            //       )
                            //     : SizedBox()),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
*/
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(translate(context, "reservation_n"),
                          style: AppTheme.h5Style.copyWith(
                              fontSize: 13.0.sp, color: AppColors.grey)),
                      Text("${reservation["id"] ?? ""}",
                          style: AppTheme.h5Style.copyWith(
                              fontSize: 13.0.sp, color: AppColors.grey)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
                  child: Row(
                    children: [
                      reservation["date"] != null
                          ? Text(DateFormat("dd MMMM yyyy", 'it').format(
                              DateFormat("yyyy-MM-dd")
                                  .parse(reservation["date"])))
                          : const SizedBox(),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        translate(context, "at"),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (reservation['start_time'] != null)
                        Text(
                            "${reservation["start_time"].toString().split(":")[0]}:${reservation["start_time"].toString().split(":")[1]}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Divider(height: 0.2, color: AppColors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                            color: ref
                                .read(flavorProvider)
                                .lightPrimary
                                .withOpacity(.1),
                            spreadRadius: 3,
                            blurRadius: 5)
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                                height: 11.0.h,
                                width: 2.0.w,
                                child: settypesimages()),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(reservation["title"],
                                      style: AppTheme.h5Style.copyWith(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const SizedBox(
                                  height: 05,
                                ),
                                reservation["category"] != null
                                    ? Row(
                                        children: [
                                          Text(translate(context, "Category:"),
                                              style: AppTheme.h5Style.copyWith(
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: ref
                                                      .read(flavorProvider)
                                                      .lightPrimary)),
                                          Text(" ${getCategory()}",
                                              style: AppTheme.h5Style.copyWith(
                                                  fontSize: 10.0.sp,
                                                  color: AppColors.lightGrey)),
                                        ],
                                      )
                                    : const SizedBox(),
                                reservation["category"] != null
                                    ? const SizedBox(
                                        height: 05,
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Text(translate(context, "Service:"),
                                        style: AppTheme.h5Style.copyWith(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ref
                                                .read(flavorProvider)
                                                .lightPrimary)),
                                    Flexible(
                                      child: Text(
                                          "${reservation["service"] ?? " - "}",
                                          style: AppTheme.h5Style.copyWith(
                                              fontSize: 10.0.sp,
                                              color: AppColors.lightGrey)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 05,
                                ),
                                Row(
                                  children: [
                                    Text(translate(context, "Total_cost:"),
                                        style: AppTheme.h5Style.copyWith(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ref
                                                .read(flavorProvider)
                                                .lightPrimary)),
                                    Text(
                                        " " +
                                            reservation["price"].toString() +
                                            " " +
                                            "€",
                                        style: AppTheme.h5Style.copyWith(
                                            fontSize: 10.0.sp,
                                            color: AppColors.lightGrey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 8),
                  child: Divider(height: 0.2, color: AppColors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                  child: Row(
                    children: [
                      Text(translate(context, "booking_information"),
                          style: AppTheme.h5Style.copyWith(
                              fontSize: 13.0.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, bottom: 20, top: 20, right: 20),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                    },
                    border: const TableBorder(
                        bottom: BorderSide(color: AppColors.grey),
                        horizontalInside: BorderSide(color: AppColors.grey)),
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate(context, "Address:"),
                                    style: AppTheme.h5Style.copyWith(
                                        fontSize: 12.0.sp,
                                        color:
                                            ref.read(flavorProvider).primary)),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer(builder: (context, ref, _) {
                                  final contacts =
                                      ref.watch(contactsProvider).value;
                                  return Text(
                                      reservation["address"] ??
                                          contacts?.address ??
                                          "",
                                      // style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400,fontFamily: 'Metropolis')
                                      style: AppTheme.h5Style
                                          .copyWith(fontSize: 12.0.sp));
                                }),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate(context, "reservation_date"),
                                    style: AppTheme.h5Style.copyWith(
                                        fontSize: 12.0.sp,
                                        color:
                                            ref.read(flavorProvider).primary)),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    //todo fixdata
                                    "${DateFormat("EEEE, MMMM dd ,yyyy", 'it').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(reservation['reservation_date']))},\n${reservation['start_time'] == null ? "" : "alle"} ${reservation['start_time'] == null ? "" : reservation['start_time'].split(":")[0]}${reservation['start_time'] == null ? "" : ":"}${reservation['start_time'] == null ? "" : reservation['start_time'].split(":")[1]}",
                                    style: AppTheme.h5Style
                                        .copyWith(fontSize: 12.0.sp)),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        reservation["coupan_discount"] == null
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(translate(context, "Coupon:"),
                                          style: AppTheme.h5Style.copyWith(
                                              fontSize: 12.0.sp,
                                              color: ref
                                                  .read(flavorProvider)
                                                  .primary)),
                                    ]),
                              ),
                        reservation["coupan_discount"] == null
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              reservation["coupan_discount"] ??
                                                  "",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              )),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(reservation["coupan_name"] ?? "",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      ),
                                    ]),
                              ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate(context, "total_cost"),
                                    style: AppTheme.h5Style.copyWith(
                                        fontSize: 12.0.sp,
                                        color:
                                            ref.read(flavorProvider).primary)),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                reservation["service"] == null
                                    ? Text(
                                        reservation['price'] +
                                            "€/${translate(context, "person")}",
                                        //  "${PreferenceUtils.getString("currency")} ${reservation["price"]} / ${int.parse(reservation["number"]) > 1 ? reservation["number"] : ""} ${int.parse(reservation["number"]) > 1 ? translate(context, "persons") : translate(context, "person")}",
                                        style: AppTheme.h5Style.copyWith(
                                          fontSize: 12.0.sp,
                                        ))
                                    : Text(
                                        // PreferenceUtils.getString("currency") +
                                        reservation["price"] + "€",
                                        style: AppTheme.h5Style.copyWith(
                                          fontSize: 12.0.sp,
                                        )),
                              ]),
                        ),
                      ]),
                    ],
                  ),
                ),
                _lastbutton(context)
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: ref.read(flavorProvider).lightPrimary,
              ),
            ),
    );
  }

  Widget _lastbutton(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (ref.read(timeTableProvider).value?.pharmacyContactNo != null)
            SizedBox(
              height: 5.0.h,
              width: 30.0.w,
              child: ElevatedButton(
                onPressed: () {
                  launch(
                      "tel://${ref.read(timeTableProvider).value?.pharmacyContactNo}");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side:
                          BorderSide(color: ref.read(flavorProvider).primary)),
                  elevation: 0,
                ),
                child: Text(
                  translate(context, "call_us"),
                  style: TextStyle(
                    color: ref.read(flavorProvider).primary,
                    fontSize: 11.0.sp,
                  ),
                ),
              ),
            ),
          reservation['appointment_type'] == "cancelled" ||
                  reservation['appointment_type'] == "completed" ||
                  isHide ||
                  reservation['status'] == 'cancelled'
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.only(left: 15),
                  height: 5.0.h,
                  width: 30.0.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.all(2.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(color: Colors.red)),
                    ),
                    onPressed: () {
                      if (!isCancel) {
                        openAlertBox();
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                          ),
                          builder: (context) => SingleChildScrollView(
                              child: Container(
                            // height: 68.0.h,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(children: [
                              Container(
                                height: 3.8.h,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        ic_cancel,
                                        height: 2.0.h,
                                        color: AppColors.darkGrey,
                                      )),
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset(
                                        ic_specificreservation,
                                        height: 25.0.h,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        translate(
                                            context, "do_u_want_to_cancle?"),
                                        style: AppTheme.h5Style.copyWith(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        translate(context,
                                            "are_u_sure_u_want_to_delete_yours"),
                                        style: AppTheme.h5Style.copyWith(
                                            fontSize: 10.0.sp,
                                            color: AppColors.lightGrey)),
                                    Text(
                                        "${translate(context, "appointment_for_serological")} ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(reservation['reservation_date']))} ${translate(context, "at")} ${reservation["start_time"].split(":")[0] ?? ""}:${reservation["start_time"].split(":")[1] ?? ""}",
                                        textAlign: TextAlign.center,
                                        style: AppTheme.h5Style.copyWith(
                                            fontSize: 10.0.sp,
                                            color: AppColors.darkGrey,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      height: 7.0.h,
                                      width: 70.0.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          padding: const EdgeInsets.all(2.0),
                                          primary: Colors.red,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: const BorderSide(
                                                  color: Colors.red)),
                                        ),
                                        onPressed: () {
                                          deleteServiceReservation();
                                        },
                                        child: Text(
                                          translate(
                                              context, "cancle_appintment"),
                                          style: TextStyle(
                                            fontSize: 11.0.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    SizedBox(
                                      height: 7.0.h,
                                      width: 70.0.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(2.0),
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: ref
                                                      .read(flavorProvider)
                                                      .primary)),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          translate(context, "come_back"),
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 11.0.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          )),
                        );
                      }
                    },
                    child: Text(
                      translate(context, "cancel"),
                      style: TextStyle(
                        fontSize: 11.0.sp,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
