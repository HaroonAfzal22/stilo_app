import 'dart:async';
import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/notifications_provider.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:contacta_pharmacy/ui/screens/multisede/site_select_screen.dart';
import 'package:contacta_pharmacy/ui/screens/onboarding_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/flavor.dart';

class SplashScreenSecond extends ConsumerStatefulWidget {
  const SplashScreenSecond({Key? key}) : super(key: key);
  static const routeName = '/splash-screen-second';

  @override
  SplashScreenSecondState createState() => SplashScreenSecondState();
}

class SplashScreenSecondState extends ConsumerState<SplashScreenSecond>
    with SingleTickerProviderStateMixin {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AnimationController? _animationController;
  Animation<double>? _animation;
  final ApisNew _apisNew = ApisNew();

  @override
  void initState() {
    configureDeviceInfo();

    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _animation = Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn));
    _animationController!.forward();

    final navigator = Navigator.of(context);

    if (mounted) {
      Timer(const Duration(milliseconds: 1800), () async {
        final prefs = await SharedPreferences.getInstance();

        final sites = await _apisNew.getSedi(
          {'pharmacy_id': ref.read(flavorProvider).pharmacyId},
        );

        ref.read(sitesProvider.notifier).state = sites;

        int? siteId = prefs.getInt('site_id');

        //Selezione sede
        if (siteId != null && sites.length > 1) {
          if (sites.any((x) => x.id == siteId)) {
            ref.read(siteProvider.notifier).state =
                sites.firstWhere((x) => x.id == siteId);
          } else {
            siteId = null;
          }
        } else if (sites.length == 1) {
          siteId = sites.first.id;
          prefs.setInt('site_id', siteId);
          ref.read(siteProvider.notifier).state = sites.first;
        }

        final userId = prefs.getString("user_id");

        if (userId != 'null' && userId != null && userId != "") {
          final result = await ref.read(authProvider).getUserMe(userId);
          if (result == true) {
            ref.read(notificationsProvider).getNotifications({
              'user_id': ref.read(authProvider).user?.userId,
            });

            // navigator.pushNamedAndRemoveUntil(
            //     MainScreen.routeName, (route) => false);

            if (sites.length > 1 && siteId == null) {
              navigator.pushNamedAndRemoveUntil(
                  SiteSelectScreen.routeName, (route) => false);
            } else {
              navigator.pushNamedAndRemoveUntil(
                  MainScreen.routeName, (route) => false);
            }
          } else {
            navigator.pushReplacementNamed(OnBoardingScreen.routeName);
          }
        } else {
          navigator.pushReplacementNamed(OnBoardingScreen.routeName);
          // if (sites.length > 1 && siteId == null) {
          //   navigator.pushNamedAndRemoveUntil(
          //       SiteSelectScreen.routeName, (route) => false);
          // } else {
          //   navigator.pushReplacementNamed(OnBoardingScreen.routeName);
          // }
        }
      });
    }
  }

  configureDeviceInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      prefs.setString("user_device_id", iosDeviceInfo.identifierForVendor!);
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      prefs.setString("user_device_id", androidDeviceInfo.id); //todo androidId
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation!,
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              child: Image.asset(
                'assets/flavor/logo.png',
                width: 250,
                height: 250,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
