import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class SettingsNotificationsScreen extends ConsumerStatefulWidget {
  const SettingsNotificationsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings-notifications';

  @override
  ConsumerState<SettingsNotificationsScreen> createState() =>
      _SettingsNotificationsScreenState();
}

class _SettingsNotificationsScreenState
    extends ConsumerState<SettingsNotificationsScreen> {
  bool switchControlEmail = false;
  bool switchControlChat = false;
  bool switchControlStock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            translate(context, 'notification'),
          ),
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
                  translate(context, "Email_notifications"),
                  style: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0.sp),
                ),
                // SizedBox(width: MediaQuery.of(context).size.width*0.,),

                // SwitchWidget(notificationrequest()),

                Switch(
                  onChanged: (v) {
                    setState(() {
                      switchControlEmail = !switchControlEmail;
                    });

                    // getNotification(v, "email_notifications");
                    // PreferenceUtils.setBool("Email notifications", v);
                  },
                  value: switchControlEmail,
                  activeColor: Colors.white,
                  activeTrackColor: ref.read(flavorProvider).lightPrimary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                )

                // SwitchWidget(
                //     onSelect: getNotification, type: "${translate(context, "Email_notifications")}",controll: PreferenceUtils.getBool("Email Notification"), ),
                //
              ],
            ),
            Row(
              children: [
                Text(
                  translate(context, "Email_notifications_des"),
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10.0.sp,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "Chat_Notifications"),
                  style: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0.sp),
                ),
                Switch(
                  value: switchControlChat,
                  onChanged: (v) {
                    setState(() {
                      switchControlChat = !switchControlChat;
                    });

                    // getNotification(
                    //     v, "${translate(context, "Chat_Notifications")}");
                  },
                  activeColor: Colors.white,
                  activeTrackColor: ref.read(flavorProvider).lightPrimary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                ),

                //SizedBox(width: MediaQuery.of(context).size.width*0.4,),
                // SwitchWidget(
                //     onSelect: getNotification, type: "${translate(context, "Chat_Notifications")}" , controll: PreferenceUtils.getBool("Chat Notification")),
              ],
            ),
            Text(
              translate(
                  context,
                  ref.read(flavorProvider).isParapharmacy
                      ? "Chat_Notifications_des_parapharmacy"
                      : "Chat_Notifications_des_pharmacy"),
              maxLines: 2,
              style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "Stock_Notifications"),
                  style: TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0.sp),
                ),
                Switch(
                  onChanged: (v) {
                    setState(() {
                      switchControlStock = !switchControlStock;
                    });

                    // getNotification(v, "stock_notifications");
                    // PreferenceUtils.setBool("Stock Notifications", v);
                  },
                  value: switchControlStock,
                  activeColor: Colors.white,
                  activeTrackColor: ref.read(flavorProvider).lightPrimary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                )

                //SizedBox(width: MediaQuery.of(context).size.width*0.4,),
                // SwitchWidget(
                //     onSelect: getNotification, type: "${translate(context, "Stock_Notifications")}",controll: PreferenceUtils.getBool("Stock Notification")),
              ],
            ),
            Text(
              translate(context, "Stock_Notifications_des"),
              maxLines: 2,
              style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey),
            ),
            // Text('', textAlign: TextAlign.justify,style: TextStyle(fontSize: 12,color: AppColors.lightgarytext1),),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 30, bottom: 15),
              child: InkWell(
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
