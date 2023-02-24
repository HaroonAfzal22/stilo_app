import 'package:contacta_pharmacy/translations/delegate.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appProvider = ChangeNotifierProvider(
  (ref) => AppProvider(),
);

class AppProvider extends ChangeNotifier {
  bool loading = false;

  setLoading() {
    loading = !loading;
    notifyListeners();
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,

      ///device ID for Android
      //'androidId': build.androidId, //TODO
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,

      ///device_id for iOS
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Locale? _locale;
  Locale? get locale => _locale;

  Future<Locale?> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('language');
    if (lang != null) {
      _locale = Locale(lang);
      notifyListeners();
    }
    return _locale;
  }

  void setLocale(Locale locale) async {
    MyLocalizationsDelegate delegate = MyLocalizationsDelegate(locale);
    if (delegate.isSupported(locale)) {
      _locale = locale;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('language', locale.languageCode);
      notifyListeners();
    }
  }
}
