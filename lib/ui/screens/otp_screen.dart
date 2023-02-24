import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/top_bar_logo.dart';
import 'package:contacta_pharmacy/ui/screens/user_already_exists.dart';
import 'package:contacta_pharmacy/ui/screens/user_created_successfully.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';
import '../custom_widgets/buttons/standard_button.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);
  static const routeName = '/otp-screen';

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final ApisNew _apisNew = ApisNew();
  String? pin;
  dynamic data;

  Future<dynamic> signUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final Response result = await _apisNew.signUp({
        "first_name": data['signup_data']['first_name'],
        "last_name": data['signup_data']['last_name'],
        "country_code": data['signup_data']['country_code'],
        "contact_number": data['signup_data']['contact_number'],
        "country": data['signup_data']['country'],
        "email": data['signup_data']['email'],
        "password": data['signup_data']['password'],
        "user_device_id": prefs.getString('user_device_id'),
        "fcm_token": prefs.getString('fcm_token'),
        "address": data['signup_data']['address'],
        "gender": data['signup_data']['gender'],
        "province": data['signup_data']['province'],
        "date_of_birth": data['signup_data']['date_of_birth'],
        "intrest": data['signup_data']['intrest'],
        "city": data['signup_data']['city'],
        "postal_code": data['signup_data']['postal_code'],
        "pharmacy_id": ref.read(flavorProvider).pharmacyId,
        "promo_accepted": data['signup_data']['promo_accepted'],
        "is_stilo": 1,
      });

      if (result.data == "User exist! use another email") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const UserAlreadyExists(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const UserCreatedSuccessFully(),
          ),
        );
      }
    } catch (e) {
      final result = 0;
    }
  }

  Future<void> sendOTP() async {
    final result = await _apisNew.sendOTP({
      "email": data['email'],
      "contact_number": data['contact_number'],
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
    });
  }

  Future<void> verifyOTP() async {
    // final result = await _apisNew.verifyOTP({
    //   'otp': pin,
    //   "email": data['email'],
    //   "contact_number": data['contact_number'],
    //   "pharmacy_id": ref.read(flavorProvider).pharmacyId,
    // });

    // if (result.data?['message'] == "INVALID_OTP") {
    //   showredToast("Codice OTP non valido", context);
    // } else if (result.statusCode == 200) {
    //   signUp();
    // }

    signUp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    signUp();
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBarLogo(),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TitleText(
                      text: translate(context, 'sent_otp_to_mobile'),
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 16,
                  ),
                  TitleText(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    text: translate(context, 'otp_content'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  //TODO wrap with Theme if needed
                  Center(
                    child: OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 50,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        style: const TextStyle(fontSize: 17),
                        onChanged: (value) {
                          setState(() {
                            pin = value;
                            print(pin);
                          });
                        },
                        onCompleted: (value) {
                          setState(() {
                            pin = value;
                            print(pin);
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  StandardButton(
                    text: translate(context, 'submit'),
                    onTap: () {
                      verifyOTP();
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: translate(
                        context,
                        "otp_not_received",
                      ),
                      style: const TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: translate(context, "resend_code"),
                          //TODO fix
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              sendOTP();
                            },
                          style: TextStyle(
                            color: ref.read(flavorProvider).lightPrimary,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
