import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/MyApplication.dart';
import '../../../../models/flavor.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/theme.dart';
import '../../../../translations/translate_string.dart';
import '../../../../utils/ImageString.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/event-detail-screen';

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  dynamic event;
  String? status;
  final ApisNew _apisNew = ApisNew();
  bool loading = false;
  int? reservationID;

  Future<void> getReservationStatus() async {
    setState(() {
      loading = true;
    });
    final result = await _apisNew.getEventReservationStatus({
      'user_id': ref.read(authProvider).user!.userId,
      'event_id': event['id'],
    });
    setState(() {
      loading = false;
    });
    if (result.data['reservationID'] != null) {
      reservationID = result.data['reservationID'];
      status = "RESERVED";
    } else {
      status = "NOT_RESERVED";
    }
    setState(() {});
  }

  Future<void> createEventReservation() async {
    final result = await _apisNew.createEventReservation({
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
      "user_id": ref.read(authProvider).user?.userId,
      "event_id": event['id'],
      "sede_id": ref.read(siteProvider)!.id,
    });
    getReservationStatus();
  }

  Future<void> deleteEventReservation() async {
    if (reservationID != null) {
      final result = await _apisNew.deleteEventReservation({
        "user_id": ref.read(authProvider).user?.userId,
        "event_id": (reservationID!),
      });
      getReservationStatus();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        event = ModalRoute.of(context)!.settings.arguments as dynamic;
        setState(() {});
        if (ref.read(authProvider).user?.userId != null) {
          getReservationStatus();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          translate(context, 'Details'),
        ),
      ),
      body: event != null && loading == false
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      //TODO add if
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: event['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        event['event_name'] ?? '',
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Html(
                        data: (event['event_description']) ?? '',
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Image.asset(ic_calender, height: 20),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Builder(builder: (context) {
                                        final date = DateTime.tryParse(
                                            event['date'] ?? "");

                                        final parsed = date == null
                                            ? '--/--/----'
                                            : DateFormat("d/M/y").format(date);

                                        return Text(
                                          parsed,
                                          style: AppTheme.h4Style.copyWith(
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                    ],
                                  ),
                                  event['from_time'] == null
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            Text(
                                              '${translate(context, "from_service_booking")} ${DateFormat('HH:mm').format(DateFormat("hh:mm:ss").parse(event['from_time']))}',
                                              // 'From${DateFormat('MMM dd yyyy').parse(data['from_time'])}',
                                              // "From ${DateFormat('hh:mm').format(DateFormat('yyyy-mm-dd hh:mm').parse(data['from_time']))}",
                                              style: AppTheme.h4Style.copyWith(
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.lightGrey),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              '${translate(context, "to_service_booking")} ${DateFormat('HH:mm').format(DateFormat("hh:mm:ss").parse(event['to_time']))}',
                                              style: AppTheme.h4Style.copyWith(
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.lightGrey),
                                            ),
                                          ],
                                        ),
//TODO
/*
                              InkWell(
                                onTap: () {
                                  var description =
                                      '${parseHtmlString("""<span> ${widget.data['event_description'] ?? ''} </span>""")}';
                                  final e.Event event = e.Event(
                                    title: '${widget.data['event_name']}',
                                    description: '${description}',
                                    location: '${widget.data['address'] ?? ""}',
                                    startDate: DateFormat('yyyy-MM-dd HH:mm').parse(
                                        "${widget.data['date'].toString().split(" ")[0]} ${widget.data['from_time']}"),
                                    endDate: DateFormat('yyyy-MM-dd HH:mm').parse(
                                        "${widget.data['event_to_date']} ${widget.data['to_time']}"),
                                    iosParams: e.IOSParams(
                                      reminder: Duration(
                                          hours:
                                          1), // on iOS, you can set alarm notification after your event.
                                    ),
                                    androidParams: e.AndroidParams(
                                      emailInvites: [], // on Android, you can add invite emails to your event.
                                    ),
                                  );

                                  e.Add2Calendar.addEvent2Cal(event).then((value) {
                                    log("$value", name: "Add Event");
                                  });
                                },
                                child: Text.rich(
                                  TextSpan(
                                    text: "${translate(context, "Add_to_calendar")}",
                                    style: AppTheme.bodyText.copyWith(
                                        fontSize: 10.0.sp,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
*/
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    ic_outlined_location,
                                    height: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 9,
                                child: InkWell(
                                  onTap: () {
                                    launchUrl(
                                        "https://www.google.com/maps/search/${Uri.encodeFull("${event['address']}")}");
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '${event['address']}',
                                          style: AppTheme.h4Style.copyWith(
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text:
                                              translate(context, "Indications"),
                                          style: AppTheme.bodyText.copyWith(
                                              fontSize: 10.0.sp,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Image.asset(ic_reservation_required, height: 18),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                translate(context, "Reservation_required"),
                                style: AppTheme.h4Style.copyWith(
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 2),
                              Image.asset(
                                ic_cash,
                                height: 15,
                              ),

                              const SizedBox(width: 10),
                              //TODO
                              /*     Text(
                            "${translate(context, "cost")} $subTotal € / ${_itemCount > 1 ? _itemCount : ""} ${translate(context, _itemCount > 1 ? "persons" : "person")}",
                            style: AppTheme.h4Style
                                .copyWith(fontSize: 10.0.sp, fontWeight: FontWeight.bold),
                          ),*/
                              event['price'] != null
                                  ? Text(
                                      NumberFormat.currency(
                                              locale: 'it_IT', symbol: '€')
                                          .format(
                                        double.tryParse(
                                          event['price'],
                                        ),
                                      ),
                                      style: AppTheme.h4Style.copyWith(
                                          fontSize: 13.0.sp,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          event['price'] == null ||
                                  event['booking_required'] != null &&
                                      event['booking_required'] == "N"
                              ? const SizedBox()
                              : const SizedBox(),
                          const SizedBox(
                            height: 30,
                          ),
                          if (ref.read(authProvider).user != null)
                            InkWell(
                              onTap: () {
                                if (status == "NOT_RESERVED") {
                                  createEventReservation();
                                } else {
                                  deleteEventReservation();
                                }
                                /*  showModalBottomSheet(
                                // isDismissible: false,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) =>
                                    const BottomSheetReservationSuccess(),
                              );*/
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: status == 'NOT_RESERVED'
                                      ? ref.read(flavorProvider).lightPrimary
                                      : AppColors.darkRed,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    status == "NOT_RESERVED"
                                        ? translate(context, 'book_now')
                                        : 'Cancella Prenotazione',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: ref
                                    .read(flavorProvider)
                                    .lightPrimary
                                    .withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  translate(context, 'book_now'),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: ref.read(flavorProvider).lightPrimary,
              ),
            ),
    );
  }
}
