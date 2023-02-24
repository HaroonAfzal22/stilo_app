import 'dart:developer';

import 'package:contacta_pharmacy/models/rental.dart';
import 'package:contacta_pharmacy/ui/screens/rentals/rental_detail_screen.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class RentalTile extends ConsumerStatefulWidget {
  final Rental rental;
  final String type;
  final bool isOpened;
  const RentalTile({
    Key? key,
    required this.isOpened,
    required this.rental,
    required this.type,
  }) : super(key: key);

  @override
  _RentalTileState createState() => _RentalTileState();
}

class _RentalTileState extends ConsumerState<RentalTile> {
  // final ExpandableController _controller = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ExpandableNotifier(
        initialExpanded: widget.isOpened,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
              hasIcon: false,
              tapBodyToCollapse: true,
              tapHeaderToExpand: true,
              tapBodyToExpand: true),
          header: buildHeader(),
          // controller: _controller,
          collapsed: buildItemInfo(),
          expanded: buildOrderList(context),
        ),
      ),
    );
  }

  Widget buildItemInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [buildStatusRow()],
      ),
    );
  }

  Padding buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 2),
      child: InkWell(
        child: Container(
          color: ref.read(flavorProvider).primary,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    translate(context, 'no_reservation_box'),
                    style: AppTheme.bodyText.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                  if (widget.rental.id != null)
                    Text(
                      ": ${widget.rental.id}",
                      style: AppTheme.bodyText.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.bold),
                    )
                  else
                    const SizedBox(),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  widget.rental.startDate != null
                      ? Text(
                          DateFormat("dd/MM/yyyy").format(
                              DateFormat("yyyy-MM-dd").parse(
                                  widget.rental.startDate ?? '----/--/--')),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox()
                  //TODO fix
                  /* ? Text(
                          DateFormat("dd/MM/yyyy").format(
                              DateFormat("yyyy-MM-dd hh:mm:ss")
                                  .parse(widget.rental['start_date'])),
                          style: AppTheme.h6Style.copyWith(
                              color: Colors.grey[300], fontSize: 11.0.sp))
                      : Text("22/07/2021",
                          style: AppTheme.h6Style.copyWith(
                              color: Colors.grey[300], fontSize: 11.0.sp)),*/
                  ,
                  //TODO fix
                  /*        SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          _controller.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _controller.toggle.call();
                          setState(() {});
                        }),
                  ),*/
                  const SizedBox(
                    width: 8,
                  ),
                ],
              )
            ],
          ),
        ),
        //TODO fix
        /* onTap: () {
          _controller.toggle.call();
          setState(() {});
        },*/
      ),
    );
  }

  Container buildOrderList(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(left: 0, right: 0),
      constraints: const BoxConstraints(maxHeight: 200, minHeight: 150),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildOrderListItem(context);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: AppColors.grey,
                );
              },
              itemCount: 1,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            color: AppColors.grey,
          ),
          buildStatusRow()
        ],
      ),
    );
  }

  Container buildStatusRow() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //TODO fix later
/*
            Container(
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.blueColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: Center(
                    child: Text(
                  widget.type == "active"
                      ? translate(context, "active")
                      : widget.type == "completed"
                          ? translate(context, "Finished")
                          : translate(context, "other"),
                  style: TextStyle(color: Colors.white, fontSize: 9.0.sp),
                )),
              ),
            ),
*/
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RentalDetailScreen.routeName,
                    arguments: widget.rental);
              },
              child: Row(
                children: [
                  Text(
                    translate(context, "view_details"),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const Icon(
                    Icons.arrow_forward_sharp,
                    color: Colors.blue,
                    size: 22,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildOrderListItem(BuildContext context) {
    DateTime temp_date = DateTime.now();
    String endDate = '';
    //TODO fix
    /* DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.rental['start_date']);
    String endDate = "";
    log("$temp_date", name: "temp_date this is parse");*/

    if (widget.rental.period == null || widget.rental.period == "Days") {
      temp_date = DateTime(
          temp_date.year,
          temp_date.month,
          temp_date.day +
              int.parse(
                  "${widget.rental.duration != null ? widget.rental.duration! - 1 : "0"}"));
      log("$temp_date", name: "days selected date this is parse");
    } else {
      temp_date = DateTime(
          temp_date.year,
          temp_date.month + int.parse(widget.rental.duration.toString()),
          temp_date.day);
    }
    endDate = DateFormat('dd/MM/yyyy').format(temp_date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: SizedBox(
                      height: 110,
                      width: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        elevation: 2,
                        color: Colors.white,
                        child: SizedBox(),
                        //TODO fix
                        /*      child: CachedNetworkImage(
                            imageUrl: widget.rental["image"] == null ||
                                    widget.rental["image"].length == 0
                                ? ""
                                : widget.rental["image"][0]["img"],
                            height: 15.0.h,
                            errorWidget: (context, url, error) {
                              return Image.asset("assets/images/noImage.png");
                            }),*/
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rental.name ?? "",
                        style: AppTheme.h6Style.copyWith(
                            fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(translate(context, "start_date:") + " : ",
                              style: AppTheme.bodyText.copyWith(
                                  color: ref.read(flavorProvider).primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 5,
                          ),
                          widget.rental.startDate != null
                              ? const Text('')
                              : const SizedBox()
                          //TODO fix
                          /*      ? Text(
                                  DateFormat("dd/MM/yyyy").format(
                                      DateFormat("yyyy-MM-dd hh:mm:ss")
                                          .parse(widget.rental['start_date'])),
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ))
                              : Text("22/07/2022",
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ))*/
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(translate(context, "end_date:") + " : ",
                              style: AppTheme.bodyText.copyWith(
                                  color: ref.read(flavorProvider).primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 5,
                          ),
                          widget.rental.endDate != null
                              ? const Text('')
                              : const SizedBox()
                          //TODO fix
                          /*     ? Text(
                                  DateFormat("dd/MM/yyyy").format(
                                      DateFormat("yyyy-MM-dd hh:mm:ss")
                                          .parse(widget.rental['end_date'])),
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ))
                              : Text(endDate,
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ))*/
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(translate(context, "Total_cost:"),
                              style: AppTheme.bodyText.copyWith(
                                  color: ref.read(flavorProvider).primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            NumberFormat.currency(locale: 'it_IT', symbol: '€')
                                .format(
                                    double.parse(widget.rental.price ?? '0')),
                            style: AppTheme.bodyText.copyWith(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
