import 'dart:convert';
import 'dart:developer';

import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/health_folder/Edit_health_folder_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../config/EncodeDecode.dart';
import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../config/preference_utils.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';
import '../../custom_widgets/no_user.dart';

class HealthFolderHealthProfileTab extends ConsumerStatefulWidget {
  static String routeName = "/HealthFolderDetail";
  late int index;

  HealthFolderHealthProfileTab({Key? key}) : super(key: key);

  @override
  _HealthFolderHealthProfileTabState createState() =>
      _HealthFolderHealthProfileTabState();
}

class _HealthFolderHealthProfileTabState
    extends ConsumerState<HealthFolderHealthProfileTab> {
  var healthData = {};
  bool loading = false;

  String height = "", Weight = "";
  String edit = "edit";
  var smoker;
  var physical_activity;
  var family_history_inserted;
  var children;
  var animal;
  var hypertension;
  var diabetes;
  var food_intolerance;
  var free_text_with_other_parthlogic;
  var hypercholesterolemia;

  List<Widget> _list = [];

  static List<T> map<T>({required List list, required Function handler}) {
    List<T> result = [];

    int lengthToDisplay = list.length;
    // > 5 && !needToShowAllData ? 5 : list.length;

    if (list.isNotEmpty) {
      for (var i = 0; i < lengthToDisplay; i++) {
        result.add(handler(i, list[i]));
      }
    }
    return result;
  }

  //TODO ripristinare

/*

  void addWidget(DataType type, List<FitData> data) {
    int total = 0;

    for (FitData datasw in data) {
      total += datasw.value.toInt();
    }

    Widget widget = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('DataType -  $type'),
        Text('Total Value  - $total')

        // type == "DataType.HEIGHT" ? Text('DataType -  $type '): SizedBox(),
        // type == "DataType.HEIGHT" ?Text('Total Value - $total ') :SizedBox(),
        // type =="DataType.WEIGHT" ?Text('DataType -  $type '): SizedBox(),
        // type =="DataType.WEIGHT" ?Text('Total Value  - $total ') :SizedBox(),
      ],
    );

    setState(() {
      _list.add(widget);
    });
  }
*/

/*
  static String getBaseUnit(DataType type) {
    switch (type) {
      case DataType.HEART_RATE:
        return 'count/min';
      case DataType.STEP_COUNT:
        return '';
      case DataType.HEIGHT:
        // return 'meter';
        return 'centimeter';
      case DataType.WEIGHT:
        return 'kg';
      case DataType.DISTANCE:
        return 'meter';
      case DataType.ENERGY:
        return 'kilocalorie';
      case DataType.WATER:
        return 'litre';
      case DataType.SLEEP:
        return 'Sleep';
      default:
        return 'UnKnown';
    }
  }
*/

  //TODO deprecare
/*
  void readData() async {
    double tempHeight;
    var tempWeight;
    var results;

    // FitKit.revokePermissions();

    bool permissionsGiven = await readPermissions();
    log("${permissionsGiven}");
    if (permissionsGiven) {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      // dateFrom = current.subtract(Duration(
      //   hours: current.hour,
      //   minutes: current.minute,
      //   seconds: current.second,
      // ));
      dateTo = DateTime.now();
      setState(() {
        loading = true;
      });

      for (DataType type in DataType.values) {
        log("Name ${type}");
        try {
          results = await FitKit.readLast(
            type,
            // dateFrom: DateTime(dateTo.year, 01, 01),
            // dateTo: dateTo,
          );
          log('$results');
          if (results != null) {
            if (type.toString().contains("DataType.HEIGHT")) {
              log(results.toString(), name: "------Last----");

              if (results.value != null) {
                tempHeight = results.value.toDouble() * 100;
                log("${tempHeight}");
                // tempHeight = tempHeight*0.393701;
              }
              // print("--------------datavHeightalue------------"+datasw.value);
              log("--------------datavHeightalue------------" +
                  tempHeight.toString());

              height = tempHeight.toStringAsFixed(2).toString();
            }
            if (type.toString().contains("DataType.WEIGHT")) {
              tempWeight = results.value.toDouble();
              // print("--------------datavHeightalue------------"+datasw.value);
              print("--------------datavWEIGHTtalue------------" +
                  tempWeight.toString());

              Weight = tempWeight.toString();
            }
            log("Result data-------" + results.toString());
          } else {
            setState(() {
              loading = false;
            });
          }
          // log(type.toString() + "-------Type of data----");

          int total = 0;



        } on Exception catch (ex) {
          log("$ex", name: "Exception");
        }
      }
      // setState(() {

      // if(results)

      if (height != null || widget != null) {
        EditData(
            height: height.toString() ?? "-",
            weight: Weight.toString() ?? "-",
            pressure: "${healthData['bpm'] ?? "-"}",
            smoker: smoker,
            physical_activity: physical_activity,
            family_history_inserted: family_history_inserted,
            children: children,
            hypertension: hypertension,
            diabetes: diabetes,
            allergies: "${healthData['allergies'] ?? "-"}",
            food_intolerance: food_intolerance,
            tempreture: "${healthData['temprature'] ?? "-"}",
            additional_comment: "${healthData['additional_comment'] ?? "-"}",
            free_text_with_other_parthlogic: free_text_with_other_parthlogic,
            hypercholesterolemia: hypercholesterolemia,
            glycemia: "${healthData['glycemia'] ?? "-"}",
            max_pressure: "${healthData['max_pressure'] ?? "-"}",
            min_pressure: "${healthData['min_pressure'] ?? "-"}",
            bpm: "${healthData['bpm'] ?? "-"}",
            lipidprofile: "${healthData['lipid_profile'] ?? "-"}",
            cholesterol: "${healthData['colestorl'] ?? "-"}",
            lipidprofile2: "${healthData['lipid_ profile2'] ?? "-"}");
      } else {
        setState(() {
          loading = false;
        });
      }
      // });
    } else {
      FitKit.revokePermissions();
    }
  }
*/

  //TODO fix
  EditData(
      {String? height,
      String? weight,
      var food_intolerance,
      var smoker,
      var physical_activity,
      var family_history_inserted,
      var children,
      // var animal,
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

        EncodeDecode enc = EncodeDecode();

        var dataToBesent = enc.encode({
          '"user_id" : "${PreferenceUtils.getInt("user_id").toString()}","user_device_id":"${PreferenceUtils.getString("user_device_id").toString()}","access_token":"${PreferenceUtils.getString("accesstoken").toString()}","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}","height":"$height","weight":"$weight","pressure":"$pressure","smoker":"$smoker","physical_activity":"$physical_activity","family_history_inserted":"$family_history_inserted","children":"$children","hypertension":"$hypertension","diabetes":"$diabetes","allergies":"$allergies","food_intolerance":"$food_intolerance","free_text_with_other_parthlogic":"$free_text_with_other_parthlogic","hypercholesterolemia":"$hypercholesterolemia" ,"additional_comment":"${additional_comment?.trim()}" ,"temprature":"$tempreture","bpm":"$bpm","glycemia":"$glycemia","max_pressure":"$max_pressure","min_pressure":"$min_pressure","colestorl":"$cholesterol","lipid_profile":"$lipidprofile","lipid_profile2":"$lipidprofile2"'
        });
        log("this is from edit health data api$dataToBesent");

        try {
          Dio dio = Dio();
          dio
              .post(
            edit == "add" ? Constant.addHealth : Constant.edithealth,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = json.decode(enc.decode(value.toString()));
            print("this is from edit health data api$temp");
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                // Navigator.pushNamed(context, HealthFolderDetail.routeName);
                setState(() {
                  //therapiList = temp['upcoming_drug'];
                  loading = false;
                });
                fetchHealthData();

                // Navigator.pop(context,);
                setState(() {});
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

  //TODO DEPRECARE
/*
  Future<bool> readPermissions() async {
    try {
      final responses = await FitKit.hasPermissions([
        DataType.HEART_RATE,
        DataType.STEP_COUNT,
        DataType.HEIGHT,
        DataType.WEIGHT,
        DataType.DISTANCE,
        DataType.ENERGY,
        DataType.WATER,
        DataType.SLEEP,
        DataType.STAND_TIME,
        DataType.EXERCISE_TIME,
      ]);

      if (!responses) {
        final value = await FitKit.requestPermissions([
          DataType.HEART_RATE,
          DataType.STEP_COUNT,
          DataType.HEIGHT,
          DataType.WEIGHT,
          DataType.DISTANCE,
          DataType.ENERGY,
          DataType.WATER,
          DataType.SLEEP,
          DataType.STAND_TIME,
          DataType.EXERCISE_TIME,
        ]);
        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
      return false;
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    Widget _datatable() {
      return Container(
        color: AppColors.white,
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translate(context, "general_information"),
                              style: AppTheme.h6Style.copyWith(
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.w600)),
                          Text(translate(context, "general_information_des"),
                              style: AppTheme.bodyText.copyWith(
                                  color: AppColors.lightGrey,
                                  fontSize: 11.0.sp)),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Image.asset(ic_edit_primary),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    //TODO ripristinare
                                    EditHealthFolder(healthData, edit),
                              )).then((value) => setState(() {
                                fetchHealthData();
                              }));
                        })
                  ]),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(children: <Widget>[
              Container(
                color: AppColors.white,
                margin: const EdgeInsets.all(5),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(8),
                    1: FlexColumnWidth(4),
                  },
                  border: const TableBorder(
                      bottom: BorderSide(color: AppColors.grey),
                      horizontalInside: BorderSide(color: AppColors.grey)),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "height"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['height'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Weight"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['weight'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Temprature"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['temprature'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "CHOLESTROL_small"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['colestorl'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "GLICEMIA_small"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['glycemia'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "lipid_profile_small"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['lipid_profile'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "lipid_profile2_small"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['lipid_profile2'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "max_pressure"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['max_pressure'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "min_pressure"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${healthData['min_pressure'] ?? "-"}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Pressure"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${healthData['bpm'] ?? "-"}",
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.black),
                              )
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Physical_Activity"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  healthData['physical_activity'] == null ||
                                          healthData['physical_activity'] ==
                                              "" ||
                                          healthData['physical_activity']
                                                  .toString() ==
                                              "null"
                                      ? "-"
                                      : "${healthData['physical_activity']}",
                                  maxLines: 1,
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "SMOKER_small"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  healthData['smoker'] == null ||
                                          healthData['smoker'] == "" ||
                                          healthData['smoker'].toString() ==
                                              "null"
                                      ? "-"
                                      : "${healthData['smoker']}",
                                  maxLines: 1,
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Pathologies_FAMIGLIA"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // '${healthData['family_history_inserted'] ?? "-"}',
                                // " ${healthData['family_history_inserted'] == null || healthData['family_history_inserted'] == "" ? "-" : "${healthData['family_history_inserted']}" == "Y" ? "${translate(context, "yes")}" : "${healthData['family_history_inserted']}" == "N" ? "${translate(context, "no")}" : "-"}",
                                healthData['family_history_inserted'] == null ||
                                        healthData['family_history_inserted'] ==
                                            "" ||
                                        healthData['family_history_inserted']
                                                .toString() ==
                                            "null"
                                    ? "-"
                                    : "${healthData['family_history_inserted']}",
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.black),
                              )
                            ]),
                      ),
                    ]),

                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Children"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  // '${healthData['children'] ?? "-"}',
                                  healthData['children'] == null ||
                                          healthData['children'] == "" ||
                                          healthData['children'].toString() ==
                                              "null"
                                      ? "-"
                                      : "${healthData['children']}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),

                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Animals"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // '${healthData['animal'] ?? "-"}',
                                // '${healthData['animal'] == null || healthData['animal'] == "" ? "-" : "${healthData['animal']}" == "Y" ? "${translate(context, "yes")}" : "${healthData['animal']}" == "N" ? "${translate(context, "no")}" : "-"}',
                                healthData['animal'] == null ||
                                        healthData['animal'] == "" ||
                                        healthData['animal'].toString() ==
                                            "null"
                                    ? "-"
                                    : "${healthData['animal']}",
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.black),
                              )
                            ]),
                      ),
                    ]),

                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Hypertension"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // '${healthData['hypertension'] ?? "-"}',
                                // '${healthData['hypertension'] == null || healthData['hypertension'] == "" ? "-" : "${healthData['hypertension']}" == "Y" ? "${translate(context, "yes")}" : "${healthData['hypertension']}" == "N" ? "${translate(context, "no")}" : "-"}',
                                healthData['hypertension'] == null ||
                                        healthData['hypertension'] == "" ||
                                        healthData['hypertension'].toString() ==
                                            "null"
                                    ? "-"
                                    : "${healthData['hypertension']}",
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.black),
                              )
                            ]),
                      ),
                    ]),

                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Diabetes"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // '${healthData['diabetes'] ?? "-"}',
                                // '${healthData['diabetes'] == null || healthData['diabetes'] == "" ? "-" : "${healthData['diabetes']}" == "Y" ? "${translate(context, "yes")}" : "${healthData['diabetes']}" == "N" ? "${translate(context, "no")}" : "-"}',
                                healthData['diabetes'] == null ||
                                        healthData['diabetes'] == "" ||
                                        healthData['diabetes'].toString() ==
                                            "null"
                                    ? "-"
                                    : "${healthData['diabetes']}",
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.black),
                              )
                            ]),
                      ),
                    ]),

                    // TableRow(children: [
                    //   Padding(
                    //     padding: const EdgeInsets.all(6.0),
                    //     child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //               "${translate(context, "Hypercholestreolemia")}",
                    //               style: AppTheme.bodyText.copyWith(
                    //                   color: ref.read(flavorProvider).primary,
                    //                   fontWeight: FontWeight.w600)),
                    //         ]),
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.all(6.0),
                    //     child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             // '${healthData['hypercholesterolemia'] ?? "-"}',
                    //               '${healthData['hypercholesterolemia']==null || healthData['hypercholesterolemia']=="" ? "-" :"${healthData['hypercholesterolemia']}"=="Y"?"${translate(context, "yes")}":"${healthData['hypercholesterolemia']}"=="N"?"${translate(context, "no")}":"-"}',
                    //               style: AppTheme.bodyText
                    //                   .copyWith(color: AppColors.black))
                    //         ]),
                    //   ),
                    // ]),

                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Allergies"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${healthData['allergies'] ?? "-"}',
                                maxLines: 5,
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.black),
                              )
                            ]),
                      ),
                    ]),

                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translate(context, "Food_intolerances"),
                                  style: AppTheme.bodyText.copyWith(
                                      color: ref.read(flavorProvider).primary,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  // '${healthData['food_intolerance'] ?? "-"}',
                                  // '${healthData['food_intolerance'] == null || healthData['food_intolerance'] == "" ? "-" : "${healthData['food_intolerance']}" == "Y" ? "${translate(context, "yes")}" : "${healthData['food_intolerance']}" == "N" ? "${translate(context, "no")}" : "-"}',
                                  healthData['food_intolerance'] == null ||
                                          healthData['food_intolerance'] ==
                                              "" ||
                                          healthData['food_intolerance']
                                                  .toString() ==
                                              "null"
                                      ? "-"
                                      : "${healthData['food_intolerance']}",
                                  style: AppTheme.bodyText
                                      .copyWith(color: AppColors.black))
                            ]),
                      ),
                    ]),
                    // TableRow(children: [
                    //   Padding(
                    //     padding: const EdgeInsets.all(6.0),
                    //     child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //               "${translate(context, "Free_text_pathologies")}",
                    //               style: AppTheme.bodyText.copyWith(
                    //                   color: ref.read(flavorProvider).primary,
                    //                   fontWeight: FontWeight.w600)),
                    //         ]),
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.all(6.0),
                    //     child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             // '${healthData['free_text_with_other_parthlogic'] ?? "-"}',
                    //               '${healthData['free_text_with_other_parthlogic']==null || healthData['free_text_with_other_parthlogic']=="" ? "-" :"${healthData['free_text_with_other_parthlogic']}"}',
                    //               style: AppTheme.bodyText
                    //                   .copyWith(color: AppColors.black))
                    //         ]),
                    //   ),
                    // ]),
                  ],
                ),
              ),
            ])
          ],
        ),
      );
    }

    Widget _additionalbox() {
      return Container(
        padding:
            const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 20),
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
                            color: AppColors.black, fontSize: 13.0.sp)),
                  ],
                ),
              ),
              Card(
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
                                enabled: false,
                                cursorColor: AppColors.darkGrey,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    hintText:
                                        "${healthData['additional_comment'] ?? translate(context, "add_notes_health_hint")}",
                                    hintStyle: AppTheme.bodyText.copyWith(
                                        color: AppColors
                                            .darkGrey)) /*'Enter any notes regarding the recipe or preferences ..'*/,
                                maxLines: 3,
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.grey)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                color: AppColors.white,
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: loading
              //TODO customloader
              ? Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                )
              : user == null
                  ? const NoUser()
                  : Builder(
                      builder: (BuildContext context) => Container(
                          child: Container(
                              color: AppColors.grey.withOpacity(0.1),
                              height: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 0, right: 0, left: 0),
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: SingleChildScrollView(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                          Container(
                                            child: Column(children: <Widget>[
                                              // _healthInformation(),
                                              _datatable(),
                                              _additionalbox(),
//TODO riprisitinare
                                              /*       RoundCornerGradientButton(
                                        click: () {

                                          readData();
                                        },
                                        text:
                                            translate(context, "sync_health_App"),
                                      ),*/

                                              const SizedBox(
                                                height: 30,
                                              ),
                                              // if (_list.length > 0) ..._list
                                              // _button(),
                                            ]),
                                          )
                                        ])),
                                  ))))),
        ));
  }

  @override
  void initState() {
    super.initState();
    fetchHealthData();
  }

  fetchHealthData() async {
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

          dio.get(
            Constant.health_data,
            //TODO fix
            queryParameters: {
              'user_id': ref.read(authProvider).user?.userId,
              //'user_id': 1394,
            },
          ).then((value) async {
            var temp = value.data;
            print(temp);
            if (value.statusCode == 200) {
              print(value.statusCode);
              if (1 == 1) {
                setState(() {
                  loading = false;
                  edit = "edit";
                  if (temp.length > 0) {
                    healthData = temp[0];

                    smoker = temp[0]['smoker'];
                    physical_activity = temp[0]['physical_activity'];
                    family_history_inserted =
                        temp[0]['family_history_inserted'];
                    children = temp[0]['children'];
                    animal = temp[0]['animal'];
                    hypertension = temp[0]['hypertension'];
                    diabetes = temp[0]['diabetes'];
                    food_intolerance = temp[0]['food_intolerance'];
                    free_text_with_other_parthlogic =
                        temp[0]['free_text_with_other_parthlogic'];
                    hypercholesterolemia = temp[0]['hypercholesterolemia'];
                    log(' this is helath data $temp');
                  }
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
                  edit = "add";
                });
              }
            }
          }).onError((error, stackTrace) {
            print(error);
            setState(() {
              loading = false;
            });
            showredToast(Constant.somethingWentWrong, context);
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
