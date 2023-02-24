import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/top_bar_logo.dart';
import 'package:contacta_pharmacy/ui/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../translations/translate_string.dart';
import 'login_screen.dart';

class PreLoginScreen extends ConsumerStatefulWidget {
  const PreLoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<PreLoginScreen> {
  final ApisNew _apisNew = ApisNew();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBarLogo(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Text(
                      '${translate(context, 'welcome')}${ref.read(flavorProvider).pharmacyName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: Column(
                      children: [
                        StandardButton(
                          text: 'Login',
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        StandardButtonLight(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SignUpScreen.routeName);
                          },
                          text: translate(context, 'create_account'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 128,
                  ),
                  //TODO fix
                  const ExploreButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
