import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../screens/services/events/event_detail_screen.dart';

class EventTile extends ConsumerStatefulWidget {
  final dynamic event;

  @override
  _EventTileState createState() => _EventTileState();

  const EventTile(this.event);
}

class _EventTileState extends ConsumerState<EventTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 24.0.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage("${widget.event['image'] ?? ""}"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 13, right: 13),
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            EventDetailScreen.routeName,
                            arguments: widget.event);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ref.read(flavorProvider).primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        margin: const EdgeInsets.only(right: 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 11, horizontal: 22),
                          child: Text(translate(context, "book"),
                              textAlign: TextAlign.center,
                              style: AppTheme.h3Style.copyWith(
                                  fontSize: 10.0.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 13, right: 13),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "${widget.event['event_name']} ",
                  style: AppTheme.h3Style.copyWith(
                    fontSize: 13.0.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              if (widget.event['address'] != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "${widget.event['address']}",
                    style: AppTheme.h3Style.copyWith(
                      fontSize: 10.0.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              // SizedBox(
              //   height: 6,
              // ),
              // Text(
              //   "facilisi sit ullamcorper pellentesque",
              //   style: AppTheme.h3Style
              //       .copyWith(fontSize: 10.0.sp, color: AppColors.white),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/calender.png",
                          height: 5.0.h,
                          width: 5.0.w,
                          color: AppColors.white,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.event['date'] != null
                              ? DateFormat(' dd MMMM, yyyy', 'it').format(
                                  DateFormat("yyyy-MM-dd hh:mm:ss")
                                      .parse(widget.event['date']))
                              : '--/--',
                          style: AppTheme.h3Style.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0.sp,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        widget.event['from_time'] == null
                            ? const SizedBox()
                            : Text(
                                " - dalle  ${DateFormat('HH:mm').format(DateFormat('hh:mm:ss').parse(widget.event['from_time']))}",
                                style: AppTheme.h3Style.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0.sp,
                                  color: AppColors.white,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }

  Padding buildHeader() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  (ref.read(flavorProvider).lightPrimary),
                  (ref.read(flavorProvider).lightPrimary),
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
              )),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              widget.event == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "${widget.event['event_name'] ?? ""}",
                        style: AppTheme.h3Style.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0.sp,
                            color: AppColors.white),
                      ),
                    ),
              const SizedBox(
                height: 6,
              ),
              widget.event == null
                  ? const SizedBox()
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: SizedBox(),
                      /*     Html(
                        data:
                            "${widget.data['event_description'] == null ? "" : widget.data['event_description']}",
                        onLinkTap: (String url,
                            RenderContext context,
                            Map<String, String> attributes,
                            dom.Element element) {
                          launchUrl(url);
                          //open URL in webview, or launch URL in browser, or any other logic here
                        },
                        // customTextStyle: (node, TextStyle baseStyle) {
                        //  return baseStyle.merge(TextStyle( fontSize: 12.0.sp,fontWeight: FontWeight.bold,color: Colors.white));
                        // }
                        style: {
                          "body": Style(
                              //fontWeight: FontWeight.bold,

                              color: Colors.white),
                        },

                      ),*/
                    ),
              // Text("${widget.data['event_description']==null?"":widget.data['event_description']}",
              //     style: AppTheme.h3Style.copyWith(
              //       fontSize: 10.0.sp,
              //       color: AppColors.white,
              //     )),
              // SizedBox(
              //   height: 6,
              // ),
              // Text(
              //   "acylysis sit ullamcorper pellentesque",
              //   style: AppTheme.h3Style
              //       .copyWith(fontSize: 10.0.sp, color: AppColors.white),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/calender.png",
                          height: 5.0.h,
                          width: 5.0.w,
                          color: AppColors.white,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                            DateFormat('dd/MM/yyyy').format(
                                DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(widget.event['date'])),
                            style: AppTheme.h3Style.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0.sp,
                              color: AppColors.white,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        widget.event['from_time'] == null
                            ? const SizedBox()
                            : Text(
                                DateFormat('HH:mm').format(
                                    DateFormat("hh:mm:ss")
                                        .parse(widget.event['from_time'])),
                                style: AppTheme.h3Style.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0.sp,
                                  color: AppColors.white,
                                )),
                      ],
                    ),
                    //TODO fix???
                    /*     InkWell(
                      onTap: () {
                        _controller.expanded;
                        _controller.toggle.call();

                        // if (_controller.value) {
                        //   eventList.expanded = true;
                        //   setState(() {});
                        // } else {
                        //   eventList.expanded = false;
                        //   setState(() {});
                        // }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            translate(context, "findout"),
                            textAlign: TextAlign.center,
                            style: AppTheme.h3Style.copyWith(
                                fontSize: 10.0.sp,
                                color: ref.read(flavorProvider).primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )*/
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
            ]),
          ),
        ));
  }
}
