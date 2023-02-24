import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;

import 'package:contacta_pharmacy/ui/custom_widgets/edit_text_without_icon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';
import '../../custom_widgets/Temprature_management.dart';
import '../../custom_widgets/no_user.dart';

class HealthFolderValuesTab extends ConsumerStatefulWidget {
  static String routeName = "/MyValues";

  const HealthFolderValuesTab({Key? key}) : super(key: key);

  @override
  _HealthFolderValuesTabState createState() => _HealthFolderValuesTabState();
}

class _HealthFolderValuesTabState extends ConsumerState<HealthFolderValuesTab> {
  bool loading = false;
  bool bottomloading = false;
  TextEditingController controller_temperature = TextEditingController();
  DateTime selectedDate = DateTime.now();
  // TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTime = TimeOfDay.now();
  final weightcontroller = TextEditingController();
  final additionalnotecontroller = TextEditingController();
  final glycemiacontroller = TextEditingController();
  final maxpressurecontroller = TextEditingController();
  final minpressurecontroller = TextEditingController();
  final bpmcontroller = TextEditingController();
  final cholestrolcontroller = TextEditingController();
  final lipidprofile1controller = TextEditingController();
  final lipidprofile2controller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime currentDate = DateTime.now();
  late String hour, _minute, time;
  late String changeTime;

  //final bpmcontroller =TextEditingController();

  var chartData = {};
  var weightdatalist = [];
  var weightdatalistY = [];
  var glycemiadatalist = [];
  var glycemiadatalistY = [];
  var pressuredatalist = [];
  var minpressuredatalist = [];
  var maxpressuredatalist = [];
  var pressuredatalistY = [];
  var temreturedatalist = [];
  var temreturedatalistY = [];
  var colestordatalist = [];
  var colestordatalistY = [];
  var lipidprofile1datalist = [];
  var lipidprofile1datalistY = [];
  var lipidprofile2datalist = [];
  var lipidprofile2datalistY = [];

  final FocusNode _nodetemretur = FocusNode();
  final FocusNode _node_height = FocusNode();
  final FocusNode _node_weigth = FocusNode();
  final FocusNode _node_smoker = FocusNode();
  final FocusNode _node_physical_activity = FocusNode();
  final FocusNode _node__children = FocusNode();
  final FocusNode _node__hypertension = FocusNode();
  final FocusNode node_diabetes = FocusNode();
  final FocusNode node__allergies = FocusNode();
  final FocusNode node__food_intolerence = FocusNode();
  final FocusNode node__additional_comments = FocusNode();
  bool add = false;

  String salesData = "";
  var overlayEntry;
  List<TimeSeriesSales> weightdatalistGraph = [];
  List<TimeSeriesSales> glycemiadatalistGraph = [];
  List<TimeSeriesSales> pressuredatalistGraph = [];
  List<TimeSeriesSales> temreturedatalistGraph = [];
  List<TimeSeriesSales> colestroldatalistGraph = [];
  List<TimeSeriesSales> lipidprofile1listGraph = [];
  List<TimeSeriesSales> lipidprofile2listGraph = [];

  @override
  void initState() {
    super.initState();
    fetchChartData();
    if (Platform.isIOS) {
      // iOS-specific code
      //TODO refactor
      /*   KeyboardVisibilityNotification().addNewListener(onShow: () {
        showOverlay(context);
      }, onHide: () {
        removeOverlay();
      });*/

      _nodetemretur.addListener(() {
        bool hasFocus = _nodetemretur.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
      _node_height.addListener(() {
        bool hasFocus = _node_height.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
      _node_weigth.addListener(() {
        bool hasFocus = _node_weigth.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
      _node_weigth.addListener(() {
        bool hasFocus = _node_weigth.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
      _node_weigth.addListener(() {
        bool hasFocus = _node_weigth.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: const InputDoneView());
    });

    overlayState?.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  Widget _listOfValue() {
    return Container(
      color: AppColors.darkGrey.withOpacity(.1),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Text(
                  //controller_fname.text,
                  translate(context, "lis_of_values"),
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.h6Style.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  translate(context, "lis_of_values_des"),
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodyText
                      .copyWith(color: AppColors.black, fontSize: 10.0.sp),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      controller_temperature.clear();
                      weightcontroller.clear();
                      additionalnotecontroller.clear();
                      glycemiacontroller.clear();
                      maxpressurecontroller.clear();
                      minpressurecontroller.clear();
                      bpmcontroller.clear();
                      cholestrolcontroller.clear();
                      lipidprofile1controller.clear();
                      lipidprofile2controller.clear();
                      _dateController.text =
                          DateFormat('dd/MM/yyyy').format(DateTime.now());
                      _timeController.text =
                          DateFormat('HH:mm').format(DateTime.now());
                    });

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      builder: (context) => SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    translate(
                                        context, "Choose_the_type_measurement"),
                                    style: AppTheme.h6Style
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Text(
                                    translate(context,
                                        "Choose_the_type_measurement_des"),
                                    style: AppTheme.bodyText.copyWith(
                                        color: AppColors.lightGrey,
                                        fontSize: 10.0.sp))
                              ],
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 20),
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.darkGrey
                                              .withOpacity(.1),
                                          spreadRadius: 5,
                                          blurRadius: 7)
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _dateController.text =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(DateTime.now());
                                            _timeController.text =
                                                DateFormat('kk:mm')
                                                    .format(DateTime.now());
                                          });
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                  child: tempraturebottomsheet(
                                                      context)),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        translate(context,
                                                            "TEMPERATURE"),
                                                        style: AppTheme.bodyText
                                                            .copyWith(
                                                                color: ref
                                                                    .read(
                                                                        flavorProvider)
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                      const Divider(),
                                      // Image.asset('assets/icons/line.png',width: 294,),
                                      InkWell(
                                        onTap: () {
                                          _dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now());
                                          _timeController.text =
                                              DateFormat('kk:mm')
                                                  .format(DateTime.now());
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                  child: weightbottomsheet()),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        translate(
                                                            context, "WEIGHT"),
                                                        style: AppTheme.bodyText
                                                            .copyWith(
                                                                color: ref
                                                                    .read(
                                                                        flavorProvider)
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          _dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now());
                                          _timeController.text =
                                              DateFormat('kk:mm')
                                                  .format(DateTime.now());
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                  child: glycimiabottomsheet()),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        translate(context,
                                                            "GLICEMIA"),
                                                        style: AppTheme
                                                            .bodyText
                                                            .copyWith(
                                                                color: ref
                                                                    .read(
                                                                        flavorProvider)
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          _dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now());
                                          _timeController.text =
                                              DateFormat('kk:mm')
                                                  .format(DateTime.now());
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                  child: pressurebottmsheet()),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      translate(
                                                          context, "PRESSURE"),
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              color: ref
                                                                  .read(
                                                                      flavorProvider)
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          _dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now());
                                          _timeController.text =
                                              DateFormat('kk:mm')
                                                  .format(DateTime.now());
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                  child:
                                                      cholesterolbottomsheet()),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        translate(context,
                                                            "CHOLESTROL"),
                                                        style: AppTheme.bodyText
                                                            .copyWith(
                                                                color: ref
                                                                    .read(
                                                                        flavorProvider)
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          _dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now());
                                          _timeController.text =
                                              DateFormat('kk:mm')
                                                  .format(DateTime.now());
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                  child:
                                                      lipidprofile_1bottomsheet()),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 80.0.w,
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      translate(context,
                                                          "lipid_profile"),
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              color: ref
                                                                  .read(
                                                                      flavorProvider)
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          _dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now());
                                          _timeController.text =
                                              DateFormat('kk:mm')
                                                  .format(DateTime.now());
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            builder: (context) =>
                                                SingleChildScrollView(
                                              child: Container(
                                                  child:
                                                      lipidprofile_2bottomsheet()),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 80.0.w,
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 5),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      translate(context,
                                                          "lipid_profile2"),
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              color: ref
                                                                  .read(
                                                                      flavorProvider)
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                      // Divider(),
                                    ],
                                  ),
                                ),
                              )),
                          Container(
                            height: 8.0.h,
                            decoration: BoxDecoration(
                                color: ref.read(flavorProvider).lightPrimary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                )),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: InkWell(
                              onTap: () {
                                showredToast(
                                    translate(context, "Please select one"),
                                    context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(translate(context, "keep_it_going"),
                                      style: AppTheme.subTitleStyle.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    );
                  },
                  child: Image.asset(ic_addnew_item, height: 40))),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, setState) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        log(_dateController.text, name: "Change date");
        log(pickedDate.toString(), name: "Change date");
      });
    }
  }

  Future<void> _selectTime(BuildContext context, setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        time = hour + ' : ' + _minute;
        _timeController.text =
            "${hour.toString().length == 1 ? "0" : ""}$hour:${_minute.toString().length == 1 ? "0" : ""}$_minute";
        changeTime = "${selectedTime.hour}:${selectedTime.minute}:00 ";
        log(changeTime, name: "Change Time");
      });
    }
  }

  Widget dateTimeWidget(setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate(context, "Date"),
                style: AppTheme.h6Style.copyWith(color: AppColors.darkGrey),
              ),
              Text(
                  translate(
                    context,
                    "Now",
                  ),
                  style: AppTheme.h6Style.copyWith(color: AppColors.lightGrey)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _selectDate(context, setState);
                },
                child: SizedBox(
                  width: 36.0.w,
                  height: 2.0.h,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                    ),
                    style: AppTheme.h5Style.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 13.0.sp),
                    textAlign: TextAlign.left,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _dateController,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _selectTime(context, setState);
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  width: 42.0.w,
                  height: 2.0.h,
                  child: TextFormField(
                    style: AppTheme.h5Style.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 13.0.sp),
                    textAlign: TextAlign.end,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Divider(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget tempraturebottomsheet(contex) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO reactivate ShimmerLoader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 2.0.h,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(translate(context, "insert_details"),
                              style: AppTheme.h6Style.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold)),
                          Text(" ${translate(context, "Temprature")}",
                              style: AppTheme.h6Style
                                  .copyWith(fontWeight: FontWeight.w600))
                        ],
                      ),
                      Text(translate(context, "enter_weight_detail_des"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey, fontSize: 10.0.sp))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: EditTextWithoutIcon(
                    onchangtext: '',
                    controller: controller_temperature,
                    label: translate(context, "TEMPERATURE"),
                    onchange: (change) {},
                  ),
                ),
                dateTimeWidget(setState),
                _additionalbox(),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, TemperatureMeasurement.routeName);
                  },
                  child: Container(
                    height: 8.0.h,
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        if (controller_temperature.text.isEmpty) {
                          showredToast(
                              translate(context, "enter_tempratue"), context);
                          return;
                        } else if (!controller_temperature.text
                            .contains(RegExp(r'[0-9]'))) {
                          showredToast(
                              translate(context, "enter_tempratue"), context);
                        } else if (_dateController.text.isEmpty &&
                            _timeController.text.isEmpty) {
                          showredToast(
                              translate(context, "enter_date_time"), context);
                        } else {
                          addHealthChartData(
                              "temperature", controller_temperature.text);

                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(translate(context, "save_insert"),
                              style: AppTheme.subTitleStyle.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget pressurebottmsheet() {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO reactivate ShimmerLoader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 2.0.h,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, "Enter_details_Pressure"),
                          style: AppTheme.h6Style
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(translate(context, "enter_weight_detail_des"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey, fontSize: 10.0.sp))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchangtext: '',
                    onchange: (change) {},
                    label: translate(context, "MAX_PRESSURE"),
                    textInputType: TextInputType.number,
                    controller: maxpressurecontroller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchange: (change) {},
                    onchangtext: '',
                    label: translate(context, "MINIMUM_PRESSURE"),
                    textInputType: TextInputType.number,
                    controller: minpressurecontroller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchangtext: '',
                    onchange: (change) {},
                    label: translate(context, "BPM"),
                    textInputType: TextInputType.number,
                    controller: bpmcontroller,
                  ),
                ),
                dateTimeWidget(setState),
                _additionalbox(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 8.0.h,
                  decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      if (maxpressurecontroller.text.isEmpty) {
                        showredToast(
                            translate(context, "err_maxpressure"), context);
                        return;
                      } else if (minpressurecontroller.text.isEmpty) {
                        showredToast(
                            translate(context, "err_minpressure"), context);
                        return;
                      } else if (bpmcontroller.text.isEmpty) {
                        showredToast(translate(context, "err_bpm"), context);
                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        addHealthChartData("pressure", 0,
                            bpm: bpmcontroller.text,
                            max_pressure: maxpressurecontroller.text,
                            min_pressure: minpressurecontroller.text);
                      }

                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate(context, "save_insert"),
                            style: AppTheme.subTitleStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget glycimiabottomsheet() {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO reactivate ShimmerLOADER
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 2.0.h,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, "enter_blood_sugar"),
                          style: AppTheme.h6Style
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(translate(context, "enter_weight_detail_des"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey, fontSize: 10.0.sp))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchange: (change) {},
                    onchangtext: '',
                    label: translate(context, "GLICEMIA"),
                    controller: glycemiacontroller,
                    textInputType: TextInputType.number,
                  ),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                _additionalbox(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 8.0.h,
                  decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      if (glycemiacontroller.text.isEmpty) {
                        showredToast(
                            translate(context, "err_glycemia"), context);
                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        addHealthChartData("glycemia", glycemiacontroller.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate(context, "save_insert"),
                            style: AppTheme.subTitleStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget weightbottomsheet() {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO reactivate shimmerLoader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 2.0.h,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, "enter_weight_detail"),
                          style: AppTheme.h6Style
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(translate(context, "enter_weight_detail_des"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey, fontSize: 10.0.sp))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchangtext: '',
                    onchange: (change) {},
                    label: translate(context, "WEIGHT"),
                    controller: weightcontroller,
                    textInputType: TextInputType.number,
                  ),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                _additionalbox(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 8.0.h,
                  decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      if (weightcontroller.text.isEmpty) {
                        showredToast(translate(context, "err_weight"), context);
                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        addHealthChartData("weight", weightcontroller.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate(context, "save_insert"),
                            style: AppTheme.subTitleStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget cholesterolbottomsheet() {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO reactivate shimmerLoader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 2.0.h,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, "enter_cholestrol_detail"),
                          style: AppTheme.h6Style
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(translate(context, "enter_cholestrol_detail_des"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey, fontSize: 10.0.sp))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchange: (change) {},
                    onchangtext: '',
                    label: translate(context, "CHOLESTEROL"),
                    controller: cholestrolcontroller,
                    textInputType: TextInputType.number,
                  ),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                _additionalbox(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 8.0.h,
                  decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      if (cholestrolcontroller.text.isEmpty) {
                        showredToast(
                            translate(context, "err_cholestrol"), context);
                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        addHealthChartData(
                            "cholestrol", cholestrolcontroller.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate(context, "save_insert"),
                            style: AppTheme.subTitleStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget lipidprofile_1bottomsheet() {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO Replace shimmerLoader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 2.0.h,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, "enter_lipidprofile_detail_1"),
                          style: AppTheme.h6Style
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(translate(context, "enter_lipidprofile_detail_des"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey, fontSize: 10.0.sp))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchangtext: '',
                    onchange: (change) {},
                    label: translate(context, "lipid_profile_CAP"),
                    controller: lipidprofile1controller,
                    textInputType: TextInputType.number,
                  ),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                _additionalbox(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 8.0.h,
                  decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      if (lipidprofile1controller.text.isEmpty) {
                        showredToast(
                            translate(context, "err_lipidprofile"), context);
                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        addHealthChartData(
                            "lipid_profile", lipidprofile1controller.text);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate(context, "save_insert"),
                            style: AppTheme.subTitleStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget lipidprofile_2bottomsheet() {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO shimmerLoader
          ? SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 2.0.h,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, "enter_lipidprofile_detail_2"),
                          style: AppTheme.h6Style
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(translate(context, "enter_lipidprofile_detail_des"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey, fontSize: 10.0.sp))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: EditTextWithoutIcon(
                    onchange: (change) {},
                    onchangtext: '',
                    label: translate(context, "lipid_profile_CAP"),
                    controller: lipidprofile2controller,
                    textInputType: TextInputType.text,
                  ),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                _additionalbox(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 8.0.h,
                  decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      if (lipidprofile2controller.text.isEmpty) {
                        showredToast(
                            translate(context, "err_lipidprofile"), context);
                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        addHealthChartData(
                            "lipid_profile2", lipidprofile2controller.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate(context, "save_insert"),
                            style: AppTheme.subTitleStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget _additionalbox() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        // alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(translate(context, "add_notes_health"),
                      style: AppTheme.h2Style.copyWith(
                          color: AppColors.darkGrey, fontSize: 13.0.sp)),
                ],
              ),
            ),
            SizedBox(
              height: 12.0.h,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(width: 1, color: AppColors.grey)),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: TextFormField(
                                controller: additionalnotecontroller,
                                cursorColor: AppColors.black,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  hintText: translate(
                                      context, "add_notes_health_hint"),
                                ) /*'Enter any notes regarding the recipe or preferences ..'*/,
                                maxLines: 2,
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget weightLinegraph() {
    return Container(
      //height: 50.0.h,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: AppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 64.0),
                child: Text(
                  translate(context, "Weight_Measurement"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 2,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TemperatureMeasurement(
                              weightdatalist,
                              translate(context, "WEIGHT"),
                              "kg",
                              "weight"))).then((value) {
                    fetchChartData();
                  });
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //   ),
                  //   builder: (context) => SingleChildScrollView(
                  //     child: Container(child: weightbottomsheet()),
                  //   ),
                  // );
                },
                child: Text(
                  translate(context, "Weight_in_kg"),
                  style: const TextStyle(color: AppColors.white),
                ),
              )
            ],
          ),
          InkWell(
              onTap: () {
                //Navigator.pushNamed(context, TemperatureMeasurement.routeName);

                // Navigator.push(context,TemperatureMeasurement.routeName );
              },
              // child: SizedBox(
              //   height: 140,
              //   child: LineGraph(
              //     features: [
              //       Feature(
              //         //title: "Flutter",
              //         color: Colors.amber,
              //         data: weightdatalist
              //             .map((e) => double.parse(e['value'].toString()) / 100 >1 ?2.0:  double.parse(e['value'].toString()) / 100)
              //             .toList(),
              //         //data:[20,60,80,90,110],
              //         //data: weightdatalist.map((e) => e['value'].toString()).toList(),
              //       )
              //     ],
              //     size: Size(300, 250),
              //     labelX: weightdatalist
              //         .map((e) => DateFormat('MM-dd').format(
              //             DateFormat('yyyy-MM-dd hh:mm:ss')
              //                 .parse(e['date'] ?? "2021-06-24 12:00:00")))
              //         .toList(),
              //     labelY:
              //         weightdatalistY.map((e) => e.toString()).toSet().toList(),
              //     graphColor: Colors.black87,
              //   ),
              // ),

              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                child: weightdatalist.isEmpty
                    ? Center(child: Text(translate(context, "please_add_data")))
                    : graph(weightdatalistGraph, translate(context, "WEIGHT"),
                        Colors.amber),
              )),
          /**/
          /*SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget glicimiaLinegraph() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "glycemia"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 2,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureMeasurement(
                                glycemiadatalist,
                                translate(context, "glycemia"),
                                "mg",
                                'glycemia'))).then((value) {
                      fetchChartData();
                    });
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   builder: (context) => SingleChildScrollView(
                    //     child: Container(child: glycimiabottomsheet()),
                    //   ),
                    // );
                  },
                  child: Text(
                    translate(context, "glycemia"),
                    style: const TextStyle(color: AppColors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                //Navigator.pushNamed(context, TemperatureMeasurement.routeName);

                // Navigator.push(context,TemperatureMeasurement.routeName );
              },
              // child: SizedBox(
              //   height: 140,
              //   child: LineGraph(
              //     features: [
              //       Feature(
              //         //title: "Flutter",
              //         color: Colors.deepPurpleAccent,
              //         data:glycemiadatalist
              //             .map((e) => double.parse(e['value'].toString()) / 100 >1 ?2.0:  double.parse(e['value'].toString()) / 100)
              //             .toList(),
              //       )
              //     ],
              //     size: Size(300, 250),
              //     labelX: glycemiadatalist
              //         .map((e) => DateFormat('MM-dd').format(
              //             DateFormat('yyyy-MM-dd hh:mm:ss')
              //                 .parse(e['date'] ?? "2021-06-24 12:00:00")))
              //         .toList(),
              //     labelY:
              //         glycemiadatalistY.map((e) => e.toString()).toSet().toList(),
              //     graphColor: Colors.black87,
              //   ),
              // ),

              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                child: glycemiadatalist.isEmpty
                    ? Center(child: Text(translate(context, "please_add_data")))
                    : graph(
                        glycemiadatalistGraph,
                        translate(context, "glycemia"),
                        Colors.deepPurpleAccent),
              )),
          /*SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget pressureLinegraph() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "pressure"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 2,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.lightGreen,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureMeasurement(
                                pressuredatalist,
                                translate(context, "pressure"),
                                "mmHg",
                                "pressure",
                                minPres: minpressuredatalist,
                                maxPres: maxpressuredatalist))).then((value) {
                      fetchChartData();
                    });
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   builder: (context) => SingleChildScrollView(
                    //     child: Container(child: pressurebottmsheet()),
                    //   ),
                    // );
                  },
                  child: Text(
                    translate(context, "BPM"),
                    style: const TextStyle(color: AppColors.white),
                  ),
                )
              ],
            ),
          ),
          InkWell(
              onTap: () {
                //Navigator.pushNamed(context, TemperatureMeasurement.routeName);
                // Navigator.push(context,TemperatureMeasurement.routeName );
              },
              // child: SizedBox(
              //   height: 140,
              //   child: LineGraph(
              //     features: [
              //       Feature(
              //           //title: "Flutter",
              //           color:Colors.lightGreen,
              //           data: pressuredatalist
              //               .map((e) => double.parse(e['value'].toString()) / 100 >1 ?2.0:  double.parse(e['value'].toString()) / 100)
              //               .toList(),  )
              //     ],
              //     size: Size(300, 50),
              //     labelX: pressuredatalist
              //         .map((e) => DateFormat('MM-dd').format(
              //             DateFormat('yyyy-MM-dd hh:mm:ss')
              //                 .parse(e['date'] ?? "2021-06-24 12:00:00")))
              //         .toList(),
              //     labelY:
              //         pressuredatalistY.map((e) => e.toString()).toSet().toList(),
              //     graphColor: Colors.black87,
              //   ),
              // ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  child: pressuredatalist.isEmpty
                      ? Center(
                          child: Text(translate(context, "please_add_data")))
                      : graph(pressuredatalistGraph, translate(context, "BPM"),
                          Colors.lightGreen))),
          /*SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget tempratureLinegraph() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "Temprature"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 2,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureMeasurement(
                                temreturedatalist,
                                translate(context, "Temperature"),
                                "C",
                                "temprature"))).then((value) {
                      fetchChartData();
                    });
                  },
                  child: Text(
                    translate(context, "Temprature"),
                    style: const TextStyle(color: AppColors.white),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              log(temreturedatalistGraph.length.toString());
              //Navigator.pushNamed(context, TemperatureMeasurement.routeName);
              // Navigator.push(context,TemperatureMeasurement.routeName );
            },
            child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                // child: LineGraph(
                //   //size: Size(420, 450),
                //   features: [
                //     Feature(
                //       //title: "Flutter",
                //       color: Colors.blueAccent,
                //       data:temreturedatalist
                //           .map((e) => double.parse(e['value'].toString()) / 100 >1 ?2.0:  double.parse(e['value'].toString()) / 100)
                //           .toList(),
                //       /* data: temreturedatalist
                //           .map((e) => double.parse(e['value'].toString()) / 100>=1?1:/100)
                //           .toList(),*/
                //     )
                //   ],
                //   size: Size(300, 250),
                //   labelX: temreturedatalist
                //       .map((e) => DateFormat('MM-dd').format(
                //           DateFormat('yyyy-MM-dd hh:mm:ss')
                //               .parse(e['date'] ?? "2021-06-24 12:00:00")))
                //       .toList(),
                //   labelY: temreturedatalistY
                //       .map((e) => e.toString())
                //       .toSet()
                //       .toList(),
                //   graphColor: Colors.black87,
                // ),

                child: temreturedatalist.isEmpty
                    ? Center(child: Text(translate(context, "please_add_data")))
                    : graph(temreturedatalistGraph,
                        translate(context, "Temprature"), Colors.blueAccent)),
          ),
          /*SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget colostrolLinegraph() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "CHOLESTROL_small"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 2,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureMeasurement(
                                colestordatalist,
                                translate(context, "CHOLESTROL_small"),
                                "",
                                "cholestrol"))).then((value) {
                      fetchChartData();
                    });
                  },
                  child: Text(
                    translate(context, "CHOLESTROL_small"),
                    style: const TextStyle(color: AppColors.white),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              log(colestroldatalistGraph.length.toString());
              //Navigator.pushNamed(context, TemperatureMeasurement.routeName);
              // Navigator.push(context,TemperatureMeasurement.routeName );
            },
            child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: colestordatalist.isEmpty
                    ? Center(child: Text(translate(context, "please_add_data")))
                    : graph(
                        colestroldatalistGraph,
                        translate(context, "CHOLESTROL_small"),
                        Colors.redAccent)),
          ),
          /*SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget lipidprofile1Linegraph() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "lipid_profile_small"),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 2,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.greenAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureMeasurement(
                                lipidprofile1datalist,
                                translate(context, "lipid_profile_small"),
                                "",
                                "lipid_profile"))).then((value) {
                      fetchChartData();
                    });
                  },
                  child: Text(
                    translate(context, "lipid_profile_small"),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              log(lipidprofile1listGraph.length.toString());
              //Navigator.pushNamed(context, TemperatureMeasurement.routeName);
              // Navigator.push(context,TemperatureMeasurement.routeName );
            },
            child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: lipidprofile1datalist.isEmpty
                    ? Center(child: Text(translate(context, "please_add_data")))
                    : graph(
                        lipidprofile1listGraph,
                        translate(context, "lipid_profile_small"),
                        Colors.greenAccent)),
          ),
          /*SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget lipidprofile2Linegraph() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    translate(context, "lipid_profile2_small"),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      //letterSpacing: 2,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureMeasurement(
                                lipidprofile2datalist,
                                translate(context, "lipid_profile2_small"),
                                "",
                                "lipid_profile2"))).then((value) {
                      fetchChartData();
                    });
                  },
                  child: Text(
                    translate(context, "lipid_profile2_small"),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              log(lipidprofile2listGraph.length.toString());
              //Navigator.pushNamed(context, TemperatureMeasurement.routeName);
              // Navigator.push(context,TemperatureMeasurement.routeName );
            },
            child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.9,
                child: lipidprofile2datalist.isEmpty
                    ? Center(child: Text(translate(context, "please_add_data")))
                    : graph(
                        lipidprofile2listGraph,
                        translate(context, "lipid_profile2_small"),
                        Colors.orangeAccent)),
          ),
          /*SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget graph(data, name, color) {
    print(data);
    return SfCartesianChart(
        isTransposed: false,
        primaryXAxis: CategoryAxis(
            axisLine: const AxisLine(width: 0),
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0)),
        enableAxisAnimation: false,

        // Chart title
        // Enable legend
        legend: Legend(isVisible: false),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<TimeSeriesSales, String>>[
          SplineAreaSeries<TimeSeriesSales, String>(
            dataSource: data,
            enableTooltip: true,
            markerSettings: const MarkerSettings(isVisible: true),
            color: color,
            opacity: 0.8,
            name: "$name",
            xValueMapper: (TimeSeriesSales sales, _) => sales.time,
            yValueMapper: (TimeSeriesSales sales, _) => sales.sales,
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: loading
              //TODO customloader
              ? const SizedBox()
              : user == null
                  ? const NoUser()
                  : Builder(
                      builder: (BuildContext context) => Container(
                            color: AppColors.grey.withOpacity(0.1),
                            height: MediaQuery.of(context).size.height,
                            child: ListView(children: <Widget>[
                              _listOfValue(),
                              // SizedBox(height:  10),
                              weightLinegraph(),
                              const SizedBox(
                                height: 20,
                              ),
                              glicimiaLinegraph(),
                              const SizedBox(
                                height: 20,
                              ),
                              pressureLinegraph(),
                              const SizedBox(
                                height: 20,
                              ),
                              tempratureLinegraph(),
                              const SizedBox(
                                height: 20,
                              ),
                              colostrolLinegraph(),
                              const SizedBox(
                                height: 20,
                              ),
                              lipidprofile1Linegraph(),
                              const SizedBox(
                                height: 20,
                              ),
                              lipidprofile2Linegraph(),
                              const SizedBox(
                                height: 20,
                              ),
                            ]),
                          )),
        ));
  }

  EditData(
      {required String height,
      required String weight,
      required bool food_intolerance,
      required bool smoker,
      required bool physical_activity,
      required bool family_history_inserted,
      required bool children,
      required bool animal,
      required bool hypertension,
      required bool diabetes,
      required bool hypercholesterolemia,
      required String allergies,
      required String pressure,
      required bool free_text_with_other_parthlogic,
      required String additional_comment,
      required String tempreture,
      required String glycemia,
      required String max_pressure,
      required String min_pressure,
      required String bpm,
      required String cholesterol,
      required String lipidprofile,
      required String lipidprofile2,
      setState}) async {
    setState(() {
      bottomloading = true;
    });
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          bottomloading = true;
        });

        try {
          Dio dio = Dio();
          //            '"user_id" : ${ref.read(authProvider).user?.userId},"user_device_id":"","access_token":"","pharmacy_id": ${Constant.pharmacy_id},"height":"$height","weight":"$weight","pressure":"$pressure","smoker":"${controller_smoker.text}","physical_activity":"${controller_physical_activity.text}","family_history_inserted":"${controller_family_history_inserted.text}","children":"${controller_children.text}","animal":"${controller_animal.text}","hypertension":"${controller_hypertension.text}","diabetes":"${controller_diabetes.text}","allergies":"$allergies","food_intolerance":"${controller_food_intolerence.text}","free_text_with_other_parthlogic":"$free_text_with_other_parthlogic","hypercholesterolemia":"${controller_hypercholesterolemia.text}" ,"additional_comment":"${additional_comment.trim()}" ,"temprature":"$tempreture","bpm":"$bpm","glycemia":"$glycemia","max_pressure":"$max_pressure","min_pressure":"$min_pressure","colestorl":"$cholesterol","lipid_profile":"$lipidprofile","lipid_profile2":"$lipidprofile2"'
          var dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "height": height,
            "weight": weight,
            "pressure": pressure,
            "smoker": "",
            "physical_activity": "",
            "family_history_inserted": "",
            "children": "",
            "animal": "",
            "hypertension": "",
            "diabetes": "",
            "allergies": allergies,
            "food_intolerance": "",
            "free_text_with_other_parthlogic":
                "$free_text_with_other_parthlogic",
            "hypercholesterolemia": "",
            "additional_comment": additional_comment.trim(),
            "temprature": tempreture,
            "bpm": bpm,
            "glycemia": glycemia,
            "max_pressure": max_pressure,
            "min_pressure": min_pressure,
            "colestorl": cholesterol,
            "lipid_profile": lipidprofile,
            "lipid_profile2": lipidprofile2
          });
          dio
              .post(
            Constant.edithealth,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = (value.data) as Map<String, dynamic>;
            print(temp);
            if (value.statusCode == 200) {
              if (1 == 1) {
                /*  setState(() {
                  EditHealthdata = temp['data'];
                  loading = false;
                });*/
              } else if (temp['code'] == 999) {
                setState(() {
                  bottomloading = false;
                });
                showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                setState(() {
                  bottomloading = false;
                });
                showInSnackBar("${temp['message']}", context);
              }
            }
          });
        } catch (e) {
          print(e);
          showInSnackBar(translate(context, "error_fetching_data"), context);
          setState(() {
            bottomloading = false;
          });
        }
      }
    });
  }

  fetchChartData() async {
    setState(() {
      loading = true;
      weightdatalistGraph = [];
      glycemiadatalistGraph = [];
      pressuredatalistGraph = [];
      temreturedatalistGraph = [];
      colestroldatalistGraph = [];
      lipidprofile1listGraph = [];
      lipidprofile2listGraph = [];
      _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      _timeController.text = DateFormat('kk:mm').format(DateTime.now());
    });
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          loading = true;
        });

        try {
          Dio dio = Dio();
          //TODO da qui GET
          await dio.get(
            Constant.health_chart_data,
            queryParameters: {
              //TODO fix
              'user_id': ref.read(authProvider).user?.userId,
              //'user_id': 1394,
              'pharmacy_id': ref.read(flavorProvider).pharmacyId,
              //'pharmacy_id': 1,
            },
          ).then((value) async {
            var temp = value.data as Map<String, dynamic>;
            log("$temp", name: "Temp");
            if (value.statusCode == 200) {
              if (1 == 1) {
                setState(() {
                  chartData = temp;

                  if (chartData['weight'] != null) {
                    setState(() {
                      weightdatalist = chartData['weight'] ?? [];
                    });
                    if (weightdatalist.isNotEmpty) {
                      weightdatalist.sort((a, b) {
                        return a['date'].compareTo(b['date']);
                      });
                    }

                    log("${weightdatalist.length}", name: 'weightdatalist');

                    for (int i = 0; i < weightdatalist.length; i++) {
                      setState(() {
                        weightdatalistGraph.add(TimeSeriesSales(
                            DateFormat("dd/MMM").format(DateTime.parse(
                                weightdatalist[i]['date'] ??
                                    "2021-06-24 12:00:00")),
                            double.parse(weightdatalist[i]['value'] == null ||
                                    weightdatalist[i]['value'] == "50.0."
                                ? "0.0"
                                : weightdatalist[i]['value'])));
                      });
                    }
                    log("${weightdatalistGraph.length}",
                        name: 'weightdatalist');
                    // weightdatalist = weightdatalist.reversed.toList();
                    // weightdatalistY = weightdatalist
                    //     .map((e) => double.parse(e['value']))
                    //     .toList();
                    // weightdatalistY.sort();
                  }
                  //print("this is weight data ${weightdatalist=chartData['weight'][0]['value']}");

                  if (chartData['glycemia'] != null) {
                    setState(() {
                      glycemiadatalist = chartData['glycemia'] ?? [];
                    });
                    if (glycemiadatalist.isNotEmpty) {
                      glycemiadatalist.sort((a, b) {
                        return a['date'].compareTo(b['date']);
                      });
                    }

                    log("${glycemiadatalist.length}", name: 'glycemiadatalist');
                    for (int i = 0; i < glycemiadatalist.length; i++) {
                      setState(() {
                        glycemiadatalistGraph.add(TimeSeriesSales(
                            DateFormat("dd/MMM").format(DateTime.parse(
                                glycemiadatalist[i]['date'] ??
                                    "2021-06-24 12:00:00")),
                            double.parse(glycemiadatalist[i]['value'] == null ||
                                    glycemiadatalist[i]['value'] == "50.0." ||
                                    glycemiadatalist[i]['value']
                                        .toString()
                                        .contains("fg")
                                ? "0.0"
                                : glycemiadatalist[i]['value'])));
                      });
                    }

                    log("${glycemiadatalist.length}", name: 'glycemiadatalist');
                    // glycemiadatalist = glycemiadatalist.reversed.toList();
                    // glycemiadatalistY = glycemiadatalist
                    //     .map((e) => int.parse(e['value']))
                    //     .toList();
                    // print(chartData['glycemia']);
                    // print(chartData['weight']);
                    // glycemiadatalistY.sort();
                  }

                  if (chartData['bpm'] != null) {
                    setState(() {
                      pressuredatalist = chartData['bpm'] ?? [];
                      minpressuredatalist = chartData['min_pressure'] ?? [];
                      maxpressuredatalist = chartData['max_pressure'] ?? [];
                    });
                    if (pressuredatalist.isNotEmpty) {
                      pressuredatalist.sort((a, b) {
                        return a['date'].compareTo(b['date']);
                      });
                    }

                    for (int i = 0; i < pressuredatalist.length; i++) {
                      setState(() {
                        pressuredatalistGraph.add(TimeSeriesSales(
                            DateFormat("dd/MMM").format(DateTime.parse(
                                pressuredatalist[i]['date'] ??
                                    "2021-06-24 12:00:00")),
                            double.parse(pressuredatalist[i]['value'] == null ||
                                    pressuredatalist[i]['value'] == "50.0."
                                ? "0.0"
                                : pressuredatalist[i]['value'])));
                      });
                    }

                    // pressuredatalist = pressuredatalist.reversed.toList();
                    // pressuredatalistY = pressuredatalist
                    //     .map((e) => int.parse(e['value']))
                    //     .toList();
                    // pressuredatalistY.sort();
                  }

                  if (chartData['temprature'] != null) {
                    setState(() {
                      temreturedatalist = chartData['temprature'] ?? [];
                    });
                    if (temreturedatalist.isNotEmpty) {
                      temreturedatalist.sort((a, b) {
                        return a['date'].compareTo(b['date']);
                      });
                    }

                    log(temreturedatalist.length.toString(),
                        name: "temprature");

                    for (int i = 0; i < temreturedatalist.length; i++) {
                      setState(() {
                        temreturedatalistGraph.add(TimeSeriesSales(
                            DateFormat("dd/MMM").format(DateTime.parse(
                                temreturedatalist[i]['date'] ??
                                    "2021-06-24 12:00:00")),
                            double.parse(
                                temreturedatalist[i]['value'] == null ||
                                        temreturedatalist[i]['value'] == "50.0."
                                    ? "0.0"
                                    : temreturedatalist[i]['value'])));
                      });
                    }
                    // temreturedatalistY = temreturedatalist
                    //     .map((e) => double.parse(e['value']))
                    //     .toList();
                    // temreturedatalistY.sort();
                  }

                  if (chartData['cholestrol'] != null) {
                    setState(() {
                      colestordatalist = chartData['cholestrol'] ?? [];
                    });
                    if (colestordatalist.isNotEmpty) {
                      colestordatalist.sort((a, b) {
                        return a['date'].compareTo(b['date']);
                      });
                    }

                    log(colestordatalist.length.toString(),
                        name: "colestordatalist");

                    for (int i = 0; i < colestordatalist.length; i++) {
                      setState(() {
                        colestroldatalistGraph.add(TimeSeriesSales(
                            DateFormat("dd/MMM").format(DateTime.parse(
                                colestordatalist[i]['date'] ??
                                    "2021-06-24 12:00:00")), //),
                            double.parse(colestordatalist[i]['value'] == null ||
                                    colestordatalist[i]['value'] == "50.0."
                                ? "0.0"
                                : colestordatalist[i]['value'])));
                      });
                    }
                    // colestordatalistY = colestordatalist
                    //     .map((e) => double.parse(e['value']))
                    //     .toList();
                    // colestordatalistY.sort();
                  }

                  if (chartData['lipid_profile'] != null) {
                    setState(() {
                      lipidprofile1datalist = chartData['lipid_profile'] ?? [];
                    });
                    if (lipidprofile1datalist.isNotEmpty) {
                      lipidprofile1datalist.sort((a, b) {
                        return a['date'].compareTo(b['date']);
                      });
                    }

                    log(lipidprofile1datalist.length.toString(),
                        name: "lipidprofile1datalist");

                    for (int i = 0; i < lipidprofile1datalist.length; i++) {
                      setState(() {
                        lipidprofile1listGraph.add(TimeSeriesSales(
                            DateFormat("dd/MMM").format(DateTime.parse(
                                lipidprofile1datalist[i]['date'] ??
                                    "2021-06-24 12:00:00")),
                            double.parse(lipidprofile1datalist[i]['value'] ==
                                        null ||
                                    lipidprofile1datalist[i]['value'] == "50.0."
                                ? "0.0"
                                : lipidprofile1datalist[i]['value'])));
                      });
                    }
                    // lipidprofile1datalistY = lipidprofile1datalist
                    //     .map((e) => double.parse(e['value']))
                    //     .toList();
                    // lipidprofile1datalistY.sort();
                  }

                  if (chartData['lipid_profile2'] != null) {
                    setState(() {
                      lipidprofile2datalist = chartData['lipid_profile2'] ?? [];
                    });
                    if (lipidprofile2datalist.isNotEmpty) {
                      lipidprofile2datalist.sort((a, b) {
                        return a['date'].compareTo(b['date']);
                      });
                    }

                    log(lipidprofile2datalist.length.toString(),
                        name: "lipidprofile1datalist");

                    for (int i = 0; i < lipidprofile2datalist.length; i++) {
                      setState(() {
                        lipidprofile2listGraph.add(TimeSeriesSales(
                            DateFormat("dd/MMM").format(DateTime.parse(
                                lipidprofile2datalist[i]['date'] ??
                                    "2021-06-24 12:00:00")),
                            double.parse(lipidprofile2datalist[i]['value'] ==
                                        null ||
                                    lipidprofile2datalist[i]['value'] == "50.0."
                                ? "0.0"
                                : lipidprofile2datalist[i]['value'])));
                      });
                    }
                    // lipidprofile2datalistY = lipidprofile2datalist
                    //     .map((e) => double.parse(e['value']))
                    //     .toList();
                    // lipidprofile2datalistY.sort();
                  }
                  loading = false;
                });
              } else if (temp['code'] == 201) {
                setState(() {
                  loading = false;
                  weightdatalistGraph = [];
                  weightdatalist = [];
                  glycemiadatalistGraph = [];
                  glycemiadatalist = [];
                  pressuredatalistGraph = [];
                  pressuredatalist = [];
                  minpressuredatalist = [];
                  maxpressuredatalist = [];
                  temreturedatalistGraph = [];
                  temreturedatalist = [];
                  colestroldatalistGraph = [];
                  colestordatalist = [];

                  lipidprofile1listGraph = [];
                  lipidprofile1datalist = [];

                  lipidprofile2listGraph = [];
                  lipidprofile2datalist = [];
                });
              } else if (temp['code'] == 999) {
                setState(() {
                  loading = false;
                });
                showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                setState(() {
                  loading = false;
                  add = true;
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => EditHealthFolder({}, "add"),
                //     ));
              }
            }
          });
        } catch (e) {
          print(e);
          // showInSnackBar(
          //     "${translate(context, "error_fetching_data")}", context);
          setState(() {
            loading = false;
          });
        }
      }
    });
  }

  addHealthChartData(type, amount, {max_pressure, min_pressure, bpm}) {
    amount = amount.toString().replaceAll(",", ".");
    max_pressure = max_pressure.toString().replaceAll(",", ".");
    min_pressure = min_pressure.toString().replaceAll(",", ".");
    bpm = bpm.toString().replaceAll(",", ".");

    log("$amount", name: "Amounttttt");
    log("$type", name: "Typeeeeee");
    var dataToBesent;
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);
      loading = true;
    });
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          loading = true;
        });
        if (type == "height") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "height": "$amount",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "weight") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "weight": "$amount",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "temperature") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "temprature": "$amount",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "glycemia") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "glycemia": "$amount",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "pressure") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "bpm": "$bpm",
            "max_pressure": "$max_pressure",
            "min_pressure": "$min_pressure",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }

        if (type == "cholestrol") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "cholestrol": "$amount",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "lipid_profile") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "lipid_profile": "$amount",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "lipid_profile2") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "lipid_profile2": "$amount",
            "health_date":
                "${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }

        try {
          Dio dio = Dio();

          dio
              .post(
            Constant.addHealthChart,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = value.data as Map<String, dynamic>;
            if (value.statusCode == 200) {
              if (1 == 1) {
                fetchChartData();
                Navigator.pop(context);
              } else if (temp['code'] == 999) {
                setState(() {
                  loading = false;
                });
                showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                setState(() {
                  loading = false;
                });
              }
            }
          });
        } catch (e) {
          print(e);
          showInSnackBar(translate(context, "error_fetching_data"), context);
          setState(() {
            loading = false;
          });
        }
      }
    });
  }
}

/// Sample time series data type.

class TimeSeriesSales {
  final String time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}

//todo fix

// class CustomCircleSymbolRenderer extends common.CircleSymbolRenderer {
//   String s;

//   CustomCircleSymbolRenderer(this.s);

//   @override
//   //TODO fix
//   void paint(common.ChartCanvas canvas, m.Rectangle<num> bounds,
//       {List<int>? dashPattern,
//       common.Color? fillColor,
//       common.Color? strokeColor,
//       common.FillPatternType? fillPattern,
//       double? strokeWidthPx}) {
//     // TODO: implement paint
//     super.paint(canvas, bounds,
//         dashPattern: dashPattern,
//         fillColor: common.Color.white,
//         strokeColor: common.Color.black,
//         strokeWidthPx: 1);

//     super.paint(canvas, bounds,
//         dashPattern: dashPattern,
//         fillColor: common.Color.white,
//         strokeColor: common.Color.black,
//         strokeWidthPx: 1);

//     // Draw a bubble

//     final num bubbleHight = 40;
//     const num bubbleWidth = 60;
//     final num bubbleRadius = bubbleHight / 2.0;
//     final num bubbleBoundLeft = bounds.left;
//     final num bubbleBoundTop = bounds.top - bubbleHight;

//     canvas.drawRRect(
//       m.Rectangle(bubbleBoundLeft, bubbleBoundTop, bubbleWidth, bubbleHight),
//       fill: common.Color.black,
//       stroke: common.Color.black,
//       radius: bubbleRadius,
//       roundTopLeft: true,
//       roundBottomLeft: true,
//       roundBottomRight: true,
//       roundTopRight: true,
//     );

//     // Add text inside the bubble

//     /* final textStyle = common.TextStyle();
//     textStyle.color = common.Color.white;
//     textStyle.fontSize = 12;*/

// /*    final common.TextElement textElement =
//         common.TextElement(s, style: textStyle);*/

// /*    final num textElementBoundsLeft = ((bounds.left +
//             (bubbleWidth - textElement.measurement.horizontalSliceWidth) / 2))
//         .round();
//     final num textElementBoundsTop = (bounds.top - 25).round();

//     canvas.drawText(textElement, textElementBoundsLeft, textElementBoundsTop);
//   }*/
//   }
// }

class InputDoneView extends StatelessWidget {
  const InputDoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.grey,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: const Text("Chiudi",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

//todo fix

/*
class LocalizedTimeFactory implements common.DateTimeFactory {
  final Locale locale;

  const LocalizedTimeFactory(this.locale);

  @override
  DateTime createDateTimeFromMilliSecondsSinceEpoch(
      int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  @override
  DateTime createDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    return DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }

  /// Returns a [DateFormat].
  /// //TODO funziona?
  @override
  DateFormat createDateFormat(String? pattern) {
    return DateFormat(pattern, 'it');
  }
}
*/
