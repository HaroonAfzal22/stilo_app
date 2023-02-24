import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static int getInt(String key, [int? defValue]) {
    return _prefsInstance?.getInt(key) ?? defValue ?? 0;
  }

  static bool getBool(String key, [bool? defValue]) {
    return _prefsInstance?.getBool(key) ?? defValue ?? false;
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return prefs.setInt(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static Future<bool> remove(String key) async {
    var prefs = await _instance;
    return prefs.remove(key);
  }

  //TODO ripristinare
/*  static Future<bool> removeAll(String key) async {
    var prefs = await _instance;
    return prefs?.clear() ?? Future.value(false);
  }*/

  static Future<bool?> reloade() async {
    var prefs = await _instance;
    prefs.reload();
  }

  static Future removeProductDetails() async {
    // remove product and subcategory from local cache
    _prefsInstance?.getKeys();
    for (String key in _prefsInstance!.getKeys()) {
      if (key.contains("product_") ||
          key.contains("cat_") ||
          key.contains("product_category_api_cache")) {
        _prefsInstance?.remove(key);
      }
    }
  }
}
