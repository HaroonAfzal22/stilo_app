import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_therapy_sound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class SettingsTherapyScreen extends ConsumerStatefulWidget {
  //TODO controllare overflow su dispositivi più stretti di iphone 12 PRO
  const SettingsTherapyScreen({Key? key}) : super(key: key);
  static const routeName = '/settings-therapy-screen';

  @override
  ConsumerState<SettingsTherapyScreen> createState() =>
      _SettingsNotificationsScreenState();
}

class _SettingsNotificationsScreenState
    extends ConsumerState<SettingsTherapyScreen> {
  bool switchControlActiveNot = false;
  bool switchControlSeeTherapy = false;
  bool switchControladdTherapy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translate(context, 'Therapie_Management')),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "Activate_notification"),
                  style: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0.sp),
                  textAlign: TextAlign.start,
                ),
                Switch(
                  onChanged: (v) {
                    setState(() {
                      switchControlActiveNot = !switchControlActiveNot;
                    });
                  },
                  value: switchControlActiveNot,
                  activeColor: Colors.white,
                  activeTrackColor: ref.read(flavorProvider).lightPrimary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                ),
              ],
            ),
            Text(
              translate(context, "Activate_notification_des"),
              maxLines: 3,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 10.0.sp,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? "Pharmacy_can_see_therapies_parapharmacy"
                          : "Pharmacy_can_see_therapies_pharmacy"),
                  style: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0.sp),
                  textAlign: TextAlign.start,
                ),
                Switch(
                  onChanged: (v) {
                    setState(() {
                      switchControlSeeTherapy = !switchControlSeeTherapy;
                    });
                  },
                  value: switchControlSeeTherapy,
                  activeColor: Colors.white,
                  activeTrackColor: ref.read(flavorProvider).lightPrimary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? "Pharmacy_can_see_therapies_des_parapharmacy"
                          : "Pharmacy_can_see_therapies_des_pharmacy"),
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? "Pharmacy_can_add_therapies_parapharmacy"
                          : "Pharmacy_can_add_therapies_pharmacy"),
                  style: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0.sp),
                  textAlign: TextAlign.start,
                ),
                Switch(
                  onChanged: (v) {
                    setState(() {
                      switchControladdTherapy = !switchControladdTherapy;
                    });
                  },
                  value: switchControladdTherapy,
                  activeColor: Colors.white,
                  activeTrackColor: ref.read(flavorProvider).lightPrimary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? "Pharmacy_can_add_therapies_parapharmacy"
                          : "Pharmacy_can_add_therapies_pharmacy"),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsTherapySoundScreen(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gestione notifica terapia",
                          style: TextStyle(
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0.sp),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Text(
                      "Scegli i suoni di avviso per la terapia",
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGrey),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 30, bottom: 15),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0.h),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.6.h),
                      decoration: BoxDecoration(
                        color: ref.read(flavorProvider).lightPrimary,
                      ),
                      child: Center(
                        child: Text(
                          translate(context, "save"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        )));
  }
}
