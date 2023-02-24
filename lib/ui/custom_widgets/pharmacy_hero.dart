import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/providers/time_tables_provider.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/screens/services/videocall_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';

class PharmacyHero extends ConsumerStatefulWidget {
  const PharmacyHero({
    Key? key,
    required this.imageUrl,
    required this.todayOpeningHoursEvening,
    required this.todayOpeningHoursMorning,
    required this.todayClosingHoursMorning,
    required this.todayClosingHoursEvening,
    required this.telephone,
    required this.morningHoursOpen,
    required this.morningHoursClose,
    required this.eveningHoursOpen,
    required this.eveningHoursClose,
  }) : super(key: key);

  final String imageUrl;
  final String todayOpeningHoursMorning;
  final String todayOpeningHoursEvening;
  final String todayClosingHoursMorning;
  final String todayClosingHoursEvening;
  final String telephone;
  final String? morningHoursOpen;
  final String? morningHoursClose;
  final String? eveningHoursOpen;
  final String? eveningHoursClose;

  @override
  ConsumerState<PharmacyHero> createState() => _PharmacyHeroState();
}

class _PharmacyHeroState extends ConsumerState<PharmacyHero> {
  bool isMorning = false;
  bool isEvening = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => VideoView())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset("assets/icons/telefarmacia.png"),
          ),
          // const SizedBox(height: 16),
          // Text(
          //   "Telefarmacia",
          //   textAlign: TextAlign.center,
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline4
          //       ?.copyWith(color: Colors.white),
          // ),
          // Text(
          //   "Scopri il nostro servizio di telefarmacia!",
          //   textAlign: TextAlign.center,
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyText2
          //       ?.copyWith(color: Colors.white),
          // )
          // Text(
          //   "Contatta Farmacie Stilo attraverso il nostro servizio di Telefarmacia.\nI nostri farmacisti saranno pronti a fornire assistenza, supporto e preziosi consigli.\nVerifica subito la disponibilità di un operatore oppure prenota un appuntamento. ",
          //   textAlign: TextAlign.center,
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyText2
          //       ?.copyWith(color: Colors.white),
          // )
        ],
      ),
    );
    // return Container(
    //     margin: const EdgeInsets.only(
    //       left: 16,
    //       right: 16,
    //       top: 8,
    //     ),
    //     decoration: BoxDecoration(
    //       color: ref.read(flavorProvider).lightPrimary,
    //       borderRadius: const BorderRadius.all(
    //         Radius.circular(5),
    //       ),
    //     ),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           flex: 7,
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 8,
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   getTextTurn(
    //                       widget.morningHoursOpen,
    //                       widget.morningHoursClose,
    //                       widget.eveningHoursOpen,
    //                       widget.eveningHoursClose),
    //                   style: const TextStyle(
    //                     fontSize: 18,
    //                     color: AppColors.white,
    //                     fontWeight: FontWeight.w700,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 8),
    //                 Container(
    //                   padding: const EdgeInsets.symmetric(horizontal: 4),
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       Icon(
    //                         Icons.call,
    //                         color: ref.read(flavorProvider).lightPrimary,
    //                         size: 12,
    //                       ),
    //                       Consumer(builder: (context, ref, _) {
    //                         return Text(
    //                           ref.watch(contactsProvider).value?.phone ?? "",
    //                           style: TextStyle(
    //                               fontSize: 12,
    //                               fontWeight: FontWeight.bold,
    //                               color: ref.read(flavorProvider).lightPrimary),
    //                         );
    //                       }),
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(height: 8),
    //                 Row(
    //                   children: [
    //                     const Icon(
    //                       Icons.access_time_filled_outlined,
    //                       color: Colors.white,
    //                     ),
    //                     const SizedBox(
    //                       width: 5,
    //                     ),
    //                     Column(
    //                       children: [
    //                         Container(
    //                           constraints: const BoxConstraints(
    //                               minWidth: 80, maxWidth: 140),
    //                           child: widget.todayOpeningHoursMorning == "" &&
    //                                   widget.todayClosingHoursMorning == ""
    //                               ? const SizedBox(
    //                                   height: 0,
    //                                 )
    //                               : Row(
    //                                   children: [
    //                                     isMorning
    //                                         ? Text(
    //                                             '${translate(context, DateFormat('EE').format(DateTime.now()).toString())}: ',
    //                                             style: const TextStyle(
    //                                                 color: Colors.white,
    //                                                 fontWeight:
    //                                                     FontWeight.bold),
    //                                           )
    //                                         : isEvening
    //                                             ? const SizedBox()
    //                                             : Text(
    //                                                 '${translate(context, DateFormat('EE').format(DateTime.now()).toString())}: ',
    //                                                 style: const TextStyle(
    //                                                   color: Colors.white,
    //                                                 )),
    //                                     Text(widget.todayOpeningHoursMorning,
    //                                         style: isMorning
    //                                             ? const TextStyle(
    //                                                 color: Colors.white,
    //                                                 fontWeight: FontWeight.bold)
    //                                             : const TextStyle(
    //                                                 color: Colors.white,
    //                                               )),
    //                                     const SizedBox(
    //                                       width: 4,
    //                                     ),
    //                                     Text(
    //                                       translate(context, 'at'),
    //                                       style: isMorning
    //                                           ? const TextStyle(
    //                                               color: Colors.white,
    //                                               fontWeight: FontWeight.bold)
    //                                           : const TextStyle(
    //                                               color: Colors.white),
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 4,
    //                                     ),
    //                                     Text(
    //                                       widget.todayClosingHoursMorning,
    //                                       style: isMorning
    //                                           ? const TextStyle(
    //                                               color: Colors.white,
    //                                               fontWeight: FontWeight.bold)
    //                                           : const TextStyle(
    //                                               color: Colors.white),
    //                                     ),
    //                                   ],
    //                                 ),
    //                         ),
    //                         Container(
    //                           constraints: const BoxConstraints(
    //                               minWidth: 80, maxWidth: 140),
    //                           child: widget.todayClosingHoursEvening == "" &&
    //                                   widget.todayOpeningHoursEvening == ""
    //                               ? const SizedBox()
    //                               : Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.start,
    //                                   children: [
    //                                     isEvening
    //                                         ? Text(
    //                                             '${translate(context, DateFormat('EE').format(DateTime.now()).toString())}: ',
    //                                             style: const TextStyle(
    //                                                 color: Colors.white,
    //                                                 fontWeight:
    //                                                     FontWeight.bold),
    //                                           )
    //                                         : const SizedBox(),
    //                                     Text(
    //                                       widget.todayOpeningHoursEvening,
    //                                       style: isEvening
    //                                           ? const TextStyle(
    //                                               color: Colors.white,
    //                                               fontWeight: FontWeight.bold)
    //                                           : const TextStyle(
    //                                               color: Colors.white),
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 4,
    //                                     ),
    //                                     Text(
    //                                       "alle",
    //                                       style: isEvening
    //                                           ? const TextStyle(
    //                                               color: Colors.white,
    //                                               fontWeight: FontWeight.bold)
    //                                           : const TextStyle(
    //                                               color: Colors.white),
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 4,
    //                                     ),
    //                                     Text(
    //                                       widget.todayClosingHoursEvening,
    //                                       style: isEvening
    //                                           ? const TextStyle(
    //                                               color: Colors.white,
    //                                               fontWeight: FontWeight.bold)
    //                                           : const TextStyle(
    //                                               color: Colors.white),
    //                                     ),
    //                                   ],
    //                                 ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           flex: 4,
    //           child: Container(
    //             decoration: BoxDecoration(
    //               color: ref.read(flavorProvider).lightPrimary,
    //               borderRadius: const BorderRadius.only(
    //                 topRight: Radius.circular(5.0),
    //                 bottomRight: Radius.circular(5.0),
    //               ),
    //             ),
    //             child: ClipRRect(
    //               borderRadius: const BorderRadius.only(
    //                 topRight: Radius.circular(5),
    //                 bottomRight: Radius.circular(5),
    //               ),
    //               child: CachedNetworkImage(
    //                 imageUrl: widget.imageUrl,
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ));
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
    setState(() {
      openMorning != null && closeMorning != null
          ? isMorning = isInRange(openMorning, closeMorning)
          : isMorning = false;
      openEvening != null && closeEvening != null
          ? isEvening = isInRange(openEvening, closeEvening)
          : isEvening = false;
    });
    return (isMorning || isEvening)
        ? translate(context, 'open_status')
        : translate(context, 'closed_status');
  }
}

// class PharmacyHeroOnlyMorning extends StatelessWidget {
//   const PharmacyHeroOnlyMorning({
//     Key? key,
//     this.imageUrl,
//     this.title,
//     this.telephone,
//     this.todayClosingHoursMorning,
//     this.todayOpeningHoursMorning,
//   }) : super(key: key);

//   final String? imageUrl;
//   final String? title;
//   final String? telephone;
//   final String? todayOpeningHoursMorning;
//   final String? todayClosingHoursMorning;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.only(
//           left: 16,
//           right: 16,
//           top: 8,
//         ),
//         decoration: const BoxDecoration(
//           color: ref.read(flavorProvider).lightPrimary,
//           borderRadius: BorderRadius.all(
//             Radius.circular(5),
//           ),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 7,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title ?? '',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         color: AppColors.white,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 2,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.call,
//                             color: ref.read(flavorProvider).lightPrimary,
//                             size: 12,
//                           ),
//                           Text(
//                             telephone ?? '',
//                             style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: ref.read(flavorProvider).lightPrimary),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 2,
//                     ),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.access_time_filled_outlined,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               constraints: const BoxConstraints(
//                                   minWidth: 80, maxWidth: 140),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     translate(
//                                             context,
//                                             DateFormat('EE')
//                                                 .format(DateTime.now())
//                                                 .toString()) +
//                                         ': ',
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(todayOpeningHoursMorning ?? '',
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold)),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   Text(translate(context, 'at'),
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold)),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   Text(todayClosingHoursMorning ?? '',
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold)),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               constraints: const BoxConstraints(
//                                   minWidth: 80, maxWidth: 140),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: ref.read(flavorProvider).lightPrimary,
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(5.0),
//                     bottomRight: Radius.circular(5.0),
//                   ),
//                 ),
//                 child: CachedNetworkImage(
//                   imageUrl: imageUrl ??
//                       'https://blumagnolia.ch/wp-content/uploads/2021/05/placeholder-126.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }

// }
