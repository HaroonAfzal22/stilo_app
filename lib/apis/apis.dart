import 'dart:io';
import 'package:contacta_pharmacy/config/EncodeDecode.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import '../config/constant.dart';

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
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

class Apis {
  Dio dio = Dio(Constant.options);
  EncodeDecode enc = EncodeDecode();

  token() async {
    Map<String, dynamic> data = {};
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

/*    PreferenceUtils.setString("language", "it");
    PreferenceUtils.setString("pharmacy_id", "1");
    PreferenceUtils.setString("cart", "");
    PreferenceUtils.setString("currency", "\€");
    PreferenceUtils.setString("currency_code", "euro");
    _firebaseMessaging.getToken().then((value) {
      print("Fcm Token $value");

      PreferenceUtils.setString("fcm_token", value);
    });*/

    // log(_firebaseMessaging.app.options.appId, name: "My App Id");

    //Get device Id
    if (Platform.isIOS) {
      data = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    } else {
      data = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    }
  }

  Future<void> signUp(Map<String, dynamic> data) async {}

  Future<dynamic> getInterestsList(Map<String, dynamic> data) async {
    return await dio.post(Constant.intrestList, data: data);
  }

  Future<dynamic> changePassword(Map<String, dynamic> data) async {
    return await dio.post(Constant.changePassword, data: data);
  }

  Future<dynamic> newPassword(Map<String, dynamic> data) async {
    return await dio.post(Constant.newPassword, data: data);
  }

  Future<dynamic> login(Map<String, dynamic> data) async {
    return await dio.post(Constant.login, data: data);
  }

  Future<dynamic> cmsIntro(Map<String, dynamic> data) async {
    return await dio.post(Constant.cms_intro, data: data);
  }

  Future<dynamic> cms(Map<String, dynamic> data) async {
    return await dio.post(Constant.cms,
        data: 'eyJzbHVnIjoiQWJvdXRVcyIsInBoYXJtYWN5X2lkIjoiMSJ9');
  }

  Future<dynamic> getBannerList(Map<String, dynamic> data) async {
    return;
  }

  // TODO in data manca type: ""
  Future<dynamic> getDocuments(Map<String, dynamic> data) async {
    return await dio.post(Constant.documentList, data: data);
  }

  Future<dynamic> getContactUsData(Map<String, dynamic> data) async {
    EncodeDecode enc = EncodeDecode();
    final result = await dio.post(Constant.contactus, data: data);
  }

  Future<dynamic> getHomeListData(Map<String, dynamic> data) async {
    await dio.post(Constant.homeList, data: data);
  }

  Future<dynamic> getFollowUsData(Map<String, dynamic> data) async {
    return await dio.post(Constant.followUs, data: data);
  }

  Future<dynamic> getPharmacyBannerData(Map<String, dynamic> data) async {
    return await dio.post(Constant.pharmacyBanner, data: data);
  }

  Future<dynamic> sendOTP(Map<String, dynamic> data) async {
    return await dio.post(Constant.send_OTP, data: data);
  }

  Future<dynamic> verifyOTP(Map<String, dynamic> data) async {
    return await dio.post(Constant.verify_OTP, data: data);
  }

  Future<dynamic> getOurTeamData(Map<String, dynamic> data) async {
    return await dio.post(Constant.ourTeam, data: data);
  }

  Future<dynamic> getFlyers(Map<String, dynamic> data) async {
    return await dio.post(Constant.flyers, data: data);
  }

  Future<dynamic> getConventions(Map<String, dynamic> data) async {
    return await dio.get(Constant.conventions, queryParameters: data);
  }

  Future<dynamic> getProductCategory(Map<String, dynamic> data) async {
    return (await dio.post(Constant.productCategory, data: data));
  }

  Future<dynamic> getRentalProducts(Map<String, dynamic> data) async {
    return await dio.post(Constant.rentalProduct);
  }

  Future<dynamic> getAdvicesList(Map<String, dynamic> data) async {
    return await dio.post(Constant.pharmacyAdvice, data: data);
  }

  Future<dynamic> getAdviceCategories(Map<String, dynamic> data) async {
    //TODO
    // pharmacyAdviceCategory
  }

  Future<dynamic> addToWishList(Map<String, dynamic> data) async {
    return await dio.post(Constant.addWishList, data: data);
  }

  Future<dynamic> deleteFromWishList(Map<String, dynamic> data) async {
    return await dio.post(Constant.deleteWishList, data: data);
  }

  Future<dynamic> getCouponList(Map<String, dynamic> data) async {
    return await dio.get(Constant.coupon, queryParameters: data);
  }

  Future<dynamic> logout(Map<String, dynamic> data) async {
    return await dio.post(Constant.logout, data: data);
  }

  Future<dynamic> getSimilarProducts(Map<String, dynamic> data) async {
    return await dio.post(Constant.similarProducts, data: data);
  }
}
