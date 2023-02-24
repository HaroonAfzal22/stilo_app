import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/top_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/MyApplication.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class RecoverPasswordScreen extends ConsumerStatefulWidget {
  const RecoverPasswordScreen({Key? key}) : super(key: key);
  static const routeName = '/recover-password-screen';

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

//TODO finire

class _RecoverPasswordScreenState extends ConsumerState<RecoverPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApisNew _apisNew = ApisNew();

  Future<void> recoverPassword() async {
    if (validation()) {
      final result =
          await _apisNew.recoverPassword({'email': _controller.text});
      if (result.statusCode == 200) {
        showgreenToast(
            "Ti abbiamo inviato tramite e-mail il link per reimpostare la password",
            context,
            ref);

        Navigator.of(context).pop();
      } else {
        showredToast(
            "Si è verificato un errore durante il recupero della password. Riprovare più tardi",
            context);
      }
    }
  }

  bool validation() {
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(_controller.text)) {
      showredToast(translate(context, "err_valid_email"), context);
      return false;
    } else if (_controller.text.isEmpty) {
      showredToast(translate(context, "err_valid_email"), context);
      return false;
    } else {
      return true;
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
            const SizedBox(
              height: 32,
            ),
            TitleText(
                color: Colors.black87,
                text: translate(context, 'reset_password'),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                translate(context, 'reset_password_content'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'EMAIL*',
                  prefixIcon: Icon(Icons.mail_rounded),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: StandardButton(
                onTap: () {
                  // if (validation()) {
                  //   recoverPassword();
                  // }
                  recoverPassword();
                },
                text: translate(context, 'reset_password'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
