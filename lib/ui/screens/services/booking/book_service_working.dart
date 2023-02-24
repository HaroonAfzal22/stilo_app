import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../apis/apisNew.dart';
import '../../../../models/flavor.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/theme.dart';
import '../../../../translations/translate_string.dart';
import '../../../../utils/ImageString.dart';
import '../../../custom_widgets/bottom_sheets/bottom_sheet_reservation_success.dart';
import '../../coupons_screen.dart';

// class BookServiceWorking extends ConsumerStatefulWidget {
//   const BookServiceWorking({
//     Key? key,
//   }) : super(key: key);

//   static const routeName = '/book-service-working';

//   @override
//   ConsumerState createState() => _BookServiceWorkingState();
// }

// class _BookServiceWorkingState extends ConsumerState<BookServiceWorking> {
//   dynamic service;
//   int step = 0;
//   final ApisNew _apisNew = ApisNew();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
//       service = ModalRoute.of(context)?.settings.arguments;
//       setState(() {});
//     });
//   }

//   bool validate() {
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       persistentFooterButtons: [
//         SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: ElevatedButton(
//               style: ButtonStyle(
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 backgroundColor: MaterialStateProperty.all<Color>(
//                     ref.read(flavorProvider).lightPrimary),
//               ),
//               child: Text(
//                 step == 2
//                     ? translate(context, 'complate_order')
//                     : translate(context, 'continue'),
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//               ),
//               onPressed: () {
//                 setState(() {
//                   step++;
//                 });
//                 //TODO fix
//                 if (step == 2) {
//                   //TODO validate
//                   _apisNew.createServiceReservation({
//                     "user_id": ref.read(authProvider).user!.userId,
//                     //TODO fix
//                     "slot_id": "",
//                     "offer_id": null,
//                     "reservation_date": "02/05/2022",
//                     //"sede_id": 2, //TODO
//                   });
//                   showModalBottomSheet(
//                     context: (context),
//                     isDismissible: false,
//                     isScrollControlled: true,
//                     builder: (context) => BottomSheetReservationSuccess(
//                       reservation: service,
//                       //TODO passare dati
//                     ),
//                   );
//                 }
//               }),
//         )
//       ],
//       appBar: AppBar(
//         title: Text(
//           translate(context, 'service_booking'),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
//               color: ref.read(flavorProvider).primary,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   if (step == 0)
//                     Container(
//                       width: 20,
//                       height: 20,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(100),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '1',
//                           style: TextStyle(
//                             color: ref.read(flavorProvider).primary,
//                           ),
//                         ),
//                       ),
//                     )
//                   else
//                     const Icon(
//                       Icons.check_circle,
//                       color: Colors.white,
//                     ),
//                   const SizedBox(
//                     width: 2,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (step != 0) step = 0;
//                       });
//                     },
//                     child: Text(
//                       translate(context, 'Time_Choice'),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight:
//                               step == 0 ? FontWeight.w900 : FontWeight.normal),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   const Icon(Icons.arrow_forward, color: Colors.white),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   if (step > 1)
//                     const Icon(
//                       Icons.check_circle,
//                       color: Colors.white,
//                     )
//                   else
//                     Container(
//                       width: 20,
//                       height: 20,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(100),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '2',
//                           style: TextStyle(
//                             color: ref.read(flavorProvider).primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                   const SizedBox(
//                     width: 2,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (step != 1) step = 1;
//                       });
//                     },
//                     child: Text(
//                       translate(context, 'no_reservation_box'),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight:
//                               step == 1 ? FontWeight.w900 : FontWeight.normal),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             IndexedStack(
//               index: step,
//               children: [
//                 FirstStep(
//                   service: service,
//                 ),
//                 SecondStep(
//                   service: service,
//                 ),
//                 const SizedBox(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FirstStep extends ConsumerStatefulWidget {
//   const FirstStep({
//     required this.service,
//     Key? key,
//   }) : super(key: key);
//   final dynamic service;

//   @override
//   ConsumerState createState() => _FirstStepState();
// }

// class _FirstStepState extends ConsumerState<FirstStep> {
//   Future<void> getCalendar() async {
//     final result = await _apisNew.getCalendar({
//       'user_id': ref.read(authProvider).user!.userId,
//       'pharmacy_id': ref.read(flavorProvider).pharmacyId,
//       //TODO sostituire widget.service['id']
//       'service_id': 65,
//       'start': 0,
//       'size': 5,
//     });
//     calendar = result.data;
//     setState(() {
//       if (calendar != null) {
//         selectedDate = calendar![0];
//         selectedDateIndex = 0;
//       }
//     });
//   }

//   Future<void> getSlotsByDate(dynamic startDate) async {
//     if (startDate is String) {
//       var splitted = startDate.split('/');
//       startDate =
//           DateTime.parse(splitted[2] + '-' + splitted[1] + '-' + splitted[0]);
//     }
//     final result = await _apisNew.getSlotsByDay(
//       {
//         'user_id': ref.read(authProvider).user!.userId,
//         'pharmacy_id': ref.read(flavorProvider).pharmacyId,
//         //TODO fix
//         'service_id': 65,
//         'date': DateFormat('dd/MM/yyyy').format(
//           startDate,
//         ),
//       },
//     );
//     slots = result.data;
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     getSlotsByDate(
//       DateTime.now(),
//     );
//     getCalendar();
//   }

//   final ApisNew _apisNew = ApisNew();
//   List<dynamic>? calendar;
//   List<dynamic>? slots;
//   dynamic selectedDate;
//   dynamic selectedSlotId;
//   dynamic selectedDateIndex;
//   dynamic selectedSlotIndex;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
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
//                     //TODO fix
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
//                             selectedDateIndex = index;
//                             selectedDate = calendar![index];
//                             slots = null;
//                             selectedSlotIndex = null;
//                             selectedSlotId = null;
//                           });

//                           var splitted =
//                               selectedDate['service_from_date'].split('-');
//                           var formattedDate = splitted[2] +
//                               '/' +
//                               splitted[1] +
//                               '/' +
//                               splitted[0];
//                           getSlotsByDate(formattedDate);
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
//           if (slots != null && slots!.isNotEmpty)
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
//                         selectedSlotId = slots![index];
//                         selectedSlotIndex = index;
//                       });
//                     },
//                     child: SlotGridItem(
//                       index: index,
//                       selectedIndex: selectedSlotIndex,
//                       slotItem: slots![index],
//                     ),
//                   );
//                 })
//           else if (slots != null && slots!.isEmpty)
//             //TODO translate
//             const NoData(
//               text: 'Non ci sono slot disponibili',
//             )
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

// class SecondStep extends ConsumerStatefulWidget {
//   const SecondStep({
//     Key? key,
//     required this.service,
//   }) : super(key: key);

//   final dynamic service;

//   @override
//   ConsumerState createState() => _SecondStepState();
// }

// class _SecondStepState extends ConsumerState<SecondStep> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           color: Colors.grey[100],
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 translate(context, "Booking_Summary"),
//                 style: AppTheme.h5Style.copyWith(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     translate(
//                         context,
//                         ref.read(flavorProvider).isParapharmacy
//                             ? "Booking_Summary_des_parapharmacy"
//                             : "Booking_Summary_des_pharmacy"),
//                     style: AppTheme.h6Style.copyWith(fontSize: 10.0.sp),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 16,
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 translate(context, "Details"),
//                 style: AppTheme.h5Style
//                     .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               if (widget.service != null)
//                 Container(
//                   color: AppColors.white,
//                   child: Container(
//                     color: AppColors.white,
//                     margin: const EdgeInsets.all(0),
//                     child: Table(
//                       columnWidths: const {
//                         0: FlexColumnWidth(1),
//                         1: FlexColumnWidth(8),
//                       },
//                       border: const TableBorder(
//                           bottom: BorderSide(color: AppColors.grey),
//                           horizontalInside: BorderSide(color: AppColors.grey)),
//                       children: [
//                         TableRow(children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Image.asset(ic_calender, height: 20),
//                           ),
//                           //TODO fix
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Text(
//                               '--/--/--',
//                               style: AppTheme.bodyText.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                   color: AppColors.black),
//                             ),
//                           ),
//                         ]),
//                         TableRow(children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 12.0),
//                             child: Image.asset(
//                               ic_plan_watch,
//                               height: 15,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Text(
//                               translate(context, "from_service_booking"),
//                               style: AppTheme.bodyText.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                   color: AppColors.black),
//                             ),
//                           ),
//                         ]),
//                         TableRow(children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Image.asset(
//                               ic_outlined_location,
//                               height: 20,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Text(
//                               widget.service['address'] ?? 'N/D',
//                               style: AppTheme.bodyText.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                   color: AppColors.black),
//                             ),
//                           ),
//                         ]),
//                         TableRow(children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 11.0),
//                             child: Center(
//                               child: Image.asset(
//                                 ic_cash,
//                                 height: 13,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Text(
//                               "${translate(context, "Cost")}  ${NumberFormat.currency(locale: 'it_IT', symbol: '€').format(double.tryParse(widget.service['price']))} ${translate(context, "booking")}",
//                               style: AppTheme.bodyText.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                   color: AppColors.black),
//                             ),
//                           ),
//                         ]),
//                       ],
//                     ),
//                   ),
//                 ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Coupon',
//                       style: AppTheme.h4Style
//                           .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(CouponsScreen.routeName);
//                     },
//                     child: Text(
//                       translate(context, 'view_all'),
//                       style: AppTheme.h6Style.copyWith(
//                           color: ref.read(flavorProvider).lightPrimary,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                         spreadRadius: 2,
//                         color: Colors.black.withOpacity(0.15),
//                         blurRadius: 5)
//                   ],
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 8,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           contentPadding:
//                               const EdgeInsets.symmetric(horizontal: 8),
//                           hintText: translate(context, 'promocode'),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Container(
//                           color: Colors.black,
//                           height: 50,
//                           child: Center(
//                             child: Text(
//                               translate(context, 'apply'),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SlotGridItem extends StatefulWidget {
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
//   State<SlotGridItem> createState() => _SlotGridItemState();
// }

// class _SlotGridItemState extends State<SlotGridItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       color: widget.selectedIndex == widget.index ? Colors.blue : Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             widget.slotItem['start_time'] + ' - ' + widget.slotItem['end_time'],
//             style: TextStyle(
//                 color: widget.selectedIndex == widget.index
//                     ? Colors.white
//                     : Colors.black),
//           ),
//           Text(
//             '${widget.slotItem['seat_available_count']} posti liberi',
//             style: TextStyle(
//                 color: widget.selectedIndex == widget.index
//                     ? Colors.white
//                     : Colors.black),
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
//                   color: widget.index == widget.selectedIndex
//                       ? Colors.white
//                       : Colors.black),
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
