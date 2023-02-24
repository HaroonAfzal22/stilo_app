import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/providers/app_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/flavor.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../translations/translate_string.dart';
import '../../../custom_widgets/no_data.dart';
import 'book_service_second_screen.dart';

class BookServiceFirstScreen extends ConsumerStatefulWidget {
  const BookServiceFirstScreen({Key? key}) : super(key: key);
  static const routeName = '/book-service-first-screen';

  @override
  _BookServiceFirstScreenState createState() => _BookServiceFirstScreenState();
}

class _BookServiceFirstScreenState
    extends ConsumerState<BookServiceFirstScreen> {
  Map<String, dynamic>? service;
  final ApisNew _apisNew = ApisNew();
  List<dynamic>? calendar;
  List<dynamic>? slots;
  dynamic selectedDate;
  dynamic selectedSlotId;
  dynamic selectedDateIndex;
  dynamic selectedSlotIndex;
  int? start;
  int? size;

  bool validate() {
    if (selectedDate != null && selectedSlotId != null) {
      return true;
    } else {
      showredToast('Devi selezionare un giorno e uno slot', context);
      return false;
    }
  }

  Future<dynamic> getCalendar() async {
    final result = await _apisNew.getCalendar({
      'user_id': ref.read(authProvider).user!.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'service_id': int.parse(service!['id']),
      'start': 0,
      'size': 31,
    });
    calendar = result.data;
    setState(() {
      if (calendar != null) {
        selectedDate = calendar![0];
        selectedDateIndex = 0;
      }
    });
  }

  Future<void> getSlotsByDate(dynamic startDate) async {
    if (startDate is String) {
      var splitted = startDate.split('/');
      startDate =
          DateTime.parse(splitted[2] + '-' + splitted[1] + '-' + splitted[0]);
    }
    final result = await _apisNew.getSlotsByDay(
      {
        'user_id': ref.read(authProvider).user!.userId,
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
        'service_id': int.parse(service!['id']),
        'date': DateFormat('dd/MM/yyyy').format(
          startDate,
        ),
      },
    );
    slots = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      service =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {});
      if (ref.read(authProvider).user != null) {
        getCalendar().whenComplete(() {
          if (calendar != null && calendar!.isNotEmpty) {
            var splitted = calendar![0]['service_from_date'].split('-');
            var formattedDate =
                splitted[2] + '/' + splitted[1] + '/' + splitted[0];
            getSlotsByDate(formattedDate);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authProvider).user;
    return Scaffold(
      persistentFooterButtons: [
        if (user != null)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      ref.read(flavorProvider).lightPrimary),
                ),
                child: Text(
                  translate(context, 'continue'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                onPressed: () {
                  if (validate()) {
                    Navigator.of(context).pushNamed(
                        BookServiceSecondScreen.routeName,
                        arguments: {
                          'service': service,
                          'selectedDate': selectedDate,
                          'selectedSlot': selectedSlotId,
                        });
                  }
                }),
          )
      ],
      appBar: AppBar(
        title: Text(
          translate(context, 'Time_Choice'),
        ),
      ),
      body: SingleChildScrollView(
        child: user != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    if (calendar != null)
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 10,
                                ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: calendar!.length + 1,
                            itemBuilder: (context, index) {
                              //TODO fix
                              if (index == calendar!.length) {
                                return const SizedBox();
                                //TODO fix this
                                /* GestureDetector(
                            onTap: () {},
                            child: const Card(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Carica più giorni',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );*/
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDateIndex = index;
                                      selectedDate = calendar![index];
                                      slots = null;
                                      selectedSlotIndex = null;
                                      selectedSlotId = null;
                                    });

                                    var splitted =
                                        selectedDate['service_from_date']
                                            .split('-');
                                    var formattedDate = splitted[2] +
                                        '/' +
                                        splitted[1] +
                                        '/' +
                                        splitted[0];
                                    getSlotsByDate(formattedDate);
                                  },
                                  child: SlotDayItem(
                                    item: calendar![index],
                                    index: index,
                                    selectedIndex: selectedDateIndex,
                                  ),
                                );
                              }
                            }),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ref.read(flavorProvider).lightPrimary,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      translate(context, "select_the_free_slot"),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (slots != null && slots!.isNotEmpty)
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 64,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemCount: slots!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSlotId = slots![index];
                                  selectedSlotIndex = index;
                                });
                              },
                              child: SlotGridItem(
                                index: index,
                                selectedIndex: selectedSlotIndex,
                                slotItem: slots![index],
                              ),
                            );
                          })
                    else if (slots != null && slots!.isEmpty)
                      //TODO translate
                      const NoData(
                        text: 'Non ci sono slot disponibili',
                      )
                    else
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ref.read(flavorProvider).lightPrimary,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              )
            : const NoUser(),
      ),
    );
  }
}

class SlotGridItem extends StatefulWidget {
  const SlotGridItem({
    Key? key,
    required this.selectedIndex,
    required this.index,
    required this.slotItem,
  }) : super(key: key);

  final int? selectedIndex;
  final int index;
  final dynamic slotItem;

  @override
  State<SlotGridItem> createState() => _SlotGridItemState();
}

class _SlotGridItemState extends State<SlotGridItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: widget.selectedIndex == widget.index ? Colors.blue : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.slotItem['start_time'] + ' - ' + widget.slotItem['end_time'],
            style: TextStyle(
                color: widget.selectedIndex == widget.index
                    ? Colors.white
                    : Colors.black),
          ),
          Text(
            '${widget.slotItem['seat_available_count']} posti liberi',
            style: TextStyle(
                color: widget.selectedIndex == widget.index
                    ? Colors.white
                    : Colors.black),
          ),
        ],
      ),
    );
  }
}

class SlotDayItem extends ConsumerStatefulWidget {
  const SlotDayItem({
    required this.item,
    required this.index,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);
  final dynamic index;
  final dynamic selectedIndex;
  final dynamic item;

  @override
  ConsumerState<SlotDayItem> createState() => _SlotDayItemState();
}

class _SlotDayItemState extends ConsumerState<SlotDayItem> {
  String language = "it";

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final provider = ref.read(appProvider);
      if (provider.locale == null) {
        var lang = await provider.getLocale();
        language = lang == null ? "it" : lang.languageCode;
      }
      setState(() {});
    });
    super.initState();
  }

  String translateDate(String month, String date, BuildContext context) {
    var translatedDate = "";
    var splittedDate = date.split(" ");
    if (language == "it") {
      translatedDate = translate(context, splittedDate.first) +
          " " +
          splittedDate.last +
          " " +
          translate(context, month);
    } else {
      translatedDate = translate(context, month) +
          " " +
          translate(context, splittedDate.first) +
          " " +
          splittedDate.last;
    }
    return translatedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: widget.index == widget.selectedIndex ? Colors.blue : Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              translateDate(widget.item['month'], widget.item['date'], context),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.index == widget.selectedIndex
                      ? Colors.white
                      : Colors.black),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: 1 < 0
                        ? Colors.white
                        : 1 > 0
                            ? ref.read(flavorProvider).primary
                            : AppColors.darkRed,
                    blurRadius: 5.0,
                  ),
                ],
                color: 1 < 4
                    ? ref.read(flavorProvider).primary
                    : AppColors.darkRed,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
