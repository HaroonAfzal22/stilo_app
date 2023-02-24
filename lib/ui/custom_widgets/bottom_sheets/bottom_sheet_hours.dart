import 'package:contacta_pharmacy/providers/time_tables_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/MyApplication.dart' as myapp;
import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class BottomSheetHours extends ConsumerStatefulWidget {
  const BottomSheetHours({
    Key? key,
  }) : super(key: key);

  @override
  _BottomSheetHoursState createState() => _BottomSheetHoursState();
}

class _BottomSheetHoursState extends ConsumerState<BottomSheetHours> {
  var data = {};
  var daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  var status = '';
  bool isMorning = false;
  bool isEvening = false;

  Widget _button1(String? number) {
    return InkWell(
      onTap: () {
        if (number != null) {
          launch("tel://${number.replaceAll(' ', '')}");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: ref.read(flavorProvider).lightPrimary),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            translate(context, "call_us"),
            style: TextStyle(
              color: ref.read(flavorProvider).lightPrimary,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(String? address) {
    return InkWell(
      onTap: () {
        myapp.launchUrl(
            "https://www.google.com/maps/search/${Uri.encodeFull("$address")}");
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: ref.read(flavorProvider).lightPrimary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Text(
            translate(context, "get_direction"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
    //   ref.read(timeTablesProvider).getTimeTables();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timeTableProvider);

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Builder(builder: (context) {
            final timeTables = state.value!;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  Container(
                    height: 47,
                    decoration: BoxDecoration(
                        color: ref.read(flavorProvider).lightPrimary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/watchwhite.png',
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              translate(context, "hours_of_operations"),
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/icons/down_arrow_white.png',
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            child: Row(
                              children: [
                                Text(
                                  getTextTurn(
                                      timeTables
                                          .hours![DateTime.now().weekday - 1]
                                          .morningHoursOpen,
                                      timeTables
                                          .hours![DateTime.now().weekday - 1]
                                          .morningHoursClose,
                                      timeTables
                                          .hours![DateTime.now().weekday - 1]
                                          .eveningHoursOpen,
                                      timeTables
                                          .hours![DateTime.now().weekday - 1]
                                          .eveningHoursClose),
                                  //widget.title,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (data['contact_number'] != null) {
                                      launch(
                                          "tel://${data['contact_number'].toString().replaceAll(' ', '')}");
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(0),
                                              child: Image.asset(
                                                'assets/icons/phone-call.png',
                                                height: 4.0.h,
                                                color: ref
                                                    .read(flavorProvider)
                                                    .lightPrimary,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            translate(context, "emergency_no"),
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: AppColors.darkGrey,
                                            ),
                                          ),
                                          Consumer(builder: (context, ref, _) {
                                            final contacts = ref
                                                .watch(contactsProvider)
                                                .value;

                                            return Text(
                                              contacts?.phone ?? "",
                                              style: TextStyle(
                                                  fontSize: 13.0.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.black),
                                            );
                                          })
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: timeTables.hours!.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 15, right: 15),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(children: [
                                            Center(
                                              child: daysOfWeek[index] ==
                                                      DateFormat('EEEE')
                                                          .format(
                                                              DateTime.now())
                                                          .toString()
                                                  ? Image.asset(
                                                      'assets/icons/clock.png',
                                                      height: 4.0.h,
                                                      color: ref
                                                          .read(flavorProvider)
                                                          .lightPrimary,
                                                    )
                                                  : SizedBox(
                                                      height: 4.0.h,
                                                      width: 4.0.h,
                                                    ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 240,
                                                            minWidth: 100),
                                                    child: timeTables
                                                                    .hours![
                                                                        index]
                                                                    .morningHoursOpen ==
                                                                null ||
                                                            timeTables
                                                                    .hours![
                                                                        index]
                                                                    .morningHoursClose ==
                                                                null
                                                        ? const SizedBox()
                                                        : Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  //_timeTables!.hours![DateFormat('EE').format(DateTime.now()).].toString(),
                                                                  translate(
                                                                      context,
                                                                      daysOfWeek[
                                                                          index]),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 3),
                                                              Text(
                                                                  timeTables
                                                                          .hours![
                                                                              index]
                                                                          .morningHoursOpen ??
                                                                      "---",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17)),
                                                              const Text(" - ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17)),
                                                              Text(
                                                                timeTables
                                                                        .hours![
                                                                            index]
                                                                        .morningHoursClose ??
                                                                    "---",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            17),
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 240,
                                                            minWidth: 100),
                                                    child: timeTables
                                                                    .hours![
                                                                        index]
                                                                    .eveningHoursOpen ==
                                                                null ||
                                                            timeTables
                                                                    .hours![
                                                                        index]
                                                                    .eveningHoursClose ==
                                                                null
                                                        ? const SizedBox
                                                            .shrink()
                                                        : Row(
                                                            children: [
                                                              const SizedBox(
                                                                  width: 100),
                                                              Text(
                                                                  timeTables
                                                                          .hours![
                                                                              index]
                                                                          .eveningHoursOpen ??
                                                                      "---",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17)),
                                                              const Text(" - ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17)),
                                                              Text(
                                                                  timeTables
                                                                          .hours![
                                                                              index]
                                                                          .eveningHoursClose ??
                                                                      "---",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17)),
                                                            ],
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ]),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 45.0, right: 5),
                                          child: Divider(
                                            color: Color.fromARGB(
                                                255, 194, 194, 194),
                                            height: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }))
                        ],
                      ),
                    ),
                  ),
                  Consumer(builder: (context, ref, _) {
                    final contacts = ref.watch(contactsProvider).value;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          contacts?.phone == null
                              ? const SizedBox()
                              : _button1(contacts!.phone),
                          contacts?.address == null
                              ? const SizedBox()
                              : _button(contacts!.address)
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            );
          });
  }

  bool isInRange(String openTime, String closeTime) {
    var openHour = openTime.split(':');
    var open =
        TimeOfDay(hour: int.parse(openHour[0]), minute: int.parse(openHour[1]));
    var closeHour = closeTime.split(':');
    var close = TimeOfDay(
        hour: int.parse(closeHour[0]), minute: int.parse(closeHour[1]));
    TimeOfDay now = TimeOfDay.now();
    return ((now.hour > open.hour) ||
            (now.hour == open.hour && now.minute >= open.minute)) &&
        ((now.hour < close.hour) ||
            (now.hour == close.hour && now.minute <= close.minute));
  }

  String getTextTurn(String? openMorning, String? closeMorning,
      String? openEvening, String? closeEvening) {
    // setState(() {
    //   openMorning != null && closeMorning != null
    //       ? isMorning = isInRange(openMorning, closeMorning)
    //       : isMorning = false;
    //   openEvening != null && closeEvening != null
    //       ? isEvening = isInRange(openEvening, closeEvening)
    //       : isEvening = false;
    // });

    openMorning != null && closeMorning != null
        ? isMorning = isInRange(openMorning, closeMorning)
        : isMorning = false;
    openEvening != null && closeEvening != null
        ? isEvening = isInRange(openEvening, closeEvening)
        : isEvening = false;

    return (isMorning || isEvening)
        ? "Al momento siamo aperti"
        : "Al momento siamo chiusi";
  }
}

class BottomSheetHoursOnlyMorning extends ConsumerStatefulWidget {
  const BottomSheetHoursOnlyMorning({Key? key}) : super(key: key);

  @override
  _BottomSheetHoursOnlyMorningState createState() =>
      _BottomSheetHoursOnlyMorningState();
}

class _BottomSheetHoursOnlyMorningState
    extends ConsumerState<BottomSheetHoursOnlyMorning> {
  var data = {};
  var daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  var status = '';
  bool isMorning = true;
  bool isEvening = false;

  Widget _button1() {
    return InkWell(
      onTap: () {
        if (data['contact_number'] != null) {
          launchUrl(
            Uri.parse(
                "tel://${data['contact_number'].toString().replaceAll(' ', '')}"),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: ref.read(flavorProvider).lightPrimary),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            translate(context, "call_us"),
            style: TextStyle(
              color: ref.read(flavorProvider).lightPrimary,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return InkWell(
      onTap: () {
        myapp.launchUrl(
            "https://www.google.com/maps/search/${Uri.encodeFull("${data['address']}")}");
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: ref.read(flavorProvider).lightPrimary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Text(
            translate(context, "get_direction"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timeTableProvider);
    return state.isLoading
        ? (const Center(child: CircularProgressIndicator()))
        : Builder(builder: (context) {
            final timeTables = state.value!;
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  Container(
                    height: 47,
                    decoration: BoxDecoration(
                        color: ref.read(flavorProvider).lightPrimary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/watchwhite.png',
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              translate(context, "hours_of_operations"),
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/icons/down_arrow_white.png',
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            child: Row(
                              children: [
                                Text(
                                  DateTime.now().weekday == 7
                                      ? "Al momento siamo chiusi"
                                      : getTextTurn(
                                          timeTables
                                              .hours![
                                                  DateTime.now().weekday - 1]
                                              .morningHoursOpen!,
                                          timeTables
                                              .hours![
                                                  DateTime.now().weekday - 1]
                                              .morningHoursClose!,
                                        ),
                                  //widget.title,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (data['contact_number'] != null) {
                                      launch(
                                          "tel://${data['contact_number'].toString().replaceAll(' ', '')}");
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(0),
                                              child: Image.asset(
                                                'assets/icons/phone-call.png',
                                                height: 4.0.h,
                                                color: ref
                                                    .read(flavorProvider)
                                                    .lightPrimary,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            translate(context, "emergency_no"),
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: AppColors.darkGrey,
                                            ),
                                          ),
                                          Consumer(builder: (context, ref, _) {
                                            final contacts = ref
                                                .watch(contactsProvider)
                                                .value;
                                            return Text(
                                              contacts?.phone ?? "",
                                              style: TextStyle(
                                                  fontSize: 13.0.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.black),
                                            );
                                          })
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: timeTables.hours!.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 15, right: 15),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(children: [
                                            Center(
                                              child: daysOfWeek[index] ==
                                                      DateFormat('EEEE')
                                                          .format(
                                                              DateTime.now())
                                                          .toString()
                                                  ? Image.asset(
                                                      'assets/icons/clock.png',
                                                      height: 4.0.h,
                                                      color: ref
                                                          .read(flavorProvider)
                                                          .lightPrimary,
                                                    )
                                                  : SizedBox(
                                                      height: 4.0.h,
                                                      width: 4.0.h,
                                                    ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 240,
                                                            minWidth: 100),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          //_timeTables!.hours![DateFormat('EE').format(DateTime.now()).].toString(),
                                                          translate(
                                                              context,
                                                              daysOfWeek[
                                                                  index]),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 3),
                                                        Text(
                                                            timeTables
                                                                    .hours![
                                                                        index]
                                                                    .morningHoursOpen ??
                                                                "---",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        17)),
                                                        const Text(" - ",
                                                            style: TextStyle(
                                                                fontSize: 17)),
                                                        Text(
                                                            timeTables
                                                                    .hours![
                                                                        index]
                                                                    .morningHoursClose ??
                                                                "---",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        17)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ]),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 45.0, right: 5),
                                          child: Divider(
                                            color: Color.fromARGB(
                                                255, 194, 194, 194),
                                            height: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_button1(), _button()],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            );
          });
  }

  bool isInRange(String openTime, String closeTime) {
    var openHour = openTime.split(':');
    var open =
        TimeOfDay(hour: int.parse(openHour[0]), minute: int.parse(openHour[1]));
    var closeHour = closeTime.split(':');
    var close = TimeOfDay(
        hour: int.parse(closeHour[0]), minute: int.parse(closeHour[1]));
    TimeOfDay now = TimeOfDay.now();
    return ((now.hour > open.hour) ||
            (now.hour == open.hour && now.minute >= open.minute)) &&
        ((now.hour < close.hour) ||
            (now.hour == close.hour && now.minute <= close.minute));
  }

  String getTextTurn(
    String openMorning,
    String closeMorning,
  ) {
    setState(() {
      isMorning = isInRange(openMorning, closeMorning);
    });
    return (isMorning || isEvening)
        ? "Al momento siamo aperti"
        : "Al momento siamo chiusi";
  }
}
