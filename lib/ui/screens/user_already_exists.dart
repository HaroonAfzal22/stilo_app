import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:flutter/material.dart';

class UserAlreadyExists extends StatelessWidget {
  const UserAlreadyExists({Key? key}) : super(key: key);
  static const routeName = '/user-exist-message';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleText(
            color: Colors.black54,
            text: translate(context, 'user_exist'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: const Center(
              child: Icon(
                Icons.close_rounded,
                size: 65,
                color: Colors.white,
              ),
            ),
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
                  text: translate(context, 'go_login'))),
        ],
      ),
    );
  }
}
