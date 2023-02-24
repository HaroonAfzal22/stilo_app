import 'package:auto_size_text/auto_size_text.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/dialogs/custom_dialog.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/therapies/multiselect_form.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/create_therapy_third_screen.dart';
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

class CreateTherapySecondScreen extends ConsumerStatefulWidget {
  const CreateTherapySecondScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/create-therapy-second-screen';

  @override
  _CreateTherapySecondScreenState createState() =>
      _CreateTherapySecondScreenState();
}

class _CreateTherapySecondScreenState
    extends ConsumerState<CreateTherapySecondScreen> {
  int? productId;
  final Map<String, dynamic> _controllers = {
    'name': TextEditingController(),
    'qty': TextEditingController(),
    'duration': TextEditingController(),
    'whenTake': TextEditingController(),
    'note': TextEditingController(),
    'time': TextEditingController(),
    'date': TextEditingController(),
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
          child: Text(
            translate(context, 'Every Day'),
          ),
          value: "everyday"),
      DropdownMenuItem(
          child: Text(
            translate(context, 'Days of the week'),
          ),
          value: "daysOfWeek"),
      DropdownMenuItem(
          child: Text(
            translate(context, 'Days of Interval'),
          ),
          value: "intervalDays"),
    ];
    return menuItems;
  }

  int indexDrugUnit = 0;
  int indexItem = 0;
  late FixedExtentScrollController scrollController;
  var durationUnit = [
    "giorni",
    "mesi",
  ];

  int durationUnitIndex = 0;

  var drugUnit = [
    "Pillole",
    "Bustine",
    "Ml",
  ];

  List weekDays = [
    {"id": 0, "name": "Lun"},
    {"id": 1, "name": "Mar"},
    {"id": 2, "name": "Mer"},
    {"id": 3, "name": "Gio"},
    {"id": 4, "name": "Ven"},
    {"id": 5, "name": "Sab"},
    {"id": 6, "name": "Dom"},
  ];
  List selectedWeekDays = [];
  String mode = "add";
  final TextEditingController _controller = TextEditingController();
  String selectedValue = 'everyday'; //medicine_frequency
  // String frequency_value
  // String selectedValue = "daysOfweek";
  //String freqValue = "0-2-4";
  //String selectedValue = "interval";
  //String freqValue "8";
  String whentotake = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay time = TimeOfDay.now();
  DateTime? date;
  int freqOfDay = 0;

  Future<void> showTimePickerForTherapy() async {
    final result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (result != null) {
      setState(() {
        time = result;
        _controllers['time'].text = result.format(context);
      });
    }
  }

  String getTimeText() {
    return time.format(context);
  }

  DateTime currentDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        final String formatted = formatter.format(currentDate);
        _controllers['date'].text = formatted;
      });
    }
  }

  String getTextDate() {
    return "${currentDate.day}/${currentDate.month}/${currentDate.year}";
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
          children: durationUnit
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
          children: drugUnit
              .map((items) => Center(
                    child: Text(items, style: const TextStyle(fontSize: 17)),
                  ))
              .toList(),
          onSelectedItemChanged: (index) {
            // //  setState(() =>
            // indexDrug = index;
            // print(indexDrug);
            setState(() {
              indexDrugUnit = index;
              final drugsItems = drugUnit[indexDrugUnit];
            });
          },
        ),
      );

  @override
  void initState() {
    super.initState();
    scrollController = FixedExtentScrollController(initialItem: 0);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final Map<String, dynamic> productArg =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      _controllers['name'].text = productArg['product_name'];
      productId = productArg['product_id'];
      _controllers['time'].text = getTimeText();
      _controllers['date'].text = getTextDate();
      setState(() {});
    });
  }

  String getFrequencyValue() {
    switch (selectedValue) {
      case "everyday":
        return "";
      case "daysOfWeek":
        String x = "";
        for (int i = 0; i < selectedWeekDays.length; i++) {
          if (i != selectedWeekDays.length - 1) {
            x = x + selectedWeekDays[i].toString() + '-';
          } else {
            x = x + selectedWeekDays[i].toString();
          }
        }
        return x;
      default:
        return freqOfDay.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        persistentFooterButtons: [
          InkWell(
            onTap: () {
              if (validation()) {
                Navigator.of(context).pushNamed(
                    CreateTherapyThirdScreen.routeName,
                    arguments: <String, dynamic>{
                      "product": _controllers['name'].text,
                      "product_id": productId,
                      "medicine_fequency": selectedValue,
                      "frequency_value": getFrequencyValue(),
                      "qty": _controllers['qty'].text,
                      "qty_unit": drugUnit[indexDrugUnit],
                      "duration": _controllers['duration'].text,
                      "duration_unit": durationUnit[indexItem],
                      "as_what_time": time.format(context),
                      "start_date": currentDate,
                      "when_take": whentotake,
                      "note": _controllers['note'].text,
                    });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: ref.read(flavorProvider).lightPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              width: double.infinity,
              height: 64,
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
            translate(context, 'Therapy_insertion'),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate(context, "2/3"),
                    style: AppTheme.h6Style.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ref.read(flavorProvider).primary)),
                Text(translate(context, "Therapy_insertion"),
                    style:
                        AppTheme.h6Style.copyWith(fontWeight: FontWeight.w600)),
                Text(translate(context, "Therapy_insertion_des"),
                    style: AppTheme.bodyText.copyWith(
                        color: AppColors.lightGrey, fontSize: 10.0.sp)),
                const SizedBox(height: 32),
                // Text(translate(context, "PRODUCT_MEDICINE"),
                //     style: AppTheme.h6Style.copyWith(color: AppColors.black)),
                // const SizedBox(
                //   height: 5,
                // ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controllers['name'],
                        enabled: false,
                        decoration: InputDecoration(
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Image.asset(ic_primary_pils, height: 16),
                          ),
                          filled: true,
                          labelText: translate(context, "PRODUCT_MEDICINE"),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(),
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
                                  'Non puoi modificare il farmaco in questa sezione. Prova a tornare indietro.'),
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
                // Row(children: [
                //   Text(
                //     "Scegli una frequenza",
                //     style: AppTheme.h6Style.copyWith(color: AppColors.black),
                //   )
                // ]),
                // const SizedBox(
                //   height: 4,
                // ),
                DropdownButtonFormField(
                    value: selectedValue,
                    items: dropdownItems,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      // prefix: Padding(
                      //   padding: const EdgeInsets.only(right: 16),
                      //   child: Image.asset(ic_primary_pils, height: 16),
                      // ),
                      filled: true,
                      labelText: "Scegli una frequenza",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                    onChanged: (value) async {
                      if (value == "intervalDays") await openEditModal();
                      setState(() {
                        selectedValue = value.toString();
                      });
                    }),
                selectedValue == "daysOfWeek"
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MultiselectForm(
                                    weekDays,
                                    selectedWeekDays,
                                    (val) => {selectedWeekDays = val},
                                    mode),
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
                // Row(
                //   children: [
                //     Expanded(
                //         child: Text("Quantità",
                //             style: AppTheme.h6Style
                //                 .copyWith(color: AppColors.black))),
                //     const SizedBox(
                //       width: 35,
                //     ),
                //     Expanded(
                //         child: Text("Durata",
                //             style: AppTheme.h6Style
                //                 .copyWith(color: AppColors.black))),
                //   ],
                // ),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _controllers['qty'],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Quantità',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // prefix: Row(
                        //   children: [
                        //     Image.asset(
                        //       ic_quantity_pils,
                        //       height: 16,
                        //     ),
                        //     const SizedBox(width: 16),
                        //   ],
                        // ),
                        suffixIcon: SizedBox(
                          width: 75,
                          child: GestureDetector(
                            onTap: (() {
                              scrollController.dispose();
                              scrollController = FixedExtentScrollController(
                                  initialItem: (indexDrugUnit));
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoActionSheet(
                                        actions: [
                                          buildPickerDrug(),
                                        ],
                                      ));
                            }),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AutoSizeText(drugUnit[(indexDrugUnit)],
                                      minFontSize: 7,
                                      maxFontSize: 15,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        labelStyle: const TextStyle(color: Colors.black54),
                      ),
                    )),
                    const SizedBox(width: 32),
                    Expanded(
                        child: TextFormField(
                      controller: _controllers['duration'],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Durata',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // prefix: Row(
                        //   children: [
                        //     Image.asset(
                        //       ic_quantity_pils,
                        //       height: 16,
                        //     ),
                        //     const SizedBox(width: 16),
                        //   ],
                        // ),
                        suffixIcon: SizedBox(
                          width: 75,
                          child: GestureDetector(
                            onTap: (() {
                              scrollController.dispose();
                              scrollController = FixedExtentScrollController(
                                  initialItem: (indexItem));
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoActionSheet(
                                        actions: [
                                          buildPicker(),
                                        ],
                                      ));
                            }),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AutoSizeText(durationUnit[indexItem],
                                      minFontSize: 7,
                                      maxFontSize: 15,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        labelStyle: const TextStyle(color: Colors.black54),
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //         child: Text("A che Ora",
                //             style: AppTheme.h6Style
                //                 .copyWith(color: AppColors.black))),
                //     const SizedBox(
                //       width: 35,
                //     ),
                //     Expanded(
                //         child: Text("Data Inizio",
                //             style: AppTheme.h6Style
                //                 .copyWith(color: AppColors.black))),
                //   ],
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _controllers['time'],
                            keyboardType: TextInputType.none,
                            decoration: const InputDecoration(
                              prefix: SizedBox(width: 32),
                              labelText: "A che Ora",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onTap: () {
                              showTimePickerForTherapy();
                            },
                            onSaved: (String? val) {
                              selectedTime = val as TimeOfDay;
                            },
                          ),
                          Positioned(
                            left: 8,
                            top: 14,
                            child: Image.asset(
                              ic_alram,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _controllers['date'],
                            keyboardType: TextInputType.none,
                            decoration: const InputDecoration(
                              prefix: SizedBox(width: 32),
                              labelText: "Data Inizio",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onTap: () {
                              selectDate(context);
                            },
                          ),
                          Positioned(
                            left: 8,
                            top: 14,
                            child: Image.asset(
                              ic_calender,
                              height: 24,
                            ),
                          ),
                        ],
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
                          color:
                              whentotake == translate(context, "Before_meals")
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
                          color:
                              whentotake == translate(context, "During_meals")
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
                                ),
                              )
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
      ),
    );
  }
}
