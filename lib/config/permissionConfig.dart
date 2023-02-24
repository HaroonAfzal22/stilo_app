import 'package:shared_preferences/shared_preferences.dart';

class PermissionConfig {
  static Future<bool> getPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var perm = checkPermission(prefs);
    // if (!perm) perm = await requestPermission(prefs);
    return true;
  }

  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('language')) {
      var prefValue = prefs.getString('language');
      return prefValue ?? "";
    } else {
      return "";
    }
  }

  static bool checkPermission(SharedPreferences prefs) {
    bool res = true;
    if (prefs.containsKey('cameraPermission')) {
      if (!prefs.getBool('cameraPermission')!) res = false;
    } else {
      res = false;
    }
    if (prefs.containsKey('photoPermission')) {
      if (!prefs.getBool('photoPermission')!) res = false;
    } else {
      res = false;
    }
    if (prefs.containsKey('storePermission')) {
      if (!prefs.getBool('storePermission')!) res = false;
    } else {
      res = false;
    }
    return res;
  }

  // static Future<bool> requestPermission(SharedPreferences prefs) async {
  //   var cameraPermissionStatus = await Permission.camera.request();
  //   await prefs.setBool('cameraPermission', !cameraPermissionStatus.isDenied);

  //   var photoPermissionStatus = await Permission.photos.request();
  //   await prefs.setBool('photoPermission', !photoPermissionStatus.isDenied);

  //   var storePermissionStatus = await Permission.storage.request();
  //   await prefs.setBool('storePermission', !storePermissionStatus.isDenied);

  //   return !cameraPermissionStatus.isDenied &&
  //           !photoPermissionStatus.isDenied ||
  //       !storePermissionStatus.isDenied;
  // }
}
