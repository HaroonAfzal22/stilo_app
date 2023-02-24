import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';

class UserCreatedSuccessFully extends ConsumerWidget {
  const UserCreatedSuccessFully({Key? key}) : super(key: key);
  static const routeName = '/user-created-successfully';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleText(
            color: Colors.black54,
            text: translate(context, 'confirm_registration'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
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
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      PreLoginScreen.routeName, (route) => false);
                },
                text: translate(context, 'go_login')),
          ),
        ],
      ),
    );
  }
}
