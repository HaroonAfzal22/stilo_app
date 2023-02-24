import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class EditHealthFolder extends ConsumerStatefulWidget {
  static String routeName = "/EditHealthFolder";
  var healthData;
  String type;

  //Map healthData;
  EditHealthFolder(this.healthData, this.type);

  @override
  _EditHealthFolderState createState() => _EditHealthFolderState();
}

class _EditHealthFolderState extends ConsumerState<EditHealthFolder> {
  bool loading = false;
  var smoker;
  var physical_activity;

  var family_history_inserted;
  var children;

  var animal;

  var hypertension;
  var diabetes;
  var food_intolerance;

  //bool free_text_with_other_parthlogic = false;

  TextEditingController controller_height = TextEditingController();
  TextEditingController controller_weigth = TextEditingController();
  TextEditingController controller_pressure = TextEditingController();
  TextEditingController controller_smoker = TextEditingController();
  TextEditingController controller_physical_activity = TextEditingController();
  TextEditingController controller_family_history_inserted =
      TextEditingController();
  TextEditingController controller_children = TextEditingController();
  TextEditingController controller_animal = TextEditingController();
  TextEditingController controller_hypertension = TextEditingController();
  TextEditingController controller_diabetes = TextEditingController();
  TextEditingController controller_hypercholesterolemia =
      TextEditingController();
  TextEditingController controller_glycemia = TextEditingController();
  TextEditingController controller_max_pressure = TextEditingController();
  TextEditingController controller_min_pressure = TextEditingController();
  TextEditingController controller_bpm = TextEditingController();
  TextEditingController controller_lipidprofile = TextEditingController();
  TextEditingController controller_lipidprofile2 = TextEditingController();
  TextEditingController controller_cholesterol = TextEditingController();

  //TextEditingController controller_free_text_with_other_parthlogic= TextEditingController();
  TextEditingController controller_allergies = TextEditingController();
  TextEditingController controller_food_intolerence = TextEditingController();
  TextEditingController controller_additional_comments =
      TextEditingController();
  TextEditingController controller_tempreture = TextEditingController();

  var hypercholesterolemia;

  var free_text_with_other_parthlogic;

  var overlayEntry;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //    statusBarColor: Colors.white,
      //    statusBarIconBrightness: Brightness.dark,
      //  ));

      log(widget.type, name: "Typee");

      if (widget.type == "edit") {
        setState(() {
          smoker = widget.healthData['smoker'];
          // smoker = widget.healthData['smoker'] == "Y" ||  widget.healthData['smoker'] == true ? "${translate(context, "yes")}": widget.healthData['smoker'] =="N"?"${translate(context, "no")}":"";

          physical_activity = widget.healthData['physical_activity'];
          family_history_inserted =
              widget.healthData['family_history_inserted'];
          children = widget.healthData['children'];
          animal = widget.healthData['animal'];
          hypertension = widget.healthData['hypertension'];
          diabetes = widget.healthData['diabetes'];
          food_intolerance = widget.healthData['food_intolerance'];
          free_text_with_other_parthlogic =
              widget.healthData['free_text_with_other_parthlogic'];
          hypercholesterolemia = widget.healthData['hypercholesterolemia'];
          controller_physical_activity
              .text = widget.healthData['physical_activity'] == null ||
                  widget.healthData['physical_activity'].toString() == "null"
              ? ''
              : widget.healthData['physical_activity'];

          controller_children.text = widget.healthData['children'] == null ||
                  widget.healthData['children'].toString() == "null"
              ? ''
              : widget.healthData['children'];

          controller_family_history_inserted.text =
              widget.healthData['family_history_inserted'] == null ||
                      widget.healthData['family_history_inserted'].toString() ==
                          "null"
                  ? ''
                  : widget.healthData['family_history_inserted'];

          controller_animal.text = widget.healthData['animal'] == null ||
                  widget.healthData['animal'].toString() == "null"
              ? ''
              : widget.healthData['animal'];

          controller_hypertension.text =
              widget.healthData['hypertension'] == null ||
                      widget.healthData['hypertension'].toString() == "null"
                  ? ''
                  : widget.healthData['hypertension'];

          controller_diabetes.text = widget.healthData['diabetes'] == null ||
                  widget.healthData['diabetes'].toString() == "null"
              ? ''
              : widget.healthData['diabetes'];
          controller_hypercholesterolemia
              .text = widget.healthData['hypercholesterolemia'] == null ||
                  widget.healthData['hypercholesterolemia'].toString() == "null"
              ? ''
              : widget.healthData['hypercholesterolemia'];

          controller_food_intolerence.text =
              widget.healthData['food_intolerance'] == null ||
                      widget.healthData['food_intolerance'].toString() == "null"
                  ? ''
                  : widget.healthData['food_intolerance'];
          controller_smoker.text = widget.healthData['smoker'] == null ||
                  widget.healthData['smoker'].toString() == "null"
              ? ''
              : widget.healthData['smoker'] ?? "-";
          // = temp['data']['food_intolerance'];
        });
      }
    });

    //EditData();
    print(" this is helth data${widget.healthData}");
    if (widget.type == "edit") {
      // print($widget.type);
      fetchHealthData();
    }

    if (Platform.isIOS) {
      setState(() {});

      _node_height.addListener(() {
        bool hasFocus = _node_height.hasFocus;
        if (hasFocus)
          showOverlay(context);
        else
          removeOverlay();
      });
      _node_weigth.addListener(() {
        bool hasFocus = _node_weigth.hasFocus;
        if (hasFocus)
          showOverlay(context);
        else
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

  final FocusNode _node_height = new FocusNode();
  final FocusNode _node_weigth = new FocusNode();
  final FocusNode _node_pressure = new FocusNode();
  final FocusNode _node_smoker = FocusNode();
  final FocusNode _node_physical_activity = FocusNode();
  final FocusNode _node__children = FocusNode();
  final FocusNode _node__hypertension = FocusNode();
  final FocusNode node_diabetes = FocusNode();
  final FocusNode node__allergies = FocusNode();
  final FocusNode node__food_intolerence = FocusNode();
  final FocusNode node__additional_comments = FocusNode();

  fetchHealthData() {
    controller_height.text = widget.healthData['height'] ?? "";

    controller_weigth.text = widget.healthData['weight'] ?? "";

    controller_pressure.text = widget.healthData['pressure'] ?? "";

    controller_smoker.text = widget.healthData['smoker'] == "Y"
        ? "SI"
        : widget.healthData['smoker'] == "N"
            ? "NO"
            : "";
    //controller_smoker.text = widget.healthData['smoker'] ?? "";
    controller_physical_activity.text =
        widget.healthData['physical_activity'] == "Y"
            ? "SI"
            : widget.healthData['physical_activity'] == "N"
                ? "NO"
                : "";
    //controller_physical_activity.text = widget.healthData['physical_activity'] ?? "";
    print("Child-----" + widget.healthData['children'].toString());
    controller_children.text = widget.healthData['children'] == "Y"
        ? "SI"
        : widget.healthData['children'] == "N"
            ? "NO"
            : "";
    // controller_children.text = "SI";
    //     controller_animal.text = widget.healthData['animal'] ?? "";
    controller_animal.text = widget.healthData['animal'] == "Y"
        ? "SI"
        : widget.healthData['animal'] == "N"
            ? "NO"
            : "";

    // controller_hypertension.text = widget.healthData['hypertension'] ?? "";
    controller_hypertension.text = widget.healthData['hypertension'] == "Y"
        ? "SI"
        : widget.healthData['hypertension'] == "N"
            ? "NO"
            : "";
    // controller_diabetes.text = widget.healthData['diabetes'] ?? "";
    controller_diabetes.text = widget.healthData['diabetes'] == "Y"
        ? "SI"
        : widget.healthData['diabetes'] == "N"
            ? "NO"
            : "";

    controller_allergies.text = widget.healthData['allergies'] ?? "";
    // controller_food_intolerence.text = widget.healthData['food_intolerance'] ?? "";
    controller_food_intolerence.text =
        widget.healthData['food_intolerance'] == "Y"
            ? "SI"
            : widget.healthData['food_intolerance'] == "N"
                ? "NO"
                : "";

    controller_additional_comments.text =
        widget.healthData['additional_comment'] ?? "";
    //controller_free_text_with_other_parthlogic.text = widget.healthData['free_text_with_other_parthlogic'].toString() ;
    //controller_hypercholesterolemia .text = widget.healthData['hypercholesterolemia'].toString();
    controller_family_history_inserted.text =
        widget.healthData['family_history_inserted'] == "Y"
            ? "SI"
            : widget.healthData['family_history_inserted'] == "N"
                ? "NO"
                : "";
    // controller_family_history_inserted.text = widget.healthData['family_history_inserted'] ?? "";
    controller_tempreture.text = widget.healthData['temprature'] ?? "";
    controller_lipidprofile.text = widget.healthData['lipid_profile'] ?? "";
    controller_lipidprofile2.text = widget.healthData['lipid_profile2'] ?? "";
    controller_cholesterol.text = widget.healthData['colestorl'] ?? "";
    controller_glycemia.text = widget.healthData['glycemia'] ?? "";
    controller_max_pressure.text = widget.healthData['max_pressure'] ?? "";
    controller_min_pressure.text = widget.healthData['min_pressure'] ?? "";
    controller_bpm.text = widget.healthData['bpm'] ?? "";
    setState(() {});
  }

  @override
  void dispose() {
    //_animationController.dispose();
    //_node_height.dispose();
    /* _timeController.dispose();
    qty_controller.dispose();
    duration_controller.dispose();
    availble_qty_controller.dispose();
    avilable_aviso_controller.dispose();
    _nodeTextqty.dispose();
    _nodeTextduration.dispose();
    _nodeTextavailbleqty.dispose();
    _nodeTextnamuberaviso.dispose();*/
    super.dispose();
  }

  void boolType(flag, type) {
    log("$flag $type", name: "Boo type");
    if (type == "smoker") {
      smoker = flag;
    } else if (type == 'Physical_activity') {
      physical_activity = flag;
    } else if (type == "FOOD_INTOLERANCE") {
      food_intolerance = flag;
    } else if (type == "DIABETES") {
      diabetes = flag;
    } else if (type == "HYPERTENSION") {
      hypertension = flag;
    } else if (type == "ANIMALS") {
      animal = flag;
    } else if (type == "CHILDREN") {
      children = flag;
    } else if (type == "Pathologies") {
      family_history_inserted = flag;
    }
    setState(() {});
  }

  Widget _Appbar(type) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      leadingWidth: 80,
      //Therapies
      title: Text(
        type,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: ref.read(flavorProvider).primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Poppins'),
      ),

      iconTheme: IconThemeData(color: ref.read(flavorProvider).primary),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios_outlined,
              size: 18,
              color: AppColors.darkGrey,
            ),
            Text(
              translate(context, "back"),
              style: TextStyle(color: AppColors.darkGrey, fontSize: 11.0.sp),
            )
          ],
        ),
      ),
      actions: [],
    );
  }

  Widget _height() {
    return Container(
      width: 50.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 0,
      ),
      child: TextFormField(
        controller: controller_height,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(6),
          /*      ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        // Only numbers can be entered
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "HEIGHT"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

// glycemia: "100",
  // max_pressure: "100",
  // min_pressure: "100",
  // bpm: "100",
  // lipidprofile: "200",
  // cholesterol: "70",
  // lipidprofile2: "100"

  Widget _glycemia() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          /* ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_glycemia,

        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "glycemia"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _maxPressure() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          /*       ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_max_pressure,
        textAlign: TextAlign.start,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        decoration: InputDecoration(
          labelText: translate(context, "MAX_PRESSURE"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _minPressure() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          /*         ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_min_pressure,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "MINIMUM_PRESSURE"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _cholesterol() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          /*   ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_cholesterol,

        textAlign: TextAlign.start,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        decoration: InputDecoration(
          labelText: translate(context, "CHOLESTROL"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _bpm() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          /*    ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_bpm,

        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "BPM"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _lipidprofile() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
/*          ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_lipidprofile,

        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "lipid_profile"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _lipidprofile2() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          /*    ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_lipidprofile2,

        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "lipid_profile2"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _temprature() {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        controller: controller_tempreture,
        textAlign: TextAlign.start,

        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        inputFormatters: <TextInputFormatter>[
          // FilteringTextInputFormatter.digitsOnly,

          LengthLimitingTextInputFormatter(6),
          /*     ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        decoration: InputDecoration(
          labelText: translate(context, "TEMPERATURE"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _width() {
    return Container(
      width: 50.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 0,
      ),
      child: TextFormField(
        controller: controller_weigth,

        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(6),
          /*       ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "WEIGHT"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _genericpressure() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
/*          ValidatorInputFormatter(
              editingValidator: DecimalNumberEditingRegexValidator())*/
        ],
        controller: controller_pressure,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "GENERIC_PRESSURE"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _smoker() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        controller: controller_smoker,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              smoker = v;
            } else {
              smoker = "-";
              controller_smoker.text = "-";
            }
          });
        },
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "SMOKER"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                smoker = v ? "Y" : "N";
              });

              if (!v) {
                setState(() {
                  controller_smoker.text = "-";
                });
              }
            },
            value:
                smoker == null || smoker == "N" || smoker == "" || smoker == "-"
                    ? false
                    : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
          /* SwitchWidget(
            type: "smoker",
            controll: smoker,
            onSelect: boolType,
          ),*/
        ),
      ),
    );
  }

  Widget _Physicalactivity() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        controller: controller_physical_activity,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              physical_activity = v;
            } else {
              physical_activity = "-";
              controller_physical_activity.text = "-";
            }
          });
        },
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "Physical_activity"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                physical_activity = v ? "Y" : "N";
              });

              if (!v) {
                setState(() {
                  controller_physical_activity.text = "-";
                });
              }
            },
            value: physical_activity == null ||
                    physical_activity == "N" ||
                    physical_activity == "" ||
                    physical_activity == "-"
                ? false
                : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _Pathologies() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        controller: controller_family_history_inserted,
        textAlign: TextAlign.start,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              family_history_inserted = v;
            } else {
              family_history_inserted = "-";
              controller_family_history_inserted.text = "-";
            }
          });
        },
        decoration: InputDecoration(
          labelText: translate(context, "Pathologies"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                family_history_inserted = v ? "Y" : "N";
                // controller_family_history_inserted.text = v ? "SI" : "NO";
              });

              if (!v) {
                setState(() {
                  controller_family_history_inserted.text = "-";
                });
              }
            },
            value: family_history_inserted == null ||
                    family_history_inserted == "N" ||
                    family_history_inserted == "" ||
                    family_history_inserted == "-"
                ? false
                : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _Children() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        controller: controller_children,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              children = v;
            } else {
              children = "-";
              controller_children.text = "-";
            }
          });
        },
        textAlign: TextAlign.start,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        decoration: InputDecoration(
          labelText: translate(context, "CHILDREN"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                children = v ? "Y" : "N";
                // controller_children.text = v ? "SI" : "NO";
              });

              if (!v) {
                setState(() {
                  controller_children.text = "-";
                });
              }
            },
            value: children == null ||
                    children == "N" ||
                    children == "" ||
                    children == "-"
                ? false
                : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _Animals() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        controller: controller_animal,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: true),
        //focusNode: _nodeTextnamuberaviso,
        textAlign: TextAlign.start,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              animal = v;
            } else {
              animal = "-";
              controller_animal.text = "-";
            }
          });
        },
        decoration: InputDecoration(
          labelText: translate(context, "ANIMALS"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                animal = v ? "Y" : "N";
                // controller_animal.text = v ? "SI" : "NO";
              });
              if (!v) {
                setState(() {
                  controller_animal.text = "-";
                });
              }
            },
            value:
                animal == null || animal == "N" || animal == "" || animal == "-"
                    ? false
                    : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _HYPERTENSION() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        controller: controller_hypertension,
        textAlign: TextAlign.start,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              hypertension = v;
            } else {
              hypertension = "-";
              controller_hypertension.text = "-";
            }
          });
        },
        decoration: InputDecoration(
          labelText: translate(context, "HYPERTENSION"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                hypertension = v ? "Y" : "N";
                // controller_hypertension.text = v ? "SI" : "NO";
              });

              if (!v) {
                setState(() {
                  controller_hypertension.text = "-";
                });
              }
            },
            value: hypertension == null ||
                    hypertension == "N" ||
                    hypertension == "" ||
                    hypertension == "-"
                ? false
                : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _DIABETES() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        textAlign: TextAlign.start,
        controller: controller_diabetes,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              diabetes = v;
            } else {
              diabetes = "-";
              controller_diabetes.text = "-";
            }
          });
        },
        decoration: InputDecoration(
          labelText: translate(context, "DIABETES"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                diabetes = v ? "Y" : "N";
                // controller_diabetes.text = v ? "SI" : "NO";
              });

              if (!v) {
                setState(() {
                  controller_diabetes.text = "-";
                });
              }
            },
            value: diabetes == null ||
                    diabetes == "N" ||
                    diabetes == "" ||
                    diabetes == "-"
                ? false
                : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _Allergies() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(40),
        ],
        controller: controller_allergies,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: translate(context, "ALLERGIES"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        ),
      ),
    );
  }

  Widget _FOODiNTOLERANCE() {
    return Container(
      width: 95.0.w,
      padding: const EdgeInsets.only(
        left: 10,
        top: 8,
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        textAlign: TextAlign.start,
        controller: controller_food_intolerence,
        onChanged: (v) {
          setState(() {
            if (v.length > 0) {
              food_intolerance = v;
            } else {
              food_intolerance = "-";
              controller_food_intolerence.text = "-";
            }
          });
        },
        decoration: InputDecoration(
          labelText: translate(context, "FOOD_INTOLERANCE"),
          contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          suffixIcon: Switch(
            onChanged: (v) {
              setState(() {
                food_intolerance = v ? "Y" : "N";
                // controller_food_intolerence.text = v
                //     ? "SI"
                //     : "NO";
              });

              if (!v) {
                setState(() {
                  controller_food_intolerence.text = "-";
                });
              }
            },
            value: food_intolerance == null ||
                    food_intolerance == "N" ||
                    food_intolerance == "" ||
                    food_intolerance == "-"
                ? false
                : true,
            activeColor: Colors.white,
            activeTrackColor: ref.read(flavorProvider).lightPrimary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _additionalbox() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(translate(context, "add_notes_health"),
                      style: AppTheme.h2Style.copyWith(
                          color: AppColors.darkGrey, fontSize: 12.0.sp)),
                ],
              ),
            ),
            SizedBox(
              height: 15.0.h,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(width: 1, color: AppColors.grey)),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                cursorColor: AppColors.black,
                                controller: controller_additional_comments,
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

  validation() {
    if (widget.type == "edit") {
      setState(() {
        loading = true;
        EditData(
            height: controller_height.text,
            weight: controller_weigth.text,
            pressure: controller_pressure.text,
            smoker: smoker,
            physical_activity: physical_activity,
            family_history_inserted: family_history_inserted,
            children: children,
            animal: animal,
            hypertension: hypertension,
            diabetes: diabetes,
            allergies: controller_allergies.text,
            food_intolerance: food_intolerance,
            tempreture: controller_tempreture.text,
            additional_comment: controller_additional_comments.text,
            free_text_with_other_parthlogic: false,
            hypercholesterolemia: false,
            glycemia: controller_glycemia.text,
            max_pressure: controller_max_pressure.text,
            min_pressure: controller_min_pressure.text,
            bpm: controller_bpm.text,
            lipidprofile: controller_lipidprofile.text,
            cholesterol: controller_cholesterol.text,
            lipidprofile2: controller_lipidprofile2.text);
      });
    } else {
      addHealthData(
          height: controller_height.text,
          weight: controller_weigth.text,
          pressure: controller_pressure.text,
          smoker: smoker,
          physical_activity: physical_activity,
          family_history_inserted: family_history_inserted,
          children: children,
          animal: animal,
          hypertension: hypertension,
          diabetes: diabetes,
          allergies: controller_allergies.text,
          food_intolerance: food_intolerance,
          tempreture: controller_tempreture.text,
          additional_comment: controller_additional_comments.text,
          free_text_with_other_parthlogic: false,
          hypercholesterolemia: false,
          glycemia: controller_glycemia.text,
          max_pressure: controller_max_pressure.text,
          min_pressure: controller_min_pressure.text,
          bpm: controller_bpm.text,
          lipidprofile: controller_lipidprofile.text,
          cholesterol: controller_cholesterol.text,
          lipidprofile2: controller_lipidprofile2.text);
      // addHealthChartData();

    }
    //}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
              title: Text(
            widget.type == "add"
                ? translate(context, "add")
                : translate(context, "edit"),
          )),
          body: Builder(
              builder: (BuildContext context) => Container(
                  child: loading
                      ? const SizedBox()
                      : SizedBox(
                          height: double.infinity,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 0, right: 10, left: 10),
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: SingleChildScrollView(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Column(children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(flex: 5, child: _height()),
                                            Expanded(flex: 5, child: _width())
                                          ],
                                        ),
                                        _temprature(),
                                        _bpm(),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 5, child: _cholesterol()),
                                            Expanded(
                                                flex: 5, child: _glycemia())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: _lipidprofile()),
                                            Expanded(
                                                flex: 5,
                                                child: _lipidprofile2())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 5, child: _maxPressure()),
                                            Expanded(
                                                flex: 5, child: _minPressure())
                                          ],
                                        ),
                                        _genericpressure(),
                                        _smoker(),
                                        _Physicalactivity(),
                                        _Pathologies(),
                                        _Children(),
                                        _Animals(),
                                        _HYPERTENSION(),
                                        _DIABETES(),
                                        _Allergies(),
                                        _FOODiNTOLERANCE(),
                                        _additionalbox(),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        StandardButton(
                                          text: translate(
                                              context, "save_changes"),
                                          onTap: () {
                                            //todo editHealthChart
                                            // PreferenceUtils.setBool("smoker", smoker);
                                            // PreferenceUtils.setBool("Physical_activity", physical_activity);
                                            // PreferenceUtils.setBool("Pathologies", family_history_inserted);
                                            // PreferenceUtils.setBool("children", children);
                                            // PreferenceUtils.setBool("animal", animal);
                                            // PreferenceUtils.setBool("hypertension", hypertension);
                                            // PreferenceUtils.setBool("diabetes", diabetes);
                                            // PreferenceUtils.setBool("food_intolerance", food_intolerance);

                                            validation();
                                          },
                                          //TODO fix
                                          /*   text: translate(
                                              context, "save_changes"),*/
                                        ),
                                        const SizedBox(
                                          height: 64,
                                        ),
                                      ])
                                    ])),
                              ))))),
        ));
  }

  EditData(
      {String? height,
      String? weight,
      var food_intolerance,
      var smoker,
      var physical_activity,
      var family_history_inserted,
      var children,
      var animal,
      var hypertension,
      var diabetes,
      var hypercholesterolemia,
      String? allergies,
      String? pressure,
      var free_text_with_other_parthlogic,
      String? additional_comment,
      String? tempreture,
      String? glycemia,
      String? max_pressure,
      String? min_pressure,
      String? bpm,
      String? lipidprofile,
      String? lipidprofile2,
      String? cholesterol}) async {
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

        if (height != null) {
          height = height?.replaceAll(",", ".");
        }

        if (weight != null) {
          weight = weight?.replaceAll(",", ".");
        }

        if (tempreture != null) {
          tempreture = tempreture?.replaceAll(",", ".");
        }

        if (bpm != null) {
          bpm = bpm?.replaceAll(",", ".");
        }

        if (glycemia != null) {
          glycemia = glycemia?.replaceAll(",", ".");
        }

        if (lipidprofile != null) {
          lipidprofile = lipidprofile?.replaceAll(",", ".");
        }

        if (lipidprofile2 != null) {
          lipidprofile2 = lipidprofile2?.replaceAll(",", ".");
        }

        if (max_pressure != null) {
          max_pressure = max_pressure?.replaceAll(",", ".");
        }

        if (min_pressure != null) {
          min_pressure = min_pressure?.replaceAll(",", ".");
        }

        if (cholesterol != null) {
          cholesterol = cholesterol?.replaceAll(",", ".");
        }

        // var dataToBesent = enc.encode({
        //   '"user_id" : "${PreferenceUtils.getInt("user_id").toString()}","user_device_id":"${PreferenceUtils.getString("user_device_id").toString()}","access_token":"${PreferenceUtils.getString("accesstoken").toString()}","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}","height":"${height}","weight":"${weight}","pressure":"${pressure}","smoker":"${smoker? "Y" : "N"}","physical_activity":"${physical_activity ? "daily" : "monthly"}","family_history_inserted":"${family_history_inserted ? "Y" : "N"}","children":"${children ? "Y" : "N"}","animal":"${animal ? "Y" : "N"}","hypertension":"${hypertension ? "Y" : "N"}","diabetes":"${diabetes ? "Y" : "N"}","allergies":"${allergies}","food_intolerance":"${food_intolerance ? "Y" : "N"}","free_text_with_other_parthlogic":"${free_text_with_other_parthlogic ? "Y" : "N"}","hypercholesterolemia":"${hypercholesterolemia ? "Y" : "N"}" ,"additional_comment":"${additional_comment.trim()}" ,"temprature":"${tempreture}","bpm":"${bpm}","glycemia":"${glycemia}","max_pressure":"${max_pressure}","min_pressure":"${min_pressure}","colestorl":"${cholesterol}","lipid_profile":"${lipidprofile}","lipid_profile2":"${lipidprofile2}"'
        // });

        // var dataToBesent = enc.encode({
        //   '"user_id" : "${PreferenceUtils.getInt("user_id").toString()}","user_device_id":"${PreferenceUtils.getString("user_device_id").toString()}","access_token":"${PreferenceUtils.getString("accesstoken").toString()}","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}","height":"${height}","weight":"${weight}","pressure":"${pressure}","smoker":"${smoker}","physical_activity":"${controller_physical_activity.text.isEmpty ? "-" : controller_physical_activity.text}","family_history_inserted":"${family_history_inserted}","children":"${controller_children.text.isEmpty ? "-" : controller_children.text}","animal":"${animal}","hypertension":"${hypertension}","diabetes":"${diabetes}","allergies":"${allergies.isEmpty ? "-" : allergies}","food_intolerance":"${food_intolerance}","free_text_with_other_parthlogic":"${free_text_with_other_parthlogic}","hypercholesterolemia":"${hypercholesterolemia}" ,"additional_comment":"${additional_comment.trim()}" ,"temprature":"${tempreture}","bpm":"${bpm}","glycemia":"${glycemia}","max_pressure":"${max_pressure}","min_pressure":"${min_pressure}","colestorl":"${cholesterol}","lipid_profile":"${lipidprofile}","lipid_profile2":"${lipidprofile2}"'
        // });

        //TODO fix

        try {
          Dio dio = Dio();

          dio
              .post(
            Constant.edithealth,
            data: ({
              "user_id": ref.read(authProvider).user?.userId,
              //"user_id": "1394",
              "user_device_id": "",
              "access_token": "",
              "pharmacy_id": ref.read(flavorProvider).pharmacyId,
              "height": "$height",
              "weight": "$weight",
              "pressure": "$pressure",
              "smoker": controller_smoker.text,
              "physical_activity": controller_physical_activity.text,
              "family_history_inserted":
                  controller_family_history_inserted.text,
              "children": controller_children.text,
              "animal": controller_animal.text,
              "hypertension": controller_hypertension.text,
              "diabetes": controller_diabetes.text,
              "allergies": "$allergies",
              "food_intolerance": controller_food_intolerence.text,
              "free_text_with_other_parthlogic":
                  "$free_text_with_other_parthlogic",
              "hypercholesterolemia": controller_hypercholesterolemia.text,
              "additional_comment": "${additional_comment?.trim()}",
              "temprature": "$tempreture",
              "bpm": "$bpm",
              "glycemia": "$glycemia",
              "max_pressure": "$max_pressure",
              "min_pressure": "$min_pressure",
              "colestorl": "$cholesterol",
              "lipid_profile": "$lipidprofile",
              "lipid_profile2": "$lipidprofile2"
            }),
          )
              .then((value) async {
            var temp = json.decode((value.toString()));
            print("this is from edit health data api$temp");
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                //Navigator.pushNamed(context, HealthFolderDetail.routeName);
                setState(() {
                  //therapiList = temp['upcoming_drug'];
                  loading = false;
                });

                Navigator.pop(context);
              } else if (temp['code'] == 201) {
                //Navigator.pushNamed(context, HealthFolderDetail.routeName);
                setState(() {
                  //therapiList = temp['upcoming_drug'];
                  loading = false;
                });

                Navigator.pop(context);
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

  addHealthData(
      {String? height,
      String? weight,
      var food_intolerance,
      var smoker,
      var physical_activity,
      var family_history_inserted,
      var children,
      var animal,
      var hypertension,
      var diabetes,
      var hypercholesterolemia,
      String? allergies,
      String? pressure,
      var free_text_with_other_parthlogic,
      String? additional_comment,
      String? tempreture,
      String? glycemia,
      String? max_pressure,
      String? min_pressure,
      String? bpm,
      String? lipidprofile,
      String? lipidprofile2,
      String? cholesterol}) {
    setState(() {
      loading = true;
    });
    if (height != null) {
      height = height.replaceAll(",", ".");
    }

    if (weight != null) {
      weight = weight.replaceAll(",", ".");
    }

    if (tempreture != null) {
      tempreture = tempreture.replaceAll(",", ".");
    }

    if (bpm != null) {
      bpm = bpm.replaceAll(",", ".");
    }

    if (glycemia != null) {
      glycemia = glycemia.replaceAll(",", ".");
    }

    if (lipidprofile != null) {
      lipidprofile = lipidprofile.replaceAll(",", ".");
    }

    if (lipidprofile2 != null) {
      lipidprofile2 = lipidprofile2.replaceAll(",", ".");
    }

    if (max_pressure != null) {
      max_pressure = max_pressure.replaceAll(",", ".");
    }

    if (min_pressure != null) {
      min_pressure = min_pressure.replaceAll(",", ".");
    }

    if (cholesterol != null) {
      cholesterol = cholesterol.replaceAll(",", ".");
    }

    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          loading = true;
        });

        // var dataToBesent = enc.encode({
        //   '"user_id" : "${PreferenceUtils.getInt("user_id").toString()}","user_device_id":"${PreferenceUtils.getString("user_device_id").toString()}","access_token":"${PreferenceUtils.getString("accesstoken").toString()}","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}","height":"${controller_height.text}","weight":"${controller_weigth.text}","pressure":"${controller_pressure.text}","smoker":"${smoker ? "Y" : "N"}","physical_activity":"${physical_activity ? "daily" : "monthly"}","family_history_inserted":"${family_history_inserted ? "Y" : "N"}","children":"${children ? "Y" : "N"}","animal":"${animal ? "Y" : "N"}","hypertension":"${hypertension ? "Y" : "N"}","diabetes":"${diabetes ? "Y" : "N"}","allergies":"${controller_allergies.text}","food_intolerance":"${food_intolerance ? "Y" : "N"}","free_text_with_other_parthlogic":"${free_text_with_other_parthlogic ? "Y" : "N"}","hypercholesterolemia":"${hypercholesterolemia ? "Y" : "N"}" ,"additional_comment":"${controller_additional_comments.text}" ,"temprature":"${controller_tempreture.text}","bpm":"${controller_bpm.text}","glycemia":"${controller_glycemia.text}","max_pressure":"${controller_max_pressure.text}","min_pressure":"${controller_min_pressure.text}","colestorl":"${controller_cholesterol.text}","lipid_profile":"${controller_lipidprofile.text}","lipid_profile2":"${controller_lipidprofile2.text}"'
        // });

        try {
          Dio dio = Dio();

          dio
              .post(Constant.addHealth,
                  data: ({
                    "user_id": ref.read(authProvider).user?.userId,
                    "user_device_id": "",
                    "access_token": "",
                    "pharmacy_id": ref.read(flavorProvider).pharmacyId,
                    "height": "$height",
                    "weight": "$weight",
                    "pressure": "$pressure",
                    "smoker": "$smoker",
                    "physical_activity": controller_physical_activity.text,
                    "family_history_inserted":
                        controller_family_history_inserted.text,
                    "children": controller_children.text,
                    "animal": controller_animal.text,
                    "hypertension": controller_hypertension.text,
                    "diabetes": controller_diabetes.text,
                    "allergies": "$allergies",
                    "food_intolerance": controller_food_intolerence.text,
                    "free_text_with_other_parthlogic":
                        "$free_text_with_other_parthlogic",
                    "hypercholesterolemia":
                        controller_hypercholesterolemia.text,
                    "additional_comment": "${additional_comment?.trim()}",
                    "temprature": "$tempreture",
                    "bpm": "$bpm",
                    "glycemia": "$glycemia",
                    "max_pressure": "$max_pressure",
                    "min_pressure": "$min_pressure",
                    "colestorl": "$cholesterol",
                    "lipid_profile": "$lipidprofile",
                    "lipid_profile2": "$lipidprofile2"
                  }))
              .then((value) async {
            var temp = value as Map<String, dynamic>;
            print("this is from addhealth data api $temp");
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                setState(() {
                  //therapiList = temp['upcoming_drug'];
                  loading = false;
                });
                Navigator.pop(context, true);
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

  addHealthChartData() {
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

        try {
          Dio dio = Dio();

          dio
              .post(Constant.addHealthChart,
                  data: ({
                    "user_id": ref.read(authProvider).user?.userId,
                    "user_device_id": "",
                    "access_token": "",
                    "pharmacy_id": ref.read(flavorProvider).pharmacyId,
                    "height": controller_height.text,
                    "weight": controller_weigth.text,
                    "pressure": controller_pressure.text,
                    "smoker": controller_smoker.text,
                    "physical_activity":
                        physical_activity ? "daily" : "monthly",
                    "family_history_inserted":
                        family_history_inserted ? "Y" : "N",
                    "children": children ? "Y" : "N",
                    "animal": animal ? "Y" : "N",
                    "hypertension": hypertension ? "Y" : "N",
                    "diabetes": diabetes ? "Y" : "N",
                    "allergies": controller_allergies.text,
                    "food_intolerance": food_intolerance ? "Y" : "N",
                    "free_text_with_other_parthlogic":
                        free_text_with_other_parthlogic ? "Y" : "N",
                    "hypercholesterolemia": hypercholesterolemia ? "Y" : "N",
                    "additional_comment": controller_additional_comments.text,
                    "temprature": "96",
                    "bpm": "100",
                    "glycemia": "100",
                    "max_pressure": "100",
                    "min_pressure": "100",
                    "colestorl": "100",
                    "lipid_profile": "100",
                    "lipid_profile2": "100"
                  }))
              .then((value) async {
            var temp = value as Map<String, dynamic>;
            print("this is from addhealthchart dta api $temp");
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                //Navigator.pushNamed(context, HealthFolder.routeName);
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
