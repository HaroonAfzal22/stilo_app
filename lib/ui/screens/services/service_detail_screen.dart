import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../config/MyApplication.dart';
import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';
import 'booking/book_service_first_screen.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  const ServiceDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/service-detail-screen';

  @override
  ConsumerState<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  dynamic service;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      service = ModalRoute.of(context)!.settings.arguments as dynamic;
      setState(() {});
    });
  }

  String getDuration(String duration) {
    final split = duration.split(":");

    int hours = int.parse(split[0]);
    int minutes = int.parse(split[1]);

    var value = "";

    if (hours > 1) value += "$hours ore, ";
    if (hours == 1) value += "$hours ora, ";

    value += "$minutes minuti";

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        /*     iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ref.read(flavorProvider).lightPrimary,*/
        //todo fix
        title: const Text(
          'Dettaglio',
          // style: TextStyle(color: Colors.white),
        ),
      ),
      body: service != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        if (service['image'] == null)
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: Image.asset(
                              "assets/images/service_placeholder.jpeg",
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          CachedNetworkImage(
                            imageUrl: service['image'],
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                  "assets/images/service_placeholder.jpeg");
                            },
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          service['title'] ?? '',
                          textAlign: TextAlign.left,
                          style: AppTheme.h4Style.copyWith(
                              fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Html(
                          data: (service['description']) ?? '',
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TODO fix
                            /*    Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Image.asset(ic_calender, height: 20),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            translate(context, "First_slot:"),
                                            style: AppTheme.h4Style.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '--/--/--',
                                            style: AppTheme.h4Style.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '--/--/--',
                                            style: AppTheme.h4Style.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "alle",
                                              style: AppTheme.h4Style.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.lightGrey),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              "--/--/--",
                                              style: AppTheme.h4Style.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.lightGrey),
                                            ),
                                            Text(
                                              "--/--/--",
                                              style: AppTheme.h4Style.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.lightGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),*/
                            if (service['address'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 0,
                                      child: Image.asset(
                                        ic_outlined_location,
                                        height: 22,
                                      )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (service['address'] != null)
                                          Text(
                                            translate(context, "Address"),
                                            style: AppTheme.h4Style.copyWith(
                                                fontSize: 12.0.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (service['address'] != null)
                                          Text(
                                            service['address'],
                                          ),
                                        if (service['address'] != null)
                                          InkWell(
                                            onTap: () {
                                              launchUrl(
                                                  "https://www.google.com/maps/search/${Uri.encodeFull(service['address'])}");
                                            },
                                            child: Text.rich(
                                              TextSpan(
                                                text: translate(
                                                    context, "Indications"),
                                                style: AppTheme.bodyText
                                                    .copyWith(
                                                        fontSize: 10.0.sp,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 15,
                            ),

                            if (service["duration"] != null)
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  Image.asset(ic_plan_watch, height: 16),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "${translate(context, "duration")} ",
                                    style: AppTheme.h4Style.copyWith(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    getDuration(service["duration"]),
                                    style: AppTheme.h4Style.copyWith(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Image.asset(
                                  ic_cash,
                                  height: 14,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  translate(context, "cost") + " : ",
                                  style: AppTheme.h4Style.copyWith(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  service['price'] != null
                                      ? NumberFormat.currency(
                                              locale: 'it_IT', symbol: '€')
                                          .format(
                                              double.tryParse(service['price']))
                                      : 'N/A',
                                  style: AppTheme.h4Style.copyWith(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        if (service['is_available'] == true)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  BookServiceFirstScreen.routeName,
                                  arguments: service);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  color: ref.read(flavorProvider).lightPrimary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  translate(context, 'service_booking'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: AppColors.darkRed.withOpacity(0.6),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const Center(
                              child: Text(
                                'Nessuna disponibilità',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: ref.read(flavorProvider).lightPrimary,
                ),
              ),
            ),
    );
  }
}
