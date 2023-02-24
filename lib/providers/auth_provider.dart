import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

final authProvider = ChangeNotifierProvider(
  (ref) {
    final flavor = ref.read(flavorProvider);
    return AuthProvider(flavor);
  },
);

class AuthProvider extends ChangeNotifier {
  final Flavor flavor;
  final ApisNew _apisNew = ApisNew();
  User? user;

  AuthProvider(this.flavor);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bearer_token');
  }

  Future<bool> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = await _apisNew.login({
      'email': email,
      'password': password,
      'is_stilo': 1,
    });

    prefs.setString("bearer_token", result.data["token"].toString());
    prefs.setString("user_id", result.data["user_id"].toString());
    final userResult = await _apisNew.getUserMe({
      'user_id': result.data['user_id'],
    });
    //TODO check code RUNTYPE
    if (result.data['status_code'] == '404') {
      user = null;
      notifyListeners();
      return false;
    } else if (result.data['status_code'] == 500) {
      user = null;
      notifyListeners();
      return false;
    } else {
      user = User.fromJson(userResult.data);

      FirebaseMessaging.instance.getToken().then((token) async {
        final userId = prefs.getString("user_id");

        print('My Token');
        print(token);
        prefs.setString("fcm_token", token!);
        print('UserID');
        print(userId);
        final result = await _apisNew.updateFCMToken({
          'user_id': int.parse(userId!),
          'notification_token': token,
        });

        final test = 0;
      });

      notifyListeners();
      return true;
    }
  }

  Future<bool> getUserMe(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = await _apisNew.getUserMe({
      'user_id': id,
    });

    //if (result.data['code'] == '404') { //TODO check
    if (result.data is String) {
      user = null;
      notifyListeners();
      return false;
    } else {
      user = User.fromJson(result.data);
      notifyListeners();
      return true;
    }
  }

  // Future<GoogleSignInAccount?> signInWithGoogle() async {
  //   final GoogleSignInAccount? _googleUser = await GoogleSignIn().signIn();
  //   print(_googleUser);
  //   return _googleUser;
  // }

  Future<Map<String, dynamic>?> signInWithFacebook() async {
    // try {
    //   final auth = FacebookAuth.instance;
    //   final LoginResult result = await auth
    //       .login(); // by default we request the email and the public profile
    //   // or FacebookAuth.i.login()
    //   if (result.status == LoginStatus.success) {
    //     // you are logged
    //     final userData = await auth.getUserData();
    //     print(userData);
    //     return userData;
    //   } else {
    //     print(result.status);
    //     print(result.message);
    //     return null;
    //   }
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  void logout() async {
    //TODO call delete token API per BE
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("bearer_token", "");
    await prefs.setString("user_id", "");
    notifyListeners();
  }

  Future<dynamic> loginWithFacebook() async {}

  Future<dynamic> loginWithGoogle() async {}

  Future<dynamic> loginWithApple() async {}
}
