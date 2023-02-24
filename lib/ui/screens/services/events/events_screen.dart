import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/events/event_tile.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/flavor.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/theme.dart';
import '../../../../translations/translate_string.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);
  static const routeName = '/events-screen';

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  Future<void> getEventsList() async {
    final response = await _apisNew.getEventsList({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'sede_id': ref.read(siteProvider)!.id,
    });
    eventList = response.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEventsList();
  }

  final ApisNew _apisNew = ApisNew();
  List<dynamic>? eventList;
  @override
  Widget build(BuildContext context) {
    if (eventList == null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            color: ref.read(flavorProvider).lightPrimary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          translate(context, 'service_event'),
          style: TextStyle(color: ref.read(flavorProvider).primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      translate(
                          context,
                          ref.read(flavorProvider).isParapharmacy
                              ? "event_in_the_parapharmacy"
                              : "event_in_the_pharmacy"),
                      style: AppTheme.h3Style.copyWith(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black)),
                  //TODO fix
                  /*Image.asset(
                    "assets/icons/calender.png",
                    height: 8.0.h,
                    width: 8.0.w,
                  )*/
                ],
              ),
              Row(
                children: [
                  Text(translate(context, "there_are"),
                      style: AppTheme.h3Style.copyWith(
                          fontSize: 9.0.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey.withOpacity(.3))),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(eventList!.length.toString(),
                      style: AppTheme.h3Style.copyWith(
                          fontSize: 9.0.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey.withOpacity(.3))),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(translate(context, "events_available"),
                      style: AppTheme.h3Style.copyWith(
                          fontSize: 9.0.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey.withOpacity(.3))),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              if (eventList != null && eventList!.isEmpty)
                NoData(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2 - 100),
                    text: translate(
                        context,
                        ref.read(flavorProvider).isParapharmacy
                            ? "No_Event_parapharmacy"
                            : "No_Event_pharmacy"))
              else if (eventList != null)
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 24,
                  ),
                  shrinkWrap: true,
                  itemCount: eventList!.length,
                  itemBuilder: (context, index) => EventTile(eventList![index]),
                ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
