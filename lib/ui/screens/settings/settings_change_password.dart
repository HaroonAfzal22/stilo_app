import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/top_bar_logo.dart';
import 'package:contacta_pharmacy/ui/screens/settings/password_changed_successfully.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/MyApplication.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class SettingsChangePassword extends ConsumerStatefulWidget {
  const SettingsChangePassword({Key? key}) : super(key: key);
  static const routeName = '/settings-change-password';

  @override
  _SettingsChangePasswordState createState() => _SettingsChangePasswordState();
}

class _SettingsChangePasswordState
    extends ConsumerState<SettingsChangePassword> {
  bool hideOldPassword = false;
  bool hideNewPassword = false;
  bool hideRepeatPassword = false;
  final ApisNew _apisNew = ApisNew();

  final Map<String, dynamic> _controllers = {
    'oldPassword': TextEditingController(),
    'newPassword': TextEditingController(),
    'repeatPassword': TextEditingController(),
  };

  bool isPasswordCompliant(String? password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters;
  }

  bool validate() {
    if (!isPasswordCompliant(_controllers['newPassword'].text)) {
      showredToast(translate(context, "err_password_uppercase"), context);
      return false;
    }
    if (_controllers['newPassword'].text !=
        _controllers['repeatPassword'].text) {
      showredToast(translate(context, 'err_password_not_match'), context);
      return false;
    }
    if (_controllers['newPassword'].text == _controllers['oldPassword']) {
      showredToast(
          'La nuova password non può coincidere con la vecchia', context);
      return false;
    }
    return true;
  }

  Future<void> changePassword() async {
    final result = await _apisNew.changePassword({
      'user_id': ref.read(authProvider).user?.userId,
      'old_password': _controllers['oldPassword'].text,
      'new_password': _controllers['newPassword'].text,
      'confirm_password': _controllers['repeatPassword'].text,
    });
    if (result.statusCode == 200) {
      //TODO fix
      /* showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:  [
                const Text('Password Modificata con successo'),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                  ref.read(authProvider).logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      PreLoginScreen.routeName, (route) => false);
                },
                  child: Container(
                    width: 130,
                    height: 30,
                    decoration: const  BoxDecoration(
                      color: ref.read(flavorProvider).primary,
                      borderRadius: BorderRadius.all(Radius.circular(4))

                    ),
                    child: const Center(child: Text("Riavvia",
                    style:  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      ),
                    )),),
                ),
              ],
            ),
          ),
        ),
      );
   */
    }
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
          children: [
            const TopBarLogo(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    translate(context, "new_password"),
                    style: const TextStyle(
                      fontSize: 30,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    translate(context, "new_password_des"),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    obscureText: !hideOldPassword,
                    controller: _controllers['oldPassword'],
                    decoration: InputDecoration(
                      labelText: translate(context, 'old_password') + ' *',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            hideOldPassword = !hideOldPassword;
                          });
                        },
                        child: Icon(hideOldPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    obscureText: !hideNewPassword,
                    controller: _controllers['newPassword'],
                    decoration: InputDecoration(
                      labelText: translate(context, 'new_password') + ' *',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            hideNewPassword = !hideNewPassword;
                          });
                        },
                        child: Icon(hideNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      obscureText: !hideRepeatPassword,
                      controller: _controllers['repeatPassword'],
                      decoration: InputDecoration(
                        labelText:
                            translate(context, 'confirm_password') + ' *',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hideRepeatPassword = !hideRepeatPassword;
                            });
                          },
                          child: Icon(hideRepeatPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      )),
                  const SizedBox(
                    height: 64,
                  ),
                  StandardButton(
                    onTap: () {
                      if (validate()) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const PasswordChangedSuccessfully(),
                          ),
                        );
                      }
                    },
                    text: translate(context, 'change_password'),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
