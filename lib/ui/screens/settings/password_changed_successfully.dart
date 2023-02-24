import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';

class PasswordChangedSuccessfully extends ConsumerStatefulWidget {
  static String routeName = "/password-changed-successfully";

  const PasswordChangedSuccessfully({Key? key}) : super(key: key);

  @override
  _PasswordChangedSuccessfullyState createState() =>
      _PasswordChangedSuccessfullyState();
}

class _PasswordChangedSuccessfullyState
    extends ConsumerState<PasswordChangedSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleText(
            color: Colors.black54,
            text: translate(context, "change_pw"),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Icon(
            Icons.check_circle,
            size: 65,
            color: ref.read(flavorProvider).lightPrimary,
          ),
          const SizedBox(
            height: 64,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: StandardButton(
                onTap: () {
                  ref.read(authProvider).logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      PreLoginScreen.routeName, (route) => false);
                },
                text: 'Login'),
          ),
        ],
      ),
    );
  }
}
