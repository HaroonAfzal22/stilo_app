// import 'package:contacta_pharmacy/apis/apisNew.dart';
// import 'package:contacta_pharmacy/providers/auth_provider.dart';
// import 'package:contacta_pharmacy/providers/service_booking_provider.dart';
// import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
// import 'package:contacta_pharmacy/ui/screens/services/booking/book_service_summary_booking.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';

// import '../../../../models/flavor.dart';
// import '../../../../theme/app_colors.dart';
// import '../../../../translations/translate_string.dart';
// import '../../../custom_widgets/bottom_sheets/bottom_sheet_reservation_success.dart';

// class BookService extends ConsumerStatefulWidget {
//   const BookService({Key? key}) : super(key: key);
//   static const routeName = '/book-service';

//   @override
//   _BookServiceState createState() => _BookServiceState();
// }

// class _BookServiceState extends ConsumerState<BookService> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       service = ModalRoute.of(context)?.settings.arguments;
//       setState(() {});
//     });
//   }

//   final ApisNew _apisNew = ApisNew();
//   int step = 0;
//   dynamic service;
//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(authProvider).user != null
//         ? Scaffold(
//             persistentFooterButtons: [
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           ref.read(flavorProvider).lightPrimary),
//                     ),
//                     child: Text(
//                       step == 2
//                           ? translate(context, 'complate_order')
//                           : translate(context, 'continue'),
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 24),
//                     ),
//                     //TODO estrarre metodi
//                     onPressed: () {
//                       setState(() {
//                         step++;
//                       });
//                       //TODO fix
//                       if (step == 2) {
//                         //TODO validate
//                         _apisNew.createServiceReservation({
//                           "user_id": ref.read(authProvider).user!.userId,
//                           //TODO mettere quello giusto
//                           "slot_id": ref
//                               .read(serviceBookingProvider)
//                               .selectedSlotIndex,
//                           "offer_id": null,
//                           "reservation_date": "02/05/2022",
//                           //"sede_id": 2,
//                         });
//                         showModalBottomSheet(
//                           context: (context),
//                           isDismissible: false,
//                           isScrollControlled: true,
//                           builder: (context) => BottomSheetReservationSuccess(
//                             reservation: service,
//                             //TODO passare dati
//                           ),
//                         );
//                       }
//                     }),
//               )
//             ],
//             appBar: AppBar(
//               title: Text(translate(context, 'service_booking')),
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
//                     color: ref.read(flavorProvider).primary,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         if (step == 0)
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(100),
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '1',
//                                 style: TextStyle(
//                                   color: ref.read(flavorProvider).primary,
//                                 ),
//                               ),
//                             ),
//                           )
//                         else
//                           const Icon(
//                             Icons.check_circle,
//                             color: Colors.white,
//                           ),
//                         const SizedBox(
//                           width: 2,
//                         ),
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               if (step != 0) step = 0;
//                             });
//                           },
//                           child: Text(
//                             translate(context, 'Time_Choice'),
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: step == 0
//                                     ? FontWeight.w900
//                                     : FontWeight.normal),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         const Icon(Icons.arrow_forward, color: Colors.white),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         if (step > 1)
//                           const Icon(
//                             Icons.check_circle,
//                             color: Colors.white,
//                           )
//                         else
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(100),
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '2',
//                                 style: TextStyle(
//                                   color: ref.read(flavorProvider).primary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         const SizedBox(
//                           width: 2,
//                         ),
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               if (step != 1) step = 1;
//                             });
//                           },
//                           child: Text(
//                             translate(context, 'no_reservation_box'),
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: step == 1
//                                     ? FontWeight.w900
//                                     : FontWeight.normal),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IndexedStack(
//                     index: step,
//                     children: const [
//                       BookServiceChooseDate(),
//                       BookServiceSummaryBooking(),
//                       SizedBox(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : Scaffold(
//             body: const NoUser(),
//             appBar: AppBar(
//               title: Text(
//                 translate(context, 'service_booking'),
//               ),
//             ),
//           );
//   }
// }

// class BookServiceChooseDate extends ConsumerStatefulWidget {
//   const BookServiceChooseDate({
//     Key? key,
//   }) : super(key: key);

//   @override
//   ConsumerState<BookServiceChooseDate> createState() =>
//       _BookServiceChooseDateState();
// }

// class _BookServiceChooseDateState extends ConsumerState<BookServiceChooseDate> {
//   dynamic selectedDateIndex;
//   int? selectedSlotIndex;
//   final ApisNew _apisNew = ApisNew();
//   List<dynamic>? calendar;
//   List<dynamic>? slots;

//   Future<void> getCalendar() async {
//     final result = await _apisNew.getCalendar({
//       'user_id': ref.read(authProvider).user!.userId,
//       'pharmacy_id': ref.read(flavorProvider).pharmacyId,
//       'service_id': 65,
//       'start': 0,
//       'size': 5,
//     });
//     calendar = result.data;
//     setState(() {
//       if (calendar != null) {
//         selectedDateIndex = calendar![0]['service_from_date'];
//       }
//     });
//   }

//   Future<void> getSlotsByDate() async {
//     final result = await _apisNew.getSlotsByDay(
//       {
//         'user_id': ref.read(authProvider).user!.userId,
//         'pharmacy_id': ref.read(flavorProvider).pharmacyId,
//         'service_id': 65,
//         'date': DateFormat('dd/MM/yyyy').format(
//           DateTime.now(),
//         ),
//       },
//     );
//     slots = result.data;
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (ref.read(authProvider).user != null) {
//       getCalendar();
//       getSlotsByDate();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: 16,
//           ),
//           if (calendar != null)
//             SizedBox(
//               height: 80,
//               child: ListView.separated(
//                   separatorBuilder: (context, index) => const SizedBox(
//                         width: 10,
//                       ),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: calendar!.length + 1,
//                   itemBuilder: (context, index) {
//                     if (index == calendar!.length) {
//                       return GestureDetector(
//                         onTap: () {},
//                         child: const Card(
//                           child: Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 'Carica più giorni',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             ref.read(serviceBookingProvider).selectedDateIndex(
//                                   calendar![index]['service_from_date'],
//                                 );
//                             selectedDateIndex =
//                                 calendar![index]['service_from_date'];
//                             selectedSlotIndex = null;
//                           });
//                         },
//                         child: SlotDayItem(
//                           item: calendar![index],
//                           index: index,
//                           selectedIndex: selectedDateIndex,
//                         ),
//                       );
//                     }
//                   }),
//             )
//           else
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   color: ref.read(flavorProvider).lightPrimary,
//                 ),
//               ),
//             ),
//           const SizedBox(
//             height: 8,
//           ),
//           Text(
//             translate(context, "select_the_free_slot"),
//             style: TextStyle(
//               color: AppColors.black,
//               fontSize: 16.0.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           if (slots != null)
//             GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisExtent: 64,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8),
//                 itemCount: slots!.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedSlotIndex = index;
//                         ref.read(serviceBookingProvider).selectSlot(index);
//                       });
//                     },
//                     child: SlotGridItem(
//                       index: index,
//                       selectedIndex: selectedSlotIndex,
//                       slotItem: slots![index],
//                     ),
//                   );
//                 })
//           else
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   color: ref.read(flavorProvider).lightPrimary,
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }

// class SlotGridItem extends StatelessWidget {
//   const SlotGridItem({
//     Key? key,
//     required this.selectedIndex,
//     required this.index,
//     required this.slotItem,
//   }) : super(key: key);

//   final int? selectedIndex;
//   final int index;
//   final dynamic slotItem;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       color: selectedIndex == index ? Colors.blue : Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             slotItem['start_time'] + ' - ' + slotItem['end_time'],
//             style: TextStyle(
//                 color: selectedIndex == index ? Colors.white : Colors.black),
//           ),
//           Text(
//             '${slotItem['seat_available_count']} posti liberi',
//             style: TextStyle(
//                 color: selectedIndex == index ? Colors.white : Colors.black),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SlotDayItem extends ConsumerStatefulWidget {
//   const SlotDayItem({
//     required this.item,
//     required this.index,
//     required this.selectedIndex,
//     Key? key,
//   }) : super(key: key);
//   final dynamic index;
//   final dynamic selectedIndex;
//   final dynamic item;

//   @override
//   ConsumerState<SlotDayItem> createState() => _SlotDayItemState();
// }

// class _SlotDayItemState extends ConsumerState<SlotDayItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       color: widget.index == widget.selectedIndex ? Colors.blue : Colors.white,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text(
//               widget.item['month'] + ' ' + widget.item['date'],
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color:
//                       widget.item['service_from_date'] == widget.selectedIndex
//                           ? Colors.white
//                           : Colors.black),
//             ),
//             const SizedBox(
//               height: 4,
//             ),
//             Container(
//               height: 10,
//               width: 10,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: 1 < 0
//                         ? Colors.white
//                         : 1 > 0
//                             ? ref.read(flavorProvider).primary
//                             : AppColors.darkRed,
//                     blurRadius: 5.0,
//                   ),
//                 ],
//                 color: 1 < 4
//                     ? ref.read(flavorProvider).primary
//                     : AppColors.darkRed,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
