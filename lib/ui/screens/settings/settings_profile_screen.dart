import 'package:contacta_pharmacy/ui/screens/settings/settings_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class SettingsProfile extends StatelessWidget {
  const SettingsProfile({Key? key}) : super(key: key);
  static const routeName = '/settings-profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          translate(context, 'sub_setting'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            SettingProfileItem(
              imgUrl: 'assets/icons/ic_profile.png',
              onTap: () {
                Navigator.of(context).pushNamed(SettingsEditProfile.routeName);
              },
              title: translate(context, 'view_profile_settings'),
            ),
            //TODO riattivare con PayPal
            /*     SettingProfileItem(
              imgUrl: 'assets/icons/ic_settings.png',
              onTap: () {
                Navigator.of(context)
                    .pushNamed(SettingsManageAddresses.routeName);
              },
              title: translate(context, 'edit_manage_address'),
            ),*/
            //TODO riattivare con PayPal
            /*   SettingProfileItem(
              imgUrl: 'assets/images/mastercard.png',
              onTap: () {
                Navigator.of(context).pushNamed(SettingsAddCard.routeName);
              },
              title: translate(context, 'manage_card'),
            ),*/
          ],
        ),
      ),
    );
  }
}

class SettingProfileItem extends ConsumerWidget {
  const SettingProfileItem({
    Key? key,
    required this.onTap,
    required this.imgUrl,
    required this.title,
  }) : super(key: key);

  final String title;
  final String imgUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGrey),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_sharp),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
