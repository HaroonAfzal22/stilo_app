import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_change_language.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_change_password.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../translations/translate_string.dart';

class SettingsGeneralScreen extends ConsumerWidget {
  const SettingsGeneralScreen({Key? key}) : super(key: key);
  static const routeName = '/settings-general-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'General_Setting'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            if (ref.read(authProvider).user != null)
              SettingProfileItem(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(SettingsChangePassword.routeName);
                },
                imgUrl: 'assets/icons/ic_lock.png',
                title: translate(context, 'change_password'),
              ),
            SettingProfileItem(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(SettingsChangeLanguage.routeName);
              },
              imgUrl: 'assets/icons/language.png',
              title: translate(context, 'change_language'),
            ),
            //TODO fix
            /*       SettingProfileItem(
              onTap: () {},
              imgUrl: 'assets/icons/ic_remove.png',
              title: translate(context, 'remove_cache'),
            ),*/
            //TODO ripristinare
            /*   if (ref.read(authProvider).user != null)
              SettingProfileItem(
                onTap: () {},
                imgUrl: 'assets/icons/ic_remove.png',
                title: translate(context, 'delete_account'),
              )*/
          ],
        ),
      ),
    );
  }
}
