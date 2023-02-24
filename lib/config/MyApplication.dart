import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacta_pharmacy/config/preference_utils.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/flavor.dart';
import '../theme/app_colors.dart';
import '../translations/translate_string.dart';
import '../utils/AppString.dart';
import 'EncodeDecode.dart';
//TODO reactivate
// import 'ScopeManage.dart';
import 'constant.dart';

class MyApplication {
  static MyApplication? _instance;
  static const platform = MethodChannel('com.pharmacyapp/methodcall');

  bool? _useWhiteStatusBarForeground;
  bool? _useWhiteNavigationBarForeground;

  //ProgressDialog _progressDialog = ProgressDialog();

  static MyApplication? getInstance() {
    _instance ??= MyApplication();

    return _instance;
  }

  networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    log(response.statusCode.toString(), name: "response.statusCode");
    var uint8list = response.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${imageUrl.split("/").last}')
        .writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    log(file.path);
    return file.path;
  }

  Future<bool> checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      showIninfoSnackBar(AppString.no_connection, context);
      return false;
    }
  }

  Future<void> showIninfoSnackBar(String value, BuildContext context) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(value,
        to: PreferenceUtils.getString("language"));

    Fluttertoast.showToast(
        msg: ("$translation"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
//timeInSecForIosWeb: 1,
        backgroundColor: AppColors.blueColor,
        textColor: AppColors.white,
        fontSize: 16.0);
  }

  Widget MenuIcon(
      {@required BuildContext? context,
      @required GlobalKey<ScaffoldState>? key}) {
    return InkWell(
      onTap: () {
        FocusScope.of(context!).unfocus();
        key?.currentState?.openDrawer();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          bottom: 15.0,
          left: 15.0,
          right: 8.0,
        ),
        child: Container(
          height: 24,
          width: 24,
          child: Image.asset(
            "assets/icons/menuicon.png",
          ),
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<bool> getBoolean(String key) async {
    Map<String, dynamic> map = Map();
    map["key"] = key;
    bool value = await MyApplication.platform.invokeMethod("getBoolean", map);
    return value;
  }

  //TODO fix
/*  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }*/

  void storeSting(String key, String value) async {
    Map<String, dynamic> map = {};

    map["key"] = key;
    map["value"] = value;
    await MyApplication.platform.invokeMethod("storeString", map);
  }

  void storeBoolean(String key, bool value) async {
    Map<String, dynamic> map = {};

    map["key"] = key;
    map["value"] = value;

    await MyApplication.platform.invokeMethod("storeBoolean", map);
  }

  void saveDataToPreference(String key, String value) async {
    Map<String, dynamic> map = {};

    map["key"] = key;
    map["value"] = value;

    await MyApplication.platform.invokeMethod("storeString", map);
  }

  getQRCode(String name, String email, String mobile, String membercode) {
    return "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=BEGIN%3AVCARD%0AVERSION%3A2.1%0AN%3A" +
        name +
        "%0AORG%3A" +
        membercode +
        "%0ATEL%3BWORK%3BVOICE%3A%2B%2B91" +
        mobile +
        "%0AEMAIL%3A" +
        email.replaceAll("@", "%40") +
        "%0AADR%3BTYPE%3Dwork%3BLABEL%3D%27Address%27%3A" +
        "%0AEND%3AVCARD%0A&choe=UTF-8";
  }
}

Future<void> showInSnackBar(String value, context) async {
  final translator = GoogleTranslator();
  var translation = await translator.translate(value,
      to: PreferenceUtils.getString("language"));

  Fluttertoast.showToast(
      msg: ("$translation"),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
//timeInSecForIosWeb: 1,
      backgroundColor: AppColors.darkRed,
      textColor: AppColors.white,
      fontSize: 16.0);
}

Future<void> showToast(String value, context, WidgetRef ref) async {
  final translator = GoogleTranslator();
  var translation = await translator.translate(value,
      to: PreferenceUtils.getString("language"));

  Fluttertoast.showToast(
      msg: ("$translation"),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      //timeInSecForIosWeb: 1,
      backgroundColor: ref.read(flavorProvider).primary,
      textColor: Colors.white,
      fontSize: 16.0);
}

//TODO refactor???
/*changeStatusWhiteColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    if (useWhiteForeground(color)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      // FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);

    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      // FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);

    }
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}*/

sessionExpired(context) {
  PreferenceUtils.setBool("isLogin", false);
  PreferenceUtils.setString("accesstoken", "asd");
  PreferenceUtils.setInt("user_id", 00);
  PreferenceUtils.setString("user_image", "");
  PreferenceUtils.setString("name", "");
  PreferenceUtils.setString("email", "");
  PreferenceUtils.setString("city", "");
  PreferenceUtils.setString("contact_number", "");
  PreferenceUtils.setString("address", "");
  PreferenceUtils.setString("province", "");
  PreferenceUtils.setString("street_number", "");
  PreferenceUtils.remove("review");

  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PreLoginScreen(),
      ));
}

//here goes the function
String? parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String? parsedString = parse(document.body?.text).documentElement?.text;

  return parsedString;
}

void launchUrl(String url) async {
  if (await canLaunch(url)) {
    launch(url);
  } else {
    throw "Could not launch $url";
  }
}

back(context) {
  Navigator.pop(context);
}

//TODO reactivate
/*
pharmacyStatusCalculation(temp, context) {
  List days = [];
  List<OpeningHoursClass> openingHoursList = [];
  var startMoringDate;
  var endMoringDate;
  var startEveDate;
  var endEveDate;

  int todayWeekday = DateTime.now().weekday;
// var timeToCheck = DateTime.now();
  log(temp.toString(), name: "pharmacyStatusCalculation");

  log(DateTime.now().weekday.toString(), name: "Week End day");
  if (todayWeekday == 1) {
    if (temp['monday_status'] != null && temp['monday_status'] == "open") {
      if (temp['morning_start_date'] != null) {
        days.add("Lunedì");

        startMoringDate = temp['morning_start_date'];
        endMoringDate = temp['morning_end_date'];
        startEveDate = temp['evening_start_date'] ?? temp['morning_start_date'];
        endEveDate = temp['evening_end_date'] ?? temp['morning_end_date'];
      } else {}
    }
  }

  if (todayWeekday == 2) {
    if (temp['tuesday_status'] != null && temp['tuesday_status'] == "open") {
      if (temp['tuesday_mor_open_time'] != null) {
        days.add("Martedì");

        startMoringDate = temp['tuesday_mor_open_time'];
        endMoringDate = temp['tuesday_mor_close_time'];
        startEveDate =
            temp['tuesday_eve_open_time'] ?? temp['tuesday_mor_open_time'];
        endEveDate =
            temp['tuesday_eve_close_time'] ?? temp['tuesday_mor_close_time'];
      } else {}
    }
  }

  if (todayWeekday == 3) {
    if (temp['wednesday_status'] != null &&
        temp['wednesday_status'] == "open") {
      if (temp['wednesday_mor_open_time'] != null) {
        days.add("Mercoledì");
        startMoringDate = temp['wednesday_mor_open_time'];
        endMoringDate = temp['wednesday_mor_close_time'];
        startEveDate =
            temp['wednesday_eve_open_time'] ?? temp['wednesday_mor_open_time'];
        endEveDate = temp['wednesday_eve_close_time'] ??
            temp['wednesday_mor_close_time'];
      } else {}
    }
  }

  if (todayWeekday == 4) {
    if (temp['thursday_status'] != null && temp['thursday_status'] == "open") {
      if (temp['thursday_mor_open_time'] != null) {
        days.add("Giovedì");

        startMoringDate = temp['thursday_mor_open_time'];
        endMoringDate = temp['thursday_mor_close_time'];
        startEveDate =
            temp['thursday_eve_open_time'] ?? temp['thursday_mor_open_time'];
        endEveDate =
            temp['thursday_eve_close_time'] ?? temp['thursday_mor_close_time'];
      } else {}
    }
  }
  if (todayWeekday == 5) {
    if (temp['friday_status'] != null && temp['friday_status'] == "open") {
      if (temp['friday_mor_open_time'] != null) {
        days.add("Venerdì");

        startMoringDate = temp['friday_mor_open_time'];
        endMoringDate = temp['friday_mor_close_time'];
        startEveDate =
            temp['friday_eve_open_time'] ?? temp['friday_mor_open_time'];
        endEveDate =
            temp['friday_eve_close_time'] ?? temp['friday_mor_close_time'];
      } else {}
    }
  }

  if (todayWeekday == 6) {
    if (temp['saturday_status'] != null && temp['saturday_status'] == "open") {
      if (temp['saturday_mor_open_time'] != null) {
        days.add("Sabato");

        startMoringDate = temp['saturday_mor_open_time'];
        endMoringDate = temp['saturday_mor_close_time'];
        startEveDate =
            temp['saturday_eve_open_time'] ?? temp['saturday_mor_open_time'];
        endEveDate =
            temp['saturday_eve_close_time'] ?? temp['saturday_mor_close_time'];
      } else {}
    }
  }
  if (todayWeekday == 7) {
    if (temp['sunday_status'] != null && temp['sunday_status'] == "open") {
      if (temp['sunday_mor_open_time'] != null) {
        days.add("Domenica");
        startMoringDate = temp['sunday_mor_open_time'];
        endMoringDate = temp['sunday_mor_close_time'];
        startEveDate =
            temp['sunday_eve_open_time'] ?? temp['sunday_mor_open_time'];
        endEveDate =
            temp['sunday_eve_close_time'] ?? temp['sunday_mor_close_time'];
      } else {}
    }
  }

  log("openCloseDayCalculation");

  if (temp['monday_status'] != null && temp['monday_status'] == "open") {
    if (temp['morning_start_date'] != null) {
      days.add("Lunedì");
      openingHoursList.add(OpeningHoursClass(
          day: "Lunedì",
          startMoringDate: temp['morning_start_date'],
          endMoringDate: temp['morning_end_date'],
          startEveDate:
              temp['evening_start_date'] ?? temp['morning_start_date'],
          endEveDate: temp['evening_end_date'] ?? temp['morning_end_date']));
    }
  }

  if (temp['tuesday_status'] != null && temp['tuesday_status'] == "open") {
    if (temp['tuesday_mor_open_time'] != null) {
      days.add("Martedì");
      openingHoursList.add(OpeningHoursClass(
          day: "Martedì",
          startMoringDate: temp['tuesday_mor_open_time'],
          endMoringDate: temp['tuesday_mor_close_time'],
          startEveDate:
              temp['tuesday_eve_open_time'] ?? temp['tuesday_mor_open_time'],
          endEveDate: temp['tuesday_eve_close_time'] ??
              temp['tuesday_mor_close_time']));
    }
  }

  if (temp['wednesday_status'] != null && temp['wednesday_status'] == "open") {
    if (temp['wednesday_mor_open_time'] != null) {
      days.add("Mercoledì");
      openingHoursList.add(OpeningHoursClass(
          day: "Mercoledì",
          startMoringDate: temp['wednesday_mor_open_time'],
          endMoringDate: temp['wednesday_mor_close_time'],
          startEveDate: temp['wednesday_eve_open_time'] ??
              temp['wednesday_mor_open_time'],
          endEveDate: temp['wednesday_eve_close_time'] ??
              temp['wednesday_mor_close_time']));
    }
  }

  if (temp['thursday_status'] != null && temp['thursday_status'] == "open") {
    if (temp['thursday_mor_open_time'] != null) {
      days.add("Giovedì");
      openingHoursList.add(OpeningHoursClass(
          day: "Giovedì",
          startMoringDate: temp['thursday_mor_open_time'],
          endMoringDate: temp['thursday_mor_close_time'],
          startEveDate:
              temp['thursday_eve_open_time'] ?? temp['thursday_mor_open_time'],
          endEveDate: temp['thursday_eve_close_time'] ??
              temp['thursday_mor_close_time']));
    }
  }

  if (temp['friday_status'] != null && temp['friday_status'] == "open") {
    if (temp['friday_mor_open_time'] != null) {
      days.add("Venerdì");
      openingHoursList.add(OpeningHoursClass(
          day: "Venerdì",
          startMoringDate: temp['friday_mor_open_time'],
          endMoringDate: temp['friday_mor_close_time'],
          startEveDate:
              temp['friday_eve_open_time'] ?? temp['friday_mor_open_time'],
          endEveDate:
              temp['friday_eve_close_time'] ?? temp['friday_mor_close_time']));
    }
  }

  if (temp['saturday_status'] != null && temp['saturday_status'] == "open") {
    if (temp['saturday_mor_open_time'] != null) {
      days.add("Sabato");
      openingHoursList.add(OpeningHoursClass(
          day: "Sabato",
          startMoringDate: temp['saturday_mor_open_time'],
          endMoringDate: temp['saturday_mor_close_time'],
          startEveDate:
              temp['saturday_eve_open_time'] ?? temp['saturday_mor_open_time'],
          endEveDate: temp['saturday_eve_close_time'] ??
              temp['saturday_mor_close_time']));
    }
  }

  if (temp['sunday_status'] != null && temp['sunday_status'] == "open") {
    if (temp['sunday_mor_open_time'] != null) {
      days.add("Domenica");
      openingHoursList.add(OpeningHoursClass(
          day: "Domenica",
          startMoringDate: temp['sunday_mor_open_time'],
          endMoringDate: temp['sunday_mor_close_time'],
          startEveDate:
              temp['sunday_eve_open_time'] ?? temp['sunday_mor_open_time'],
          endEveDate:
              temp['sunday_eve_close_time'] ?? temp['sunday_mor_close_time']));
    }
  }

  openingHoursList = openingHoursList.toSet().toList();


   AppModel model = ScopedModel.of(context);
  days = days.toSet().toList();
  if (openingHoursList.length > 0) {
    model.switchPharmacyOpeningHours(
        openingHoursList[0].day,
        openingHoursList.last.day,
        startMoringDate,
        endMoringDate,
        startEveDate,
        endEveDate,
        openingHoursList);
  }
  log("$days", name: "OpenDays");

  var timeToCheck = DateTime(
      1970, 01, 01, TimeOfDay.now().hour, TimeOfDay.now().minute, 00, 0000);

  // var timeToCheck = DateTime(
  //     1970, 01, 01, 9 , 00, 00, 0000);
  log("Topsss");
  if (startMoringDate != null) {
    var startMoringDateFormat = DateFormat("HH:mm").parse("$startMoringDate");
    log(startMoringDateFormat.toString(), name: "startMoringDateFormat");
    var endMoringDateFormat = DateFormat("HH:mm").parse(endMoringDate);

    var startEveDateFormat = DateFormat("HH:mm").parse(startEveDate);
    var endEveDateFormat = DateFormat("HH:mm").parse(endEveDate);
    log(timeToCheck.difference(endMoringDateFormat).inMinutes.toString(),
        name: "inHours");
    log(endMoringDateFormat.toString(), name: "inEndMorning");

    log("${timeToCheck.difference(endEveDateFormat).inMinutes > -30}",
        name: "Evend date is 30 min?");
    if (timeToCheck.difference(endMoringDateFormat).inMinutes >= -30 &&
        timeToCheck.isBefore(endMoringDateFormat)) {
      log("Closing", name: "startMoringDate");
      return "Closing";
    } else if (timeToCheck.difference(startEveDateFormat).inMinutes >= -30 &&
        timeToCheck.difference(startEveDateFormat).inMinutes < 0) {
      log("Closing", name: "startMoringDate Clossssss");
      return "Closing";
    } else if (timeToCheck.difference(startMoringDateFormat).inMinutes >= -30 &&
        timeToCheck.difference(startMoringDateFormat).inMinutes < 0) {
      log("Closing", name: "startMoringDate Clossssss");
      return "Closing";
    } else if (timeToCheck == startMoringDateFormat) {
      log("Open", name: "startMoringDate");
      return "Open";
    } else if (timeToCheck == endMoringDateFormat) {
      log("Close", name: "startMoringDate");
      return "Close";
    } else if (timeToCheck == startEveDateFormat) {
      log("Open Eve", name: "startMoringDate");
      return "Open";
    } else if (timeToCheck.isAfter(endMoringDateFormat) &&
        timeToCheck.isBefore(startEveDateFormat)) {
      // do something
      log("Close", name: "startMoringDate");
      return "Close";
    } else if (timeToCheck.isAfter(startMoringDateFormat) &&
        timeToCheck.isBefore(endMoringDateFormat)) {
      log("isBefore loop");
      return "Open";
    } else if (timeToCheck.isAfter(startEveDateFormat) &&
        timeToCheck.isBefore(endEveDateFormat)) {
      if (timeToCheck.difference(endEveDateFormat).inMinutes >= -30) {
        log("isBefore loop----Close");
        return "Closing";
      } else {
        log("isBefore loop----Open");
        return "Open";
      }
    } else {
      log("Close", name: "Close after eve");
      log("$timeToCheck", name: "Time To check");
      log("$startMoringDateFormat", name: "startMoringDate");
      log("$endMoringDateFormat", name: "endMoringDate");
      log("$endEveDateFormat", name: "endEveDate");
      log("$startEveDateFormat", name: "startEveDate");
      return "Close";
    }
  } else {
    return "Close";
  }
}
*/

pharmacyStatusCalculationForBottom(temp, context) {
  List days = [];
  List<OpeningHoursClass> openingHoursList = [];
  var startMoringDate;
  var endMoringDate;
  var startEveDate;
  var endEveDate;

  int todayWeekday = DateTime.now().weekday;
// var timeToCheck = DateTime.now();
  log(temp.toString(), name: "pharmacyStatusCalculationForBottom");

  log(DateTime.now().weekday.toString(), name: "Week End day");
  if (todayWeekday == 1) {
    if (temp['monday_status'] != null && temp['monday_status'] == "open") {
      if (temp['morning_start_date'] != null) {
        days.add("Lunedì");

        startMoringDate = temp['morning_start_date'];
        endMoringDate = temp['morning_end_date'];
        startEveDate = temp['evening_start_date'] ?? temp['morning_start_date'];
        endEveDate = temp['evening_end_date'] ?? temp['morning_end_date'];
      } else {}
    }
  }

  if (todayWeekday == 2) {
    if (temp['tuesday_status'] != null && temp['tuesday_status'] == "open") {
      if (temp['tuesday_mor_open_time'] != null) {
        days.add("Martedì");

        startMoringDate = temp['tuesday_mor_open_time'];
        endMoringDate = temp['tuesday_mor_close_time'];
        startEveDate =
            temp['tuesday_eve_open_time'] ?? temp['tuesday_mor_open_time'];
        endEveDate =
            temp['tuesday_eve_close_time'] ?? temp['tuesday_mor_close_time'];
      } else {}
    }
  }

  if (todayWeekday == 3) {
    if (temp['wednesday_status'] != null &&
        temp['wednesday_status'] == "open") {
      if (temp['wednesday_mor_open_time'] != null) {
        days.add("Mercoledì");
        startMoringDate = temp['wednesday_mor_open_time'];
        endMoringDate = temp['wednesday_mor_close_time'];
        startEveDate =
            temp['wednesday_eve_open_time'] ?? temp['wednesday_mor_open_time'];
        endEveDate = temp['wednesday_eve_close_time'] ??
            temp['wednesday_mor_close_time'];

        // startEveDate =temp['wednesday_mor_open_time'];
        // endEveDate = temp['wednesday_mor_close_time'];

      } else {}
    }
  }

  if (todayWeekday == 4) {
    if (temp['thursday_status'] != null && temp['thursday_status'] == "open") {
      if (temp['thursday_mor_open_time'] != null) {
        days.add("Giovedì");

        startMoringDate = temp['thursday_mor_open_time'];
        endMoringDate = temp['thursday_mor_close_time'];
        startEveDate =
            temp['thursday_eve_open_time'] ?? temp['thursday_mor_open_time'];
        endEveDate =
            temp['thursday_eve_close_time'] ?? temp['thursday_mor_close_time'];
      } else {}
    }
  }
  if (todayWeekday == 5) {
    if (temp['friday_status'] != null && temp['friday_status'] == "open") {
      if (temp['friday_mor_open_time'] != null) {
        days.add("Venerdì");

        startMoringDate = temp['friday_mor_open_time'];
        endMoringDate = temp['friday_mor_close_time'];
        startEveDate =
            temp['friday_eve_open_time'] ?? temp['friday_mor_open_time'];
        endEveDate =
            temp['friday_eve_close_time'] ?? temp['friday_mor_close_time'];
      } else {}
    }
  }

  if (todayWeekday == 6) {
    if (temp['saturday_status'] != null && temp['saturday_status'] == "open") {
      if (temp['saturday_mor_open_time'] != null) {
        days.add("Sabato");

        startMoringDate = temp['saturday_mor_open_time'];
        endMoringDate = temp['saturday_mor_close_time'];
        startEveDate =
            temp['saturday_eve_open_time'] ?? temp['saturday_mor_open_time'];
        endEveDate =
            temp['saturday_eve_close_time'] ?? temp['saturday_mor_close_time'];
      } else {}
    }
  }

  if (todayWeekday == 7) {
    if (temp['sunday_status'] != null && temp['sunday_status'] == "open") {
      if (temp['sunday_mor_open_time'] != null) {
        days.add("Domenica");
        startMoringDate = temp['sunday_mor_open_time'];
        endMoringDate = temp['sunday_mor_close_time'];
        startEveDate =
            temp['sunday_eve_open_time'] ?? temp['sunday_mor_open_time'];
        endEveDate =
            temp['sunday_eve_close_time'] ?? temp['sunday_mor_close_time'];
      } else {}
    }
  }

  log("openCloseDayCalculation");

  if (temp['monday_status'] != null && temp['monday_status'] == "open") {
    if (temp['morning_start_date'] != null) {
      days.add("Lunedì");
      openingHoursList.add(OpeningHoursClass(
          day: "Lunedì",
          startMoringDate: temp['morning_start_date'],
          endMoringDate: temp['morning_end_date'],
          startEveDate:
              temp['evening_start_date'] ?? temp['morning_start_date'],
          endEveDate: temp['evening_end_date'] ?? temp['morning_end_date']));
    }
  }

  if (temp['tuesday_status'] != null && temp['tuesday_status'] == "open") {
    if (temp['tuesday_mor_open_time'] != null) {
      days.add("Martedì");
      openingHoursList.add(OpeningHoursClass(
          day: "Martedì",
          startMoringDate: temp['tuesday_mor_open_time'],
          endMoringDate: temp['tuesday_mor_close_time'],
          startEveDate:
              temp['tuesday_eve_open_time'] ?? temp['tuesday_mor_open_time'],
          endEveDate:
              temp['tuesday_eve_close_time'] ?? temp['tuesday_mor_open_time']));
    }
  }

  if (temp['wednesday_status'] != null && temp['wednesday_status'] == "open") {
    if (temp['wednesday_mor_open_time'] != null) {
      days.add("Mercoledì");
      openingHoursList.add(OpeningHoursClass(
          day: "Mercoledì",
          startMoringDate: temp['wednesday_mor_open_time'],
          endMoringDate: temp['wednesday_mor_close_time'],
          startEveDate: temp['wednesday_eve_open_time'] ??
              temp['wednesday_mor_open_time'],
          endEveDate: temp['wednesday_eve_close_time'] ??
              temp['wednesday_mor_close_time']));
    }
  }

  if (temp['thursday_status'] != null && temp['thursday_status'] == "open") {
    if (temp['thursday_mor_open_time'] != null) {
      days.add("Giovedì");
      openingHoursList.add(OpeningHoursClass(
          day: "Giovedì",
          startMoringDate: temp['thursday_mor_open_time'],
          endMoringDate: temp['thursday_mor_close_time'],
          startEveDate:
              temp['thursday_eve_open_time'] ?? temp['thursday_mor_open_time'],
          endEveDate: temp['thursday_eve_close_time'] ??
              temp['thursday_mor_open_time']));
    }
  }

  if (temp['friday_status'] != null && temp['friday_status'] == "open") {
    if (temp['friday_mor_open_time'] != null) {
      days.add("Venerdì");
      openingHoursList.add(OpeningHoursClass(
          day: "Venerdì",
          startMoringDate: temp['friday_mor_open_time'],
          endMoringDate: temp['friday_mor_close_time'],
          startEveDate:
              temp['friday_eve_open_time'] ?? temp['friday_mor_open_time'],
          endEveDate:
              temp['friday_eve_close_time'] ?? temp['friday_mor_open_time']));
    }
  }

  if (temp['saturday_status'] != null && temp['saturday_status'] == "open") {
    if (temp['saturday_mor_open_time'] != null) {
      days.add("Sabato");
      openingHoursList.add(OpeningHoursClass(
          day: "Sabato",
          startMoringDate: temp['saturday_mor_open_time'],
          endMoringDate: temp['saturday_mor_close_time'],
          startEveDate:
              temp['saturday_eve_open_time'] ?? temp['saturday_mor_open_time'],
          endEveDate: temp['saturday_eve_close_time'] ??
              temp['saturday_mor_open_time']));
    }
  }

  if (temp['sunday_status'] != null && temp['sunday_status'] == "open") {
    if (temp['sunday_mor_open_time'] != null) {
      days.add("Domenica");
      openingHoursList.add(OpeningHoursClass(
          day: "Domenica",
          startMoringDate: temp['sunday_mor_open_time'],
          endMoringDate: temp['sunday_mor_close_time'],
          startEveDate:
              temp['sunday_eve_open_time'] ?? temp['sunday_mor_open_time'],
          endEveDate:
              temp['sunday_eve_close_time'] ?? temp['sunday_mor_close_time']));
    }
  }

  openingHoursList = openingHoursList.toSet().toList();

  //TODO reactivate
/*   AppModel model = ScopedModel.of(context);
  days = days.toSet().toList();

  if (openingHoursList.length > 0) {
    log("$startEveDate", name: "startEveDate");
    log("$endEveDate", name: "EndEveDate");
    model.switchPharmacyOpeningHours(
        openingHoursList[0].day,
        openingHoursList.last.day,
        startMoringDate,
        endMoringDate,
        startEveDate,
        endEveDate,
        openingHoursList);
  }*/
  log("$startMoringDate", name: "OpenDays");

  var timeToCheck = DateTime(
      1970, 01, 01, TimeOfDay.now().hour, TimeOfDay.now().minute, 00, 0000);

  // var timeToCheck = DateTime(
  //     1970, 01, 01, 9 , 45, 00, 0000);

  if (startMoringDate != null) {
    var startMoringDateFormat = DateFormat("HH:mm").parse("$startMoringDate");
    log(startMoringDateFormat.toString(), name: "startMoringDateFormat");
    var endMoringDateFormat = DateFormat("HH:mm").parse(endMoringDate);

    var startEveDateFormat = DateFormat("HH:mm").parse(startEveDate);
    var endEveDateFormat = DateFormat("HH:mm").parse(endEveDate);

    log("${timeToCheck.difference(startEveDateFormat).inMinutes}",
        name: "Checking closing time");

    log(timeToCheck.difference(endMoringDateFormat).inMinutes.toString(),
        name: "inHours");
    log(endMoringDateFormat.toString(), name: "inEndMorning");

    log("${timeToCheck.difference(endEveDateFormat).inMinutes > -30}",
        name: "Evend date is 30 min?");
    if (timeToCheck.difference(endMoringDateFormat).inMinutes >= -30 &&
        timeToCheck.isBefore(endMoringDateFormat)) {
      log("Closing", name: "startMoringDate");
      return "Closing";
    } else if (timeToCheck.difference(startEveDateFormat).inMinutes >= -30 &&
        timeToCheck.difference(startEveDateFormat).inMinutes < 0) {
      log("Closing", name: "startMoringDate Clossssss");
      return "Closing";
    } else if (timeToCheck.difference(startMoringDateFormat).inMinutes >= -30 &&
        timeToCheck.difference(startMoringDateFormat).inMinutes < 0) {
      log("Closing", name: "startMoringDate Clossssss");
      return "Closing";
    } else if (timeToCheck == startMoringDateFormat) {
      log("Open", name: "startMoringDate");
      return "Open";
    } else if (timeToCheck == endMoringDateFormat) {
      log("Close", name: "startMoringDate");
      return "Close";
    } else if (timeToCheck == startEveDateFormat) {
      log("Open Eve", name: "startMoringDate");
      return "Open";
    } else if (timeToCheck.isAfter(endMoringDateFormat) &&
        timeToCheck.isBefore(startEveDateFormat)) {
      // do something
      log("Close", name: "startMoringDate");
      return "Close";
    } else if (timeToCheck.isAfter(startMoringDateFormat) &&
        timeToCheck.isBefore(endMoringDateFormat)) {
      log("isBefore loop");
      return "Open";
    } else if (timeToCheck.isAfter(startEveDateFormat) &&
        timeToCheck.isBefore(endEveDateFormat)) {
      if (timeToCheck.difference(endEveDateFormat).inMinutes >= -30) {
        log("isBefore loop----Close");
        return "Closing";
      } else {
        log("isBefore loop----Open");
        return "Open";
      }
    } else {
      log("Close", name: "Close after eve");
      log("$timeToCheck", name: "Time To check");
      log("$startMoringDateFormat", name: "startMoringDate");
      log("$endMoringDateFormat", name: "endMoringDate");
      log("$endEveDateFormat", name: "endEveDate");
      log("$startEveDateFormat", name: "startEveDate");
      return "Close";
    }
  } else {
    return "close";
  }
}

testCompressAndGetFile(File file) async {
  final dir = await path_provider.getTemporaryDirectory();

  // File file = createFile("${dir.absolute.path}/test.png");
  // file.writeAsBytesSync(data.buffer.asUint8List());

  final targetPath =
      dir.absolute.path + "/${DateTime.now()}_${file.path.split("/").last}";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 40,
  );

  // log("${file.lengthSync() / (1024 * 1024)}", name: "File compress");
  // log("${result?.lengthSync()/ (1024 * 1024)}", name: "Result Compress");

  return result;
}

// TODO reactivate
/*tz.TZDateTime scheduleDate(date, DateTime time) {
  log("$date $time", name: "_scheduleDate");
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      int.parse(date.toString().split("/")[2]),
      int.parse(date.toString().split("/")[1]),
      int.parse(date.toString().split("/")[0]),
      time.hour,
      time.minute);

  return scheduledDate;
}*/

//TODO refactor
/*Future<void> zonedScheduleNotification(date, DateTime time,
    {notificationChannelId, product}) async {
  var random = m
      .Random(); // keep this somewhere in a static variable. Just make sure to initialize only once.
  num id1 = random.nextInt((m.pow(2, 31) - 1) as int);

  log("$date $time $id1", name: "pendingNotificationRequests");
  await flutterLocalNotificationsPlugin
      .zonedSchedule(
          id1,
          'Terapia',
          "È' ora della tua terapia!  Entra nell'app per vedere i dettagli!",
          scheduleDate(date, time),
          NotificationDetails(
              android: AndroidNotificationDetails('$notificationChannelId',
                  '$notificationChannelId', '$notificationChannelId',
                  sound: RawResourceAndroidNotificationSound(
                      '${PreferenceUtils.getString('therapy_sound')}')),
              iOS: IOSNotificationDetails(
                sound: '${PreferenceUtils.getString('therapy_sound')}',
                presentSound: true,
                presentAlert: true,
              )),
          payload: "Hello This is my payload",
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime)
      .then((value) {
    PreferenceUtils.setInt(
        "notificationId", PreferenceUtils.getInt("notificationId") + 1);
  });
}*/

Future<void> showgreenToast(String value, context, WidgetRef ref) async {
  log(value, name: "Green");
  final translator = GoogleTranslator();

  var translation = value;
  try {
    final test = await translator.translate(value,
        to: PreferenceUtils.getString("language"));

    translation = test.text;
  } catch (e) {
    translation = value;
  }

  if (Platform.isAndroid) {
    var fToast;

    fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: ref.read(flavorProvider).lightPrimary,
      ),
      child: Text(
        translation,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 5),
    );
  } else {
    Fluttertoast.showToast(
        msg: ("$translation"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
//timeInSecForIosWeb: 1,
        backgroundColor: ref.read(flavorProvider).lightPrimary,
        textColor: AppColors.white,
        fontSize: 16.0);
  }
}

Future<void> showblueToast(String value, context) async {
  final translator = GoogleTranslator();
  var translation = await translator.translate(value,
      to: PreferenceUtils.getString("language"));

  if (Platform.isAndroid) {
    var fToast;

    fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: AppColors.toastText,
      ),
      child: Text(
        "$translation",
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 5),
      gravity: ToastGravity.BOTTOM,
    );
  } else {
    Fluttertoast.showToast(
        msg: ("$translation"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
//timeInSecForIosWeb: 1,
        backgroundColor: AppColors.toastText,
        textColor: AppColors.white,
        fontSize: 16.0);
  }
}

Future<void> showredToast(String value, context) async {
  var fToast;
//TODO prendere da sharedPreferences
  final translator = GoogleTranslator();
  var translation = await translator.translate(value, to: 'it');

  if (Platform.isAndroid) {
    fToast = FToast();
    fToast.init(context);
    fToast.removeCustomToast();
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: AppColors.darkRed,
      ),
      child: Text(
        "$translation",
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 5),
    );
  } else {
    Fluttertoast.showToast(
        msg: ("$translation"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
//timeInSecForIosWeb: 1,
        backgroundColor: AppColors.darkRed,
        textColor: AppColors.white,
        fontSize: 16.0);
  }
}

//TODO fixare
Future<void> showPrimaryToast(String? message, Color lightPrimary) async {
  Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: lightPrimary,
      textColor: Colors.white,
      fontSize: 16.0);
}

//TODO da rimuovere
class OpeningHoursClass {
  String day;
  String startMoringDate;
  String endMoringDate;
  String startEveDate;
  String endEveDate;

  OpeningHoursClass({
    required this.day,
    required this.startMoringDate,
    required this.endMoringDate,
    required this.startEveDate,
    required this.endEveDate,
  });
}

Future userBlockApi(context, {id, accessToken}) async {
  if (id != null) {
    PreferenceUtils.setInt("user_id", id);
  }

  var tempp;
  EncodeDecode enc = EncodeDecode();
  var dataToBesent = enc.encode({
    '"user_id" : "${id ?? PreferenceUtils.getInt("user_id").toString()}","user_device_id":"${PreferenceUtils.getString("user_device_id").toString()}","access_token":"${accessToken ?? PreferenceUtils.getString("accesstoken").toString()}","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}"'
  });
  log(dataToBesent, name: "User block");
  try {
    Dio dio = Dio();

    await dio
        .post(
      Constant.userBlock,
      data: dataToBesent,
    )
        .then((value) async {
      var temp = await json.decode(enc.decode(value.toString()));
      log("$temp", name: "userBlock");
      if (value.statusCode == 200) {
        if (temp['code'] == 200) {
          tempp = temp;

// log("${myorderList[0]}" , name:"myorderList");

        } else if (temp['code'] == 999) {
          showredToast("${temp['message']}", context);
          sessionExpired(context);
        } else {
          // showToast("${temp['message']}", context);
        }
      }
    });
  } catch (e) {
    print(e);
    showredToast(translate(context, "error_fetching_data"), context);
  }

  return tempp;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

extension DateTimeX on DateTime {
  bool isUnderage() =>
      (DateTime(DateTime.now().year, month, day).isAfter(DateTime.now())
          ? DateTime.now().year - year - 1
          : DateTime.now().year - year) <
      18;
}
