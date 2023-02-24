import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../config/EncodeDecode.dart';
import '../../config/MyApplication.dart';
import '../../config/constant.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../../utils/ImageString.dart';

class TemperatureMeasurement extends ConsumerStatefulWidget {
  static String routeName = "/TemperatureMeasurement";
  var data;
  String name;
  String typename;
  String type;
  var maxPres;
  var minPres;

  TemperatureMeasurement(
    this.data,
    this.name,
    this.typename,
    this.type, {
    this.minPres,
    this.maxPres,
  });

  @override
  _TemperatureMeasurementState createState() => _TemperatureMeasurementState();
}

class _TemperatureMeasurementState
    extends ConsumerState<TemperatureMeasurement> {
  bool loading = false;
  var bottomloading = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  String? hour, _minute, time;
  String? changeTime;
  var overlayEntry;

  TextEditingController controller_temperature = TextEditingController();
  TextEditingController weightcontroller = TextEditingController();
  TextEditingController additionalnotecontroller = TextEditingController();
  TextEditingController glycemiacontroller = TextEditingController();
  TextEditingController maxpressurecontroller = TextEditingController();
  TextEditingController minpressurecontroller = TextEditingController();
  TextEditingController bpmcontroller = TextEditingController();
  TextEditingController cholestrolcontroller = TextEditingController();
  TextEditingController lipidprofile1controller = TextEditingController();
  TextEditingController lipidprofile2controller = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  final FocusNode _node_temperature = new FocusNode();

  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, setState) async {
    final DateTime? pickedDate = await showDatePicker(
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
        log("$pickedDate", name: "Change date");
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
        time = hour! + ' : ' + _minute!;

        _timeController.text =
            "${hour.toString().length == 1 ? "0" : ""}$hour:${_minute.toString().length == 1 ? "0" : ""}$_minute";
        changeTime = "${selectedTime.hour}:${selectedTime.minute}:00 ";
      });
    }
  }

  Widget _heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.name + " " + translate(context, "Measurement"),
            style: AppTheme.h5Style
                .copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w600),
          ),
        ),
        InkWell(
            onTap: () {
              controller_temperature.clear();
              weightcontroller.clear();
              glycemiacontroller.clear();
              cholestrolcontroller.clear();
              lipidprofile1controller.clear();
              lipidprofile2controller.clear();
              _dateController.clear();
              _timeController.clear();

              _dateController.text =
                  DateFormat('dd/MM/yyyy').format(DateTime.now());
              _timeController.text = DateFormat('kk:mm').format(DateTime.now());
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  builder: (context) => SingleChildScrollView(
                        child: Container(
                            child: widget.type == "temprature"
                                ? temperatureBottomSheet(
                                    context, false, "", "", "")
                                : widget.type == "weight"
                                    ? weightBottomSheet(false, "", "")
                                    : widget.type == "glycemia"
                                        ? glycemiaBottomSheet(false, "", "")
                                        : widget.type == "pressure"
                                            ? pressureBottomSheet(false, "", "")
                                            : widget.type == "cholestrol"
                                                ? cholesterolBottomSheet(
                                                    false, "", "")
                                                : widget.type == "lipid_profile"
                                                    ? lipidprofile_1bottomsheet(
                                                        false, "", "")
                                                    : lipidprofile_2bottomsheet(
                                                        false, "", "")),
                      ));
            },
            child: Image.asset(
              ic_addnew_item,
              height: 4.0.h,
            )),
      ],
    );
  }

  Widget _temprature() {
    return SizedBox(
      height: 70.0.h,
      child: widget.data == null || widget.data.length == 0
          ? Center(child: Text(translate(context, "please_add_data")))
          : ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: const BoxDecoration(),
                  padding: EdgeInsets.only(top: 5),
                  child: Card(
                    shadowColor: AppColors.grey,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    //'${DateFormat('dd/MM/yyyy').format(DateFormat("yyyy-mm-dd hh:mm:ss").parse(widget.data[index]['date']))}',
                                    DateFormat('dd/MM/yyyy').format(
                                        DateFormat("yyyy-MM-dd").parse(
                                            widget.data[index]['date'] ??
                                                "2021-06-24")),
                                    style: AppTheme.subTitleStyle
                                        .copyWith(color: AppColors.black),
                                  ),

                                  // Text('${widget.name}',style: AppTheme.bodyText.copyWith(color: AppColors.light_grey),),
                                  Text(
                                    widget.name +
                                        " " +
                                        '${widget.data[index]['value']}' +
                                        " " +
                                        (widget.name == "Pressione"
                                            ? "bpm"
                                            : widget.typename),
                                    style: AppTheme.bodyText
                                        .copyWith(color: AppColors.lightGrey),
                                  ),

                                  widget.minPres != null
                                      ? Text(
                                          translate(context, "min_pressure") +
                                              " " +
                                              '${widget.minPres[index]['value']}' +
                                              " " +
                                              widget.typename,
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey),
                                        )
                                      : const SizedBox(),
                                  widget.maxPres != null
                                      ? Text(
                                          translate(context, "max_pressure") +
                                              " " +
                                              '${widget.maxPres[index]['value']}' +
                                              " " +
                                              widget.typename,
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey),
                                        )
                                      : const SizedBox(),
                                  /*Text('27/09/2021',style: AppTheme.subTitleStyle.copyWith(color: AppColors.black),),
                              Text('Weight 90 kg',style: AppTheme.bodyText.copyWith(color: AppColors.light_grey),),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  log(widget.data[index].toString(),
                                      name: "Edit Value");
                                  controller_temperature.text =
                                      widget.data[index]['value'];
                                  weightcontroller.text =
                                      widget.data[index]['value'];
                                  glycemiacontroller.text =
                                      widget.data[index]['value'];
                                  cholestrolcontroller.text =
                                      widget.data[index]['value'];
                                  lipidprofile1controller.text =
                                      widget.data[index]['value'];
                                  lipidprofile2controller.text =
                                      widget.data[index]['value'];
                                  bpmcontroller.text =
                                      widget.data[index]['value'];
                                  if (widget.maxPres != null) {
                                    maxpressurecontroller.text =
                                        widget.maxPres[index]['value'];

                                    minpressurecontroller.text =
                                        widget.minPres[index]['value'];
                                  }

                                  if (widget.data[index]['date'] != null) {
                                    _dateController.text =
                                        DateFormat('dd/MM/yyyy').format(
                                            DateFormat('yyyy-MM-dd hh:mm:ss')
                                                .parse(widget.data[index]
                                                    ['date']));
                                    _timeController.text = DateFormat('HH:mm')
                                        .format(DateFormat(
                                                'yyyy-MM-dd HH:mm:ss')
                                            .parse(widget.data[index]['date']));

                                    selectedDate =
                                        DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .parse(widget.data[index]['date']);
                                    selectedTime = TimeOfDay(
                                        hour: selectedDate.hour,
                                        minute: selectedDate.minute);

                                    // "health_date":"${DateFormat('yyyy-MM-dd hh:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"

                                  }
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    builder: (context) => SingleChildScrollView(
                                      child: Container(
                                          child: widget.type == "temprature"
                                              ? temperatureBottomSheet(
                                                  context,
                                                  true,
                                                  widget.data[index]['value'],
                                                  widget.data[index]['id'],
                                                  widget.data[index]['date'],
                                                )
                                              : widget.type == "weight"
                                                  ? weightBottomSheet(
                                                      true,
                                                      widget.data[index]
                                                          ['value'],
                                                      widget.data[index]['id'],
                                                    )
                                                  : widget.type == "glycemia"
                                                      ? glycemiaBottomSheet(
                                                          true,
                                                          widget.data[index]
                                                              ['value'],
                                                          widget.data[index]
                                                              ['id'])
                                                      : widget.type ==
                                                              "pressure"
                                                          ? pressureBottomSheet(
                                                              true,
                                                              widget.data[index]
                                                                  ['value'],
                                                              widget.data[index]
                                                                  ['id'])
                                                          : widget.type ==
                                                                  "cholestrol"
                                                              ? cholesterolBottomSheet(
                                                                  true,
                                                                  widget.data[index]
                                                                      ['value'],
                                                                  widget.data[index]
                                                                      ['id'])
                                                              : widget.type ==
                                                                      "lipid_profile"
                                                                  ? lipidprofile_1bottomsheet(
                                                                      true,
                                                                      widget.data[index][
                                                                          'value'],
                                                                      widget.data[index][
                                                                          'id'])
                                                                  : lipidprofile_2bottomsheet(
                                                                      true,
                                                                      widget.data[index]
                                                                          [
                                                                          'value'],
                                                                      widget.data[index]
                                                                          ['id'])),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  ic_edit_primary,
                                  height: 3.0.h,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  await deleteHealthChartData(
                                      widget.type, widget.data[index]['id']);
                                },
                                child: Image.asset(
                                  ic_primary_delete,
                                  height: 3.0.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      // iOS-specific code
      //TODO ripristinare
      /*   KeyboardVisibilityNotification().addNewListener(onShow: () {
        showOverlay(context);
      }, onHide: () {
        removeOverlay();
      });
*/
      _node_temperature.addListener(() {
        bool hasFocus = _node_temperature.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else
          removeOverlay();
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
          child: InputDoneView());
    });

    overlayState?.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(translate(context, "healthfolder")),
        ),
        body: Builder(
            builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _heading(),
                          loading
                              ? SizedBox(
                                  height: 80.0.h,
                                  width: 100.0.w,
                                  child: const SizedBox(),
                                )
                              : _temprature()
                        ]),
                  ),
                )),
      ),
    );
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
              InkWell(
                  onTap: () async {
                    _selectDate(context, setState);
                  },
                  child: Text(
                    translate(context, "Date"),
                    style:
                        AppTheme.h6Style.copyWith(color: AppColors.lightGrey),
                  )),
              InkWell(
                  onTap: () {
                    _selectTime(context, setState);
                  },
                  child: Text(
                      translate(
                        context,
                        "Now",
                      ),
                      style: AppTheme.h6Style
                          .copyWith(color: AppColors.lightGrey))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _selectDate(context, setState);
                },
                child: Container(
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

  Widget temperatureBottomSheet(contex, bool edit, String text, id, date) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO shimmerloader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                              scale: 4,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
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
                    child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          //TODO fix
                          // ValidatorInputFormatter(
                          //     editingValidator:
                          //         DecimalNumberEditingRegexValidator())
                        ],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        textInputAction: TextInputAction.next,
                        controller: controller_temperature,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0.sp,
                            color: AppColors.darkGrey),
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          labelText: translate(context, "TEMPERATURE"),
                          filled: false,
                          enabled: true,
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGrey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ref.read(flavorProvider).primary),
                          ),
                        ))),
                dateTimeWidget(setState),
                additionalBox(),
                const SizedBox(
                  height: 20,
                ),
                //TODO fixare?
                InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, TemperatureMeasurement.routeName);
                  },
                  child: Container(
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
                      onTap: () async {
                        if (controller_temperature.text.isEmpty) {
                          showredToast(
                              translate(context, "enter_tempratue"), context);
                          return;
                        } else if (_dateController.text.isEmpty &&
                            _timeController.text.isEmpty) {
                          showredToast(
                              translate(context, "enter_date_time"), context);
                        } else if (!controller_temperature.text
                            .contains(RegExp(r'[0-9]'))) {
                          showredToast(
                              translate(context, "enter_tempratue"), context);
                        } else {
                          if (edit) {
                            await editHealthChartData(
                                "temprature",
                                id,
                                controller_temperature.text,
                                _dateController.text);
                          } else {
                            await addHealthChartData(
                                "temprature", controller_temperature.text);
                          }

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

  Widget pressureBottomSheet(bool edit, String text, id) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO shimmerloader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                              scale: 4,
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
                  child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: maxpressurecontroller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "MAX_PRESSURE"),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: minpressurecontroller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "MINIMUM_PRESSURE"),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: bpmcontroller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "PRESSURE"),
                      )),
                ),
                dateTimeWidget(setState),
                additionalBox(),
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
                            translate(context, "enter_max_pressure"), context);

                        return;
                      } else if (minpressurecontroller.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_min_pressure"), context);
                        return;
                      } else if (bpmcontroller.text.isEmpty) {
                        showredToast(translate(context, "err_bpm"), context);
                        showredToast(
                            translate(context, "enter_pressure"), context);

                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        if (edit) {
                          editHealthChartData("pressure", id, 0, "",
                              bpm: bpmcontroller.text,
                              max_pressure: maxpressurecontroller.text,
                              min_pressure: minpressurecontroller.text);
                        } else {
                          addHealthChartData("pressure", 0,
                              bpm: bpmcontroller.text,
                              max_pressure: maxpressurecontroller.text,
                              min_pressure: minpressurecontroller.text);
                        }
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

  Widget glycemiaBottomSheet(bool edit, String text, id) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO SHIMMERLOADER
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                              scale: 4,
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
                  child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: glycemiacontroller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "GLICEMIA"),
                      )),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                additionalBox(),
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
                        if (edit) {
                          editHealthChartData(
                            "glycemia",
                            id,
                            glycemiacontroller.text,
                            _dateController.text,
                          );
                        } else {
                          addHealthChartData(
                            "glycemia",
                            glycemiacontroller.text,
                          );
                        }

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

  Widget weightBottomSheet(bool edit, String text, id) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO shummerloader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                              scale: 4,
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
                  child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: weightcontroller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "WEIGHT"),
                      )),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                additionalBox(),
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
                        showredToast(
                            translate(context, "enter_weight"), context);
                        return;
                      } else if (_dateController.text.isEmpty &&
                          _timeController.text.isEmpty) {
                        showredToast(
                            translate(context, "enter_date_time"), context);
                      } else {
                        if (edit) {
                          editHealthChartData("weight", id,
                              weightcontroller.text, _dateController.text);
                        } else {
                          addHealthChartData("weight", weightcontroller.text);
                        }

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

  Widget cholesterolBottomSheet(bool edit, String text, id) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO shimmerloader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 10),
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
                              scale: 4,
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                  // child: EditTextWithoutIcon(
                  //   onchangtext: '',
                  //   onchange: (change) {},
                  //   label: translate(context, "CHOLESTEROL"),
                  //   controller: cholestrolcontroller,
                  //   textInputType: const TextInputType.numberWithOptions(
                  //       signed: true, decimal: true),

                  // ),
                  child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: cholestrolcontroller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "CHOLESTEROL"),
                      )),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 20,
                ),
                additionalBox(),
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

                        showredToast(
                            translate(context, "enter_cholestrol"), context);
                        return;
                      } else {
                        if (edit) {
                          editHealthChartData("cholestrol", id,
                              cholestrolcontroller.text, _dateController.text);
                        } else {
                          addHealthChartData(
                              "cholestrol", cholestrolcontroller.text);
                        }

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

  Widget lipidprofile_1bottomsheet(bool edit, String text, id) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO Shimmerloader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                              scale: 4,
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
                  child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: lipidprofile1controller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "lipid_profile_CAP"),
                      )),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                additionalBox(),
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
                        showredToast(
                            translate(context, "enter_lipid_profile"), context);
                        return;
                      } else {
                        if (edit) {
                          editHealthChartData(
                              "lipid_profile",
                              id,
                              lipidprofile1controller.text,
                              _dateController.text);
                        } else {
                          addHealthChartData(
                              "lipid_profile", lipidprofile1controller.text);
                        }
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

  Widget lipidprofile_2bottomsheet(bool edit, String text, id) {
    return StatefulBuilder(builder: (contex, setState) {
      return bottomloading
          //TODO shimmerloader
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8.0.h,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
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
                              scale: 4,
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
                  child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (change) {},
                      controller: lipidprofile2controller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: translate(context, "lipid_profile_CAP"),
                      )),
                ),
                dateTimeWidget(setState),
                const SizedBox(
                  height: 10,
                ),
                additionalBox(),
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

                        showredToast(
                            translate(context, "enter_lipid_profile"), context);
                        return;
                      } else {
                        if (edit) {
                          editHealthChartData(
                            "lipid_profile2",
                            id,
                            lipidprofile2controller.text,
                            _dateController.text,
                          );
                        } else {
                          addHealthChartData(
                              "lipid_profile2", lipidprofile2controller.text);
                        }
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

  Widget additionalBox() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
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
                                cursorColor: AppColors.blueColor,
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

  addHealthChartData(type, amount, {max_pressure, min_pressure, bpm}) {
    log("Add $type");
    amount = amount.toString().replaceAll(",", ".");
    max_pressure = max_pressure.toString().replaceAll(",", ".");
    min_pressure = min_pressure.toString().replaceAll(",", ".");
    bpm = bpm.toString().replaceAll(",", ".");
    var dataToBesent;
    setState(() {
      loading = true;
    });
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
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
        if (type == "temprature") {
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
          Dio dio = new Dio();

          await dio
              .post(
            Constant.addHealthChart,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = json.decode((value.toString()));
            print(temp);
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                fetchChartData();
              } else if (temp['code'] == 999) {
                setState(() {
                  loading = false;
                });
                showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                // showInSnackBar("${temp['message']}", context);
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

  deleteHealthChartData(type, id) async {
    log("this is deleted data api called $type");
    var dataToBesent;
    setState(() {
      loading = true;
    });
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          loading = true;
        });

        EncodeDecode enc = EncodeDecode();
        if (widget.type == "pressure") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "bpm": "bpm",
            "min_pressure": "min_pressure",
            "max_pressure": "max_pressure",
            "health_chart_id": "$id"
          });
        } else {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "type": widget.type,
            "health_chart_id": "$id"
          });
        }

        log("this is deleted data $dataToBesent");

        try {
          Dio dio = Dio();

          await dio
              .post(
            Constant.deleteHealthChart,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = json.decode(value.toString());
            print(temp);
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                //showgreenToast(translate(context, "data_deleted"), context);

                await fetchChartData();
              } else if (temp['code'] == 999) {
                setState(() {
                  loading = false;
                });
                showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                // showInSnackBar("${temp['message']}", context);
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

  editHealthChartData(type, id, amount, date,
      {max_pressure, min_pressure, bpm}) async {
    amount = amount.toString().replaceAll(",", ".");
    max_pressure = max_pressure.toString().replaceAll(",", ".");
    min_pressure = min_pressure.toString().replaceAll(",", ".");
    bpm = bpm.toString().replaceAll(",", ".");
    log("Edit");

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
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "weight") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "weight": "$amount",
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "temprature") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "temprature": "$amount",
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "glycemia") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "glycemia": "$amount",
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
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
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }

        if (type == "cholestrol") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "cholestrol": "$amount",
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "lipid_profile") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "lipid_profile": "$amount",
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }
        if (type == "lipid_profile2") {
          dataToBesent = ({
            "user_id": ref.read(authProvider).user?.userId,
            "user_device_id": "",
            "access_token": "",
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "lipid_profile2": "$amount",
            "health_chart_id": "$id",
            "health_date":
                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate)} ${selectedTime.hour}:${selectedTime.minute}:00"
          });
        }

        try {
          Dio dio = Dio();

          await dio
              .post(
            Constant.editHealthChart,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = json.decode((value.toString()));
            log(temp.toString());
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                fetchChartData();
              } else if (temp['code'] == 999) {
                setState(() {
                  loading = false;
                });
                //showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                // showInSnackBar("${temp['message']}", context);
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

  fetchChartData() async {
    print("${widget.type} Fetch Data Type");

    setState(() {
      loading = true;
    });
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          loading = true;
        });

        // var dataToBesent = ({
        //   '"user_id" : "${{
        //     ref.read(authProvider).user?.userId
        //   }}","user_device_id":"","access_token":"","pharmacy_id":"${Constant.pharmacy_id}"'
        // });
        // print(dataToBesent);
        try {
          Dio dio = Dio();

          await dio
              .get(
            Constant.health_chart_data,
            queryParameters: ({
              "user_id": ref.read(authProvider).user?.userId,
              "user_device_id": "",
              "access_token": ":",
              "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            }),
          )
              .then((value) async {
            var temp = json.decode((value.toString()));
            print("Temp data $temp");
            if (value.statusCode == 200) {
              //if (temp['code'] == 200) {
              setState(() {
                if (widget.type == "temprature") {
                  widget.data = temp['temprature'] ?? [];
                }
                if (widget.type == "weight") {
                  widget.data = temp['weight'] ?? [];
                }

                if (widget.type == "pressure") {
                  widget.data = temp['pressure'] ?? [];
                  widget.maxPres = temp['max_pressure'] ?? [];
                  widget.minPres = temp['min_pressure'] ?? [];
                }
                if (widget.type == "glycemia") {
                  widget.data = temp['glycemia'] ?? [];
                }
                if (widget.type == "pressure") {
                  widget.data = temp['bpm'] ?? [];
                }
                if (widget.type == "cholestrol") {
                  widget.data = temp['cholestrol'] ?? [];
                }
                if (widget.type == "lipid_profile") {
                  widget.data = temp['lipid_profile'] ?? [];
                }
                if (widget.type == "lipid_profile2") {
                  widget.data = temp['lipid_profile2'] ?? [];
                }

                // chartData = temp['data'];
                // weightdatalist = chartData['weight'] ?? [];
                //
                // weightdatalist = weightdatalist.reversed.toList();
                // weightdatalistY =
                //     weightdatalist.map((e) => int.parse(e['value'])).toList();
                // weightdatalistY.sort();
                //
                // //print("this is weight data ${weightdatalist=chartData['weight'][0]['value']}");
                // glycemiadatalist = chartData['glycemia'] ?? [];
                // glycemiadatalist = glycemiadatalist.reversed.toList();
                // glycemiadatalistY = glycemiadatalist
                //     .map((e) => int.parse(e['value']))
                //     .toList();
                // glycemiadatalistY.sort();
                //
                // pressuredatalist = chartData['pressure'] ?? [];
                // pressuredatalist = pressuredatalist.reversed.toList();
                // pressuredatalistY = pressuredatalist
                //     .map((e) => int.parse(e['value']))
                //     .toList();
                // pressuredatalistY.sort();
                //
                // temreturedatalist = chartData['temprature'] ?? [];
                // temreturedatalist = temreturedatalist.reversed.toList();
                // temreturedatalistY = temreturedatalist
                //     .map((e) => int.parse(e['value']))
                //     .toList();
                // temreturedatalistY.sort();

                loading = false;
              });
              // } else if (temp['code'] == 999) {
              //   setState(() {
              //     loading = false;
              //   });
              //   showInSnackBar("${temp['message']}", context);
              //   sessionExpired(context);
            } else {
              setState(() {
                widget.data = [];
                loading = false;
                // add = true;
              });
            }
          });
        } catch (e) {
          print(e);
          //showInSnackBar(translate(context, "error_fetching_data"), context);
          setState(() {
            loading = false;
          });
        }
      }
    });
  }
}

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
