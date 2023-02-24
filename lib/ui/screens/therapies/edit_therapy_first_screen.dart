import 'package:auto_size_text/auto_size_text.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/models/therapy.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/dialogs/custom_dialog.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/therapies/multiselect_form.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/edit_therapy_second_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';

class EditTherapyFirstScreen extends ConsumerStatefulWidget {
  const EditTherapyFirstScreen({
    this.therapy,
    Key? key,
  }) : super(key: key);
  final dynamic therapy;

  static const routeName = '/edit-therapy-first-screen';

  @override
  _EditTherapyFirstScreenState createState() => _EditTherapyFirstScreenState();
}

class _EditTherapyFirstScreenState
    extends ConsumerState<EditTherapyFirstScreen> {
  final Map<String, dynamic> _controllers = {
    'name': TextEditingController(),
    'qty': TextEditingController(),
    'duration': TextEditingController(),
    'whenTake': TextEditingController(),
    'note': TextEditingController(),
  };

  bool validation() {
    if (_controllers['name'].text.isEmpty) {
      showredToast(translate(context, "err_name"), context);
      return false;
    } else if (_controllers['qty'].text.isEmpty) {
      showredToast(translate(context, "err_quantity"), context);
      return false;
    } else if (_controllers['duration'].text.isEmpty) {
      showredToast(translate(context, "err_duration"), context);
      return false;
    } else if (selectedValue == "daysOfWeek" && selectedWeekDays.isEmpty) {
      showredToast("seleziona intervallo", context);
      return false;
    } else if (whentotake.isEmpty) {
      showredToast(translate(context, "err_whentotake"), context);
      return false;
    }
    return true;
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(translate(context, 'Every Day')), value: "everyday"),
      DropdownMenuItem(
          child: Text(translate(context, 'Days of the week')),
          value: "daysOfWeek"),
      DropdownMenuItem(
          child: Text(translate(context, 'Days of Interval')),
          value: "intervalDays"),
    ];
    return menuItems;
  }

  Therapy? _therapy;
  int indexDrug = 0;
  int? indexItem;
  late FixedExtentScrollController scrollController;
  var items = [
    "giorni",
    "mesi",
  ];

  var drugItems = [
    "Pillole",
    "Bustine",
    "Ml",
  ];

  List weekDays = [
    {"id": 1, "name": "Lun"},
    {"id": 2, "name": "Mar"},
    {"id": 3, "name": "Mer"},
    {"id": 4, "name": "Gio"},
    {"id": 5, "name": "Ven"},
    {"id": 6, "name": "Sab"},
    {"id": 7, "name": "Dom"},
  ];
  List selectedWeekDays = [];
  String mode = "add";
  final TextEditingController _controller = TextEditingController();
  String selectedValue = 'everyday';
  String whentotake = '';
  DateTime? currentDate;
  TimeOfDay? selectedTime;
  TimeOfDay? time;
  DateTime? date;
  int freqOfDay = 0;

  Future<void> showTimePickerForTherapy() async {
    final result = await showTimePicker(
      context: context,
      //TODO fix
      initialTime: TimeOfDay.now(),
    );
    if (result != null) setState(() => time = result);
  }

  String? getTimeText() {
    if (time == null) {
      return '';
    } else {
      return '${time?.hour}:${time?.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  String getTextDate() {
    if (currentDate == null) {
      return DateTime.now().toString();
    } else {
      return "${currentDate?.day}/${currentDate?.month}/${currentDate?.year}";
    }
  }

  Future<void> openEditModal() async {
    int frequency = 1;
    await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: translate(context, 'Seleziona giorni di frequenza'),
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 110,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                frequency--;
                              });
                            }),
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: ref.read(flavorProvider).primary,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Text(
                            frequency.toString(),
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(width: 13),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                frequency++;
                              });
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              color: ref.read(flavorProvider).primary,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              freqOfDay = frequency;
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 4.0.h,
                                width: 20.0.w,
                                decoration: BoxDecoration(
                                  color: ref.read(flavorProvider).primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                    child: Text(
                                  translate(context, "select"),
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.white,
                                    fontSize: 10.0.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                                height: 4.0.h,
                                width: 20.0.w,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color:
                                            ref.read(flavorProvider).primary)),
                                child: Center(
                                    child: Text(
                                  translate(context, "cancel"),
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.black,
                                    fontSize: 10.0.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildPicker() => SizedBox(
        height: 180,
        child: CupertinoPicker(
          diameterRatio: 1,
          scrollController: scrollController,
          useMagnifier: true,
          magnification: 1.2,
          itemExtent: 30,
          children: items
              .map((item) => Center(
                    child: Text(item, style: const TextStyle(fontSize: 17)),
                  ))
              .toList(),
          onSelectedItemChanged: (indexItem) async {
            //  setState(() =>
            this.indexItem = indexItem;
            setState(() {});
          },
        ),
      );

  Widget buildPickerDrug() => SizedBox(
        height: 180,
        child: CupertinoPicker(
          diameterRatio: 1,
          scrollController: scrollController,
          useMagnifier: true,
          magnification: 1.2,
          itemExtent: 30,
          children: drugItems
              .map((items) => Center(
                    child: Text(items, style: const TextStyle(fontSize: 17)),
                  ))
              .toList(),
          onSelectedItemChanged: (index) {
            // //  setState(() =>
            // indexDrug = index;
            // print(indexDrug);
            setState(() {
              indexDrug = index;
              final drugsItems = drugItems[indexDrug];
            });
          },
        ),
      );

  @override
  void initState() {
    super.initState();
    scrollController = FixedExtentScrollController(initialItem: 0);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _therapy = ModalRoute.of(context)!.settings.arguments as Therapy;
      _controllers['name'].text = _therapy?.product ?? '';
      _controllers['qty'].text = _therapy?.qty ?? '';
      _controllers['duration'].text = _therapy?.duration ?? '';
      _controllers['whenTake'].text = _therapy?.whenToTake ?? '';
      _controllers['note'].text = _therapy?.note ?? '';
      //TODO fixare
      // selectedValue = _therapy?.medicineFrequency ?? 'everyday';

      whentotake = _therapy?.whenToTake ?? '';
      currentDate = DateFormat('dd-MM-yyyy').parse(_therapy?.startDate ?? "");

      final timeFormat = _therapy?.asWhatTime;
      time = timeFormat == null
          ? null
          : TimeOfDay(
              hour: int.parse(timeFormat.split(":")[0]),
              minute: int.parse(timeFormat.split(":")[1]),
            );
      setState(() {});
    });
  }

  int getFrequency() {
    switch (selectedValue) {
      case "everyday":
        return 7;
      case "daysOfWeek":
        return selectedWeekDays.length;
      case "intervalDays":
        return freqOfDay;
      default:
        return 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        InkWell(
          onTap: () {
            if (validation()) {
              Navigator.of(context).pushNamed(EditTherapySecondScreen.routeName,
                  arguments: <String, dynamic>{
                    "product": _controllers['name'].text,
                    "description": _controllers['note'].text,
                    "medicine_fequency": getFrequency(),
                    "qty": _controllers['qty'].text,
                    "duration": _controllers['duration'].text,
                    "id": _therapy?.id,
                    //TODO fix
                    /*  "as_what_time": time?.hour.toString()! +
                        ':' +
                        time?.minute.toString() +
                        ':00',*/
                    "start_date": currentDate ?? DateTime.now(),
                    "when_take": whentotake,
                    "note": _controllers['note'].text,
                    "drugsitem": drugItems[indexDrug],
                    "items": items[indexItem ?? 0],
                  });
            }
          },
          child: Container(
            width: double.infinity,
            height: 64,
            color: ref.read(flavorProvider).lightPrimary,
            child: Center(
              child: Text(
                translate(context, 'continue'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
      appBar: AppBar(
        title: Text(
          translate(context, 'Edit_Therapy'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "Edit_Therapy"),
                  style:
                      AppTheme.h6Style.copyWith(fontWeight: FontWeight.w600)),
              Text(translate(context, "Therapy_insertion_des"),
                  style: AppTheme.bodyText
                      .copyWith(color: AppColors.lightGrey, fontSize: 10.0.sp)),
              const SizedBox(
                height: 16,
              ),
              Text(translate(context, "PRODUCT_MEDICINE"),
                  style: AppTheme.h6Style.copyWith(color: AppColors.black)),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _controllers['name'],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        prefixIcon: Image.asset(
                          ic_primary_pils,
                          scale: 5,
                        ),
                        filled: true,
                        //hintText: translate(context, "Enter_product_medicine"),
                        hintStyle: AppTheme.bodyText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightGrey),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const Dialog(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                                'Non puoi modificare il farmaco in questa sezione. Prova a creare una nuova terapia.'),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(children: [
                Text(
                  "Scegli una frequenza",
                  style: AppTheme.h6Style.copyWith(color: AppColors.black),
                )
              ]),
              const SizedBox(
                height: 4,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: DropdownButton(
                      underline: const SizedBox(),
                      value: selectedValue,
                      items: dropdownItems,
                      isExpanded: true,
                      onChanged: (value) async {
                        if (value == "intervalDays") await openEditModal();
                        setState(() {
                          selectedValue = value.toString();
                        });
                      }),
                ),
              ),
              selectedValue == "daysOfWeek"
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MultiselectForm(weekDays, selectedWeekDays,
                                  (val) => {selectedWeekDays = val}, mode),
                            ),
                          ],
                        ),
                      ],
                    )
                  : selectedValue == "everyday"
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 3, left: 5),
                          child: Row(
                            children: [
                              Text("($freqOfDay Giorni di intervallo)",
                                  style: AppTheme.h6Style
                                      .copyWith(color: AppColors.black))
                            ],
                          ),
                        ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text("Quantità",
                          style: AppTheme.h6Style
                              .copyWith(color: AppColors.black))),
                  const SizedBox(
                    width: 35,
                  ),
                  Expanded(
                      child: Text("Durata",
                          style: AppTheme.h6Style
                              .copyWith(color: AppColors.black))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 75,
                                child: TextFormField(
                                  controller: _controllers['qty'],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 5),
                                    prefixIcon: Image.asset(
                                      ic_quantity_pils,
                                      scale: 3.5,
                                    ),
                                    //labelText: 'Pillolee',
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              GestureDetector(
                                onTap: (() {
                                  scrollController.dispose();
                                  scrollController =
                                      FixedExtentScrollController(
                                          initialItem: (indexDrug));
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                            actions: [
                                              buildPickerDrug(),
                                            ],
                                          ));
                                }),
                                child: AutoSizeText(drugItems[(indexDrug)],
                                    minFontSize: 7,
                                    maxFontSize: 15,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: Color.fromARGB(255, 36, 36, 36))
                            ],
                          ))),
                  const SizedBox(width: 32),
                  Expanded(
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 75,
                                child: TextFormField(
                                  controller: _controllers['duration'],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 5),

                                    prefixIcon: Image.asset(
                                      ic_calender,
                                      scale: 3.5,
                                    ),
                                    //labelText: 'Pillolee',
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              GestureDetector(
                                  onTap: () {
                                    scrollController.dispose();
                                    scrollController =
                                        FixedExtentScrollController(
                                            initialItem: (indexItem ?? 0));
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoActionSheet(
                                              actions: [
                                                buildPicker(),
                                              ],
                                            ));
                                  },
                                  child: Text(items[indexItem ?? 0],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))),
                              const Icon(Icons.arrow_drop_down,
                                  color: Color.fromARGB(255, 36, 36, 36))
                            ],
                          )))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "A che Ora",
                      style: AppTheme.h6Style.copyWith(color: AppColors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  Expanded(
                    child: Text(
                      "Data Inizio",
                      style: AppTheme.h6Style.copyWith(color: AppColors.black),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25))),
                      child: TextFormField(
                        keyboardType: TextInputType.none,
                        cursorHeight: 0,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 12, 10, 5),
                          prefixIcon: Image.asset(
                            ic_alram,
                            scale: 3,
                          ),
                          hintText: getTimeText(),
                          hintStyle: const TextStyle(
                              color: Colors.black, fontSize: 17),
                        ),
                        onTap: () {
                          showTimePickerForTherapy();
                        },
                        onSaved: (String? val) {
                          selectedTime = val as TimeOfDay;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25))),
                      child: TextFormField(
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 12, 10, 5),
                          prefixIcon: Image.asset(
                            ic_calender,
                            scale: 3.5,
                          ),
                          hintText: getTextDate(),
                          hintStyle: const TextStyle(
                              color: Colors.black, fontSize: 17),
                          labelStyle: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          selectDate(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(translate(context, "WHEN_TO_TAKE"),
                  style: AppTheme.h6Style.copyWith(color: AppColors.black)),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        whentotake = translate(context, "Before_meals");
                      });
                    },
                    child: Container(
                      width: 28.0.w,
                      decoration: BoxDecoration(
                        color: whentotake == translate(context, "Before_meals")
                            ? ref.read(flavorProvider).primary
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(ic_before_meals,
                                height: 8.0.h,
                                color: whentotake ==
                                        translate(context, "Before_meals")
                                    ? Colors.white
                                    : Colors.black),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              translate(context, "Before_meals"),
                              textAlign: TextAlign.center,
                              style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0.sp,
                                  color: whentotake ==
                                          translate(context, "Before_meals")
                                      ? Colors.white
                                      : Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        whentotake = translate(context, "During_meals");
                      });
                    },
                    child: Container(
                      width: 28.0.w,
                      decoration: BoxDecoration(
                        color: whentotake == translate(context, "During_meals")
                            ? ref.read(flavorProvider).primary
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(ic_during_meals,
                                height: 8.0.h,
                                color: whentotake ==
                                        translate(context, "During_meals")
                                    ? Colors.white
                                    : Colors.black),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              translate(context, "During_meals"),
                              textAlign: TextAlign.center,
                              style: AppTheme.bodyText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0.sp,
                                  color: whentotake ==
                                          translate(context, "During_meals")
                                      ? Colors.white
                                      : Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        whentotake = translate(context, "After_meals");
                      });
                    },
                    child: Container(
                      width: 28.0.w,
                      decoration: BoxDecoration(
                        color: whentotake == translate(context, "After_meals")
                            ? ref.read(flavorProvider).primary
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              ic_after_meals,
                              height: 8.0.h,
                              color: whentotake ==
                                      translate(context, "After_meals")
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                                width: 15.0.w,
                                child: Text(
                                  translate(context, "After_meals"),
                                  textAlign: TextAlign.center,
                                  style: AppTheme.bodyText.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0.sp,
                                    color: whentotake ==
                                            translate(context, "After_meals")
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    Text("Indicazioni o note",
                        style:
                            AppTheme.h6Style.copyWith(color: AppColors.black))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextField(
                  controller: _controllers['note'],
                  decoration: Constant.borderTextFieldDecoration(
                          ref.read(flavorProvider).lightPrimary)
                      .copyWith(
                    hintText: translate(
                      context,
                      'INDICATIONS_NOTES_des',
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
