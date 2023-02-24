import 'dart:io';

import 'package:contacta_pharmacy/ui/screens/privacy_policy_screen.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_general_screen.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_profile_screen.dart';
import 'package:contacta_pharmacy/ui/screens/terms_and_conditions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

//TODO tradurre tutte le voci

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'settings'),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              SettingItem(
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsProfile.routeName);
                },
                imgUrl: 'assets/icons/ic_profile.png',
                title: translate(context, 'Profile_Settings'),
              ),
              SettingItem(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(SettingsGeneralScreen.routeName);
                },
                imgUrl: 'assets/icons/ic_settings.png',
                title: translate(context, 'General_Setting'),
              ),
              /*       SettingItem(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(SettingsNotificationsScreen.routeName);
                  },
                  imgUrl: 'assets/icons/primary_notification.png',
                  title: translate(context, 'Notification_Settings')),
              SettingItem(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(SettingsTherapyScreen.routeName);
                },
                imgUrl: 'assets/icons/ic_outline.png',
                title: translate(context, 'Therapy_management'),
              ),*/
              if (ref.read(flavorProvider).qrLink != null)
                SettingItem(
                  onTap: () {
                    Share.share(
                      'Scarica l’app della tua farmacia: ${ref.read(flavorProvider).qrLink}',
                      subject: ref.read(flavorProvider).pharmacyName,
                    );

                    // //TODO fix URLs
                    // if (Platform.isAndroid) {
                    //   Share.share(
                    //       'Scarica l’app della tua farmacia: https://play.google.com/store/apps/details?id=com.pharmacy_app_new',
                    //       subject: '');
                    // } else {
                    //   Share.share(
                    //       'Scarica l’app della tua farmacia: https://apps.apple.com/in/app/pharma/id1575374693',
                    //       subject: '');
                    // }
                  },
                  imgUrl: 'assets/icons/ic_recommended.png',
                  title: translate(context, 'Recommend_the_app'),
                ),
              SettingItem(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(PrivacyPolicyScreen.routeName);
                  },
                  imgUrl: 'assets/icons/ic_insurance.png',
                  title: translate(context, 'Privacy_Policy')),
              SettingItem(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(TermsConditionScreen.routeName);
                  },
                  imgUrl: 'assets/icons/ic_connection.png',
                  title: translate(context, 'Terms_Conditions')),
              //TODO CHECK this
              /*    SettingItem(
                onTap: () async {
                  final mailtoLink = Mailto(
                    to: ['to@example.com'],
                    cc: ['cc1@example.com', 'cc2@example.com'],
                    subject: 'mailto example subject',
                    body: 'mailto example body',
                  );
                  // Convert the Mailto instance into a string.
                  // Use either Dart's string interpolation
                  // or the toString() method.
                  await launch(mailtoLink.toString());
                },
                imgUrl: 'assets/icons/ic_pie_chart.png',
                title: translate(context, 'Send_us_a_report'),
              ),*/
              //TODO fix
              /*      SettingItem(
                onTap: () {},
                imgUrl: 'assets/icons/ic_star.png',
                title: translate(context, 'Evaluate_Application'),
              ),*/
              //TODO serve?
              /*  SettingItem(
                  onTap: () {},
                  imgUrl: 'assets/icons/ic_logout.png',
                  title: 'Logout')*/
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends ConsumerWidget {
  const SettingItem({
    Key? key,
    required this.onTap,
    required this.imgUrl,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final String imgUrl;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  imgUrl,
                  width: 20,
                  height: 20,
                  color: ref.read(flavorProvider).lightPrimary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
