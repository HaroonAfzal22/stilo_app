import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/reservations/reservation_appointment_info.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/reservations/reservation_event_info.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/reservations/reservation_status_bar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class ReservationTile extends ConsumerStatefulWidget {
  final dynamic reservation;
  final bool isExpanded;
  final bool isEvent;
  const ReservationTile(this.reservation, this.isExpanded, this.isEvent,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<ReservationTile> createState() => _ReservationTileState();
}

class _ReservationTileState extends ConsumerState<ReservationTile> {
  late ExpandableController _controller;
  late bool isChangedState;

  @override
  void initState() {
    super.initState();
    isChangedState = widget.isExpanded;

    _controller = ExpandableController(initialExpanded: widget.isExpanded);
    _controller.addListener(() {
      setState(() {
        isChangedState = !isChangedState;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ExpandablePanel(
          theme: const ExpandableThemeData(
              hasIcon: false,
              tapBodyToCollapse: true,
              tapHeaderToExpand: true,
              tapBodyToExpand: true),
          collapsed: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ReservationStatusBar(widget.reservation),
          ),
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              color: ref.read(flavorProvider).primary,
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/icons/order_basket.png",
                    height: 2.0.h,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    translate(context, 'reservation') +
                        ": ${widget.reservation['id'].toString()}", //numero ordine
                    style: AppTheme.h3Style
                        .copyWith(fontSize: 12.0.sp, color: AppColors.white),
                  ),
                  Expanded(child: Container()),
                  Text(
                    widget.reservation['date'] != null
                        ? DateFormat("dd/MM/yyyy").format(
                            DateFormat("yyyy-MM-dd")
                                .parse(widget.reservation['date']))
                        : '--/--',
                    style: AppTheme.h3Style
                        .copyWith(fontSize: 10.0.sp, color: AppColors.grey),
                  ),
                  isChangedState
                      ? const Icon(Icons.arrow_drop_up, color: AppColors.white)
                      : const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.white,
                        )
                ],
              ),
            ),
          ),
          controller: _controller,
          expanded: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isEvent
                  ? ReservationEventInfo(widget.reservation)
                  : ReservationAppointmentInfo(widget.reservation),
              ReservationStatusBar(widget.reservation),
            ],
          ),
        ),
      ]),
    );
  }
}
