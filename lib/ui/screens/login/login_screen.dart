import 'dart:io';

import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/login/recover_password_screen.dart';
import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:contacta_pharmacy/ui/screens/signup_screen.dart';
import 'package:contacta_pharmacy/ui/screens/social_register/complete_profile_register_social.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../providers/site_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';
import '../../custom_widgets/buttons/social_button.dart';
import '../../custom_widgets/top_bar_logo.dart';
import '../multisede/site_select_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/prelogin-screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenRightState();
}

class _LoginScreenRightState extends ConsumerState<LoginScreen> {
  final Map<String, dynamic> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };
  bool hidePassword = true;

  bool validation() {
    if (_controllers['email'].text.isEmpty) {
      showredToast(translate(context, "err_email"), context);
      return false;
      //TODO check regexp
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_controllers['email'].text)) {
      showredToast(translate(context, "err_valid_email"), context);
      return false;
    } else if (_controllers['password'].text.isEmpty) {
      showredToast(translate(context, "err_password"), context);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TopBarLogo(),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _controllers['email'],
                decoration: const InputDecoration(
                  hintText: 'EMAIL*',
                  prefixIcon: Icon(Icons.mail_rounded),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                  obscureText: hidePassword,
                  controller: _controllers['password'],
                  decoration: InputDecoration(
                    hintText: 'PASSWORD*',
                    prefixIcon: const Icon(Icons.mail_rounded),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: Icon(hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off)),
                  )),
            ),
            const SizedBox(
              height: 32,
            ),
            GestureDetector(
              onTap: () async {
                final navigator = Navigator.of(context);
                if (validation()) {
                  var result = await ref.read(authProvider).login(
                      _controllers['email'].text,
                      _controllers['password'].text);
                  if (result == true) {
                    final sites = ref.read(sitesProvider);
                    final site = ref.read(siteProvider);
                    if (sites.length > 1 && site == null) {
                      navigator.pushNamedAndRemoveUntil(
                          SiteSelectScreen.routeName, (route) => false);
                    } else {
                      navigator.pushNamedAndRemoveUntil(
                          MainScreen.routeName, (route) => false);
                    }
                  } else {
                    showredToast(translate(context, 'email_pw_err'), context);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: ref.read(flavorProvider).lightPrimary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RecoverPasswordScreen.routeName);
              },
              child: Text(
                translate(context, "forgot_password"),
              ),
            ),
            const SizedBox(
              height: 64,
            ),
            // if (Constant.isSocialLoginActive)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SocialButtons(
            //         title: translate(context, "login_with_facebook"),
            //         color: AppColors.facebookButtonColor,
            //         image: ic_facebook_logo,
            //         onTap: () async {
            //           final result =
            //               await ref.read(authProvider).signInWithFacebook();
            //           if (result != null) {
            //             //TODO passare nel Map social = Facebook
            //             //TODO creare enum per socialLogin
            //             Navigator.of(context).pushNamedAndRemoveUntil(
            //                 CompleteProfileRegisterSocial.routeName,
            //                 (route) => false,
            //                 arguments: {
            //                   'email': result['email'],
            //                   'name': result['name'],
            //                   'lastName': result['name'],
            //                   'social': 'Facebook'
            //                 });
            //           }
            //         },
            //       ),
            //       const SizedBox(
            //         height: 16,
            //       ),
            //       SocialButtons(
            //         title: translate(context, "login_with_google"),
            //         color: AppColors.googleButtonColor,
            //         image: ic_google_logo,
            //         onTap: () async {
            //           final result =
            //               await ref.read(authProvider).signInWithGoogle();
            //           if (result != null) {
            //             Navigator.of(context).pushNamedAndRemoveUntil(
            //                 CompleteProfileRegisterSocial.routeName,
            //                 (route) => false,
            //                 arguments: {
            //                   'email': result.email,
            //                   'name': result.displayName,
            //                   'lastName': result.displayName,
            //                   'social': 'Google',
            //                 });
            //           }
            //         },
            //       ),
            //       const SizedBox(
            //         height: 16,
            //       ),
            //       if (Platform.isIOS)
            //         SocialButtons(
            //           title: translate(context, "signin_with_apple"),
            //           color: AppColors.black,
            //           image: ic_apple_logo,
            //           onTap: () async {},
            //         ),
            //     ],
            //   ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: translate(context, "no_account"),
                                      style: AppTheme.bodyText.copyWith(
                                          fontSize: 13.0.sp,
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      text:
                                          " ${translate(context, "sign_up_not_ac")}",
                                      style: AppTheme.bodyText.copyWith(
                                          fontSize: 13.0.sp,
                                          color: ref
                                              .read(flavorProvider)
                                              .lightPrimary,
                                          fontWeight: FontWeight.bold)),
                                ])),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SignUpScreen.routeName);
                              //TODO
                            },
                          )
                        ]))),
            const ExploreButton(),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreButton extends ConsumerWidget {
  const ExploreButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0.h),
      child: MaterialButton(
        elevation: 0,
        minWidth: 50.0.w,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0.h),
            side: BorderSide(
              color: (ref.read(flavorProvider).lightPrimary),
            )),
        color: AppColors.white,
        textColor: (ref.read(flavorProvider).lightPrimary),
        onPressed: () {
          final navigator = Navigator.of(context);

          final sites = ref.read(sitesProvider);
          final site = ref.read(siteProvider);
          if (sites.length > 1 && site == null) {
            navigator.pushNamedAndRemoveUntil(
                SiteSelectScreen.routeName, (route) => false);
          } else {
            navigator.pushNamedAndRemoveUntil(
                MainScreen.routeName, (route) => false);
          }
        },
        child: Text(
          translate(context, "explore"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
