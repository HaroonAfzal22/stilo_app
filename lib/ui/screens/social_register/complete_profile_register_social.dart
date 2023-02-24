import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/top_bar_logo.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:contacta_pharmacy/ui/screens/otp_screen.dart';
import 'package:contacta_pharmacy/ui/screens/privacy_policy_screen.dart';
import 'package:contacta_pharmacy/ui/screens/terms_and_conditions_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../config/MyApplication.dart';
import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/buttons/standard_button.dart';

class CompleteProfileRegisterSocial extends ConsumerStatefulWidget {
  const CompleteProfileRegisterSocial({Key? key}) : super(key: key);
  static const routeName = '/complete-profile-register-social';

  @override
  _CompleteProfileRegisterSocialState createState() =>
      _CompleteProfileRegisterSocialState();
}

class _CompleteProfileRegisterSocialState
    extends ConsumerState<CompleteProfileRegisterSocial> {
  Future<void> getInterestList() async {
    final result = await _apisNew.getInterestsList(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );
    dataList = result.data;
    setState(() {});
  }

  Future<void> sendOTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print({
      "first_name": _controllers['name'].text,
      "last_name": _controllers['lastName'].text,
      "country_code": countryCode,
      "contact_number": _controllers['telephone'].text,
      "country": _controllers['country'].text,
      "email": _controllers['email'].text,
      "password": _controllers['password'].text,
      "user_device_id": prefs.getString('user_device_id'),
      "fcm_token": prefs.getString('fcm_token'),
      "address": _controllers['address'].text,
      "gender": _gender,
      "province": _controllers['province'].text,
      "date_of_birth": _controllers['dateOfBirth'].text,
      "intrest": _myActivities,
      "city": _controllers['city'].text,
      "postal_code": _controllers['postalCode'].text,
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
      "promo_accepted": checked[2],
    });
    final result = await _apisNew.sendOTP({
      "email": _controllers['email'].text,
      "contact_number": countryCode + _controllers['telephone'].text,
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
    });
    if (result is Response) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        OtpScreen.routeName,
        (route) => false,
        arguments: {
          "email": _controllers['email'].text,
          "contact_number": countryCode + _controllers['telephone'].text,
          "signup_data": {
            "first_name": _controllers['name'].text,
            "last_name": _controllers['lastName'].text,
            "country_code": countryCode,
            "contact_number": _controllers['telephone'].text,
            "country": _controllers['country'].text,
            "email": _controllers['email'].text,
            "password": _controllers['password'].text,
            "user_device_id": prefs.getString('user_device_id'),
            "fcm_token": prefs.getString('fcm_token'),
            "address": _controllers['address'].text,
            "gender": _gender,
            "province": _controllers['province'].text,
            "date_of_birth": _controllers['dateOfBirth'].text,
            "intrest": _myActivities,
            "city": _controllers['city'].text,
            "postal_code": _controllers['postalCode'].text,
            "pharmacy_id": ref.read(flavorProvider).pharmacyId,
            "promo_accepted": checked[2],
          }
        },
      );
    } else {
      showredToast("Si è verificato un errore nell'invio dell'OTP", context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      socialData =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      if (socialData != null) {
        if (socialData?['social'] == 'Google') {
          var splitted = socialData?['name'].split(' ');
          _controllers['name'].text = splitted[0] ?? '';
          _controllers['lastName'].text = splitted[1] ?? '';
          _controllers['email'].text = socialData?['email'] ?? '';
        } else if (socialData?['social'] == 'Facebook') {
          var splitted = socialData?['name'].split(' ');
          _controllers['name'].text = splitted[0] ?? '';
          _controllers['lastName'].text = splitted[1] ?? '';
          _controllers['email'].text = socialData?['email'] ?? '';
        }
      }
      setState(() {});
    });
    getInterestList();
  }

  Map<String, dynamic>? socialData;
  String? socialType;
  final ApisNew _apisNew = ApisNew();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  DateTime? picked;
  List<bool> checked = [false, false, false];
  String? _gender;
  String countryCode = '+39';

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _controllers = {
    'name': TextEditingController(),
    'lastName': TextEditingController(),
    'email': TextEditingController(),
    'telephone': TextEditingController(),
    'address': TextEditingController(),
    'city': TextEditingController(),
    'postalCode': TextEditingController(),
    'province': TextEditingController(),
    'country': TextEditingController(),
    'dateOfBirth': TextEditingController(),
  };
  bool? value = false;
  List dataList = [];
  List _myActivities = [];

  bool validation() {
    if (_controllers['name'].text.isEmpty) {
      showredToast(translate(context, "err_firstname"), context);
      return false;
    } else if (_controllers['lastName'].text.isEmpty) {
      showredToast(translate(context, "err_lastname"), context);
      return false;
    } else if (_controllers['email'].text.isEmpty) {
      showredToast(translate(context, "err_email"), context);
      return false;
      //TODO CHECK
    } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(_controllers['email'].text)) {
      showredToast(translate(context, "err_valid_email"), context);
      return false;
    } else if (_controllers['email'].text.isEmpty) {
      showredToast(translate(context, "err_password"), context);
      return false;
    } else if (_controllers['telephone'].text.isEmpty) {
      showredToast(translate(context, "err_mobile"), context);
      return false;
    } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
        .hasMatch(_controllers['telephone'].text)) {
      showredToast(translate(context, "err_valid_mobile"), context);
      return false;
    } else if (_controllers['address'].text.isEmpty) {
      showredToast(translate(context, "err_address"), context);
      return false;
    } else if (_controllers['city'].text.isEmpty) {
      showredToast(translate(context, "err_city"), context);
      return false;
    } else if (_controllers['postalCode'].text.isEmpty) {
      showredToast(translate(context, "err_postalcode"), context);
      return false;
    } else if (_controllers['province'].text.isEmpty) {
      showredToast(translate(context, "err_province"), context);
      return false;
    } else if (countryCode.isEmpty) {
      showredToast(translate(context, "err_country_code"), context);
      return false;
    } else if (_controllers['dateOfBirth'].text.isEmpty) {
      showredToast(translate(context, "err_DOB"), context);
      return false;
    } else if (_gender == null) {
      showredToast(translate(context, "err_gender"), context);
      return false;
    } else if (picked != null && picked!.isUnderage()) {
      showredToast(translate(context, "err_valid_age"), context);
      return false;
    } else if (checked[0] == false) {
      showredToast(translate(context, "accept_terms"), context);
      return false;
    } else if (checked[1] == false) {
      showredToast(translate(context, "accept_privacy_policy"), context);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //TODO verificare perchè necessario (probabilmente è il chechboxListTile)
    return ExcludeSemantics(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const TopBarLogo(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        'Completa il tuo profilo ora',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 22.0.sp,
                                color: Colors.grey[800]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Completa i seguenti campi per registrarti gratis.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0.sp,
                              ),
                            )),
                      ),
                      TextFormField(
                        controller: _controllers['name'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'NOME *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _controllers['lastName'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'COGNOME *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _controllers['email'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail), labelText: 'EMAIL *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CountryCodePicker(
                                onChanged: (v) {
                                  setState(() {
                                    countryCode = v.dialCode!;
                                  });
                                },

                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                showFlagDialog: false,
                                initialSelection: 'IT',
                                //comparator: (a, b) => b.name.compareTo(a.name),
                                flagWidth: 20.0,
                                //Get the country information relevant to the initial selection
                                onInit: (code) =>
                                    {countryCode = code!.dialCode!}),
                          ),
                          Expanded(
                            flex: 7,
                            child: TextFormField(
                              controller: _controllers['telephone'],
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  labelText: 'NUMERO DI CELLULARE *'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _controllers['address'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: 'INDIRIZZO *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _controllers['city'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.location_city_rounded),
                            labelText: "CITTA' *"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _controllers['postalCode'],
                              decoration:
                                  const InputDecoration(labelText: "CAP *"),
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _controllers['province'],
                              decoration: const InputDecoration(
                                  labelText: "PROVINCIA *"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _controllers['country'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.place),
                            labelText: "PAESE *"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MultiSelectFormField(
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lightGrey),
                        ),
                        autovalidate: AutovalidateMode.disabled,
                        chipBackGroundColor: ref.read(flavorProvider).primary,
                        chipLabelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        dialogTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor:
                            ref.read(flavorProvider).lightPrimary,
                        checkBoxCheckColor: AppColors.white,
                        dialogShapeBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        title: const Text(
                          'INTERESSI',
                          style: TextStyle(fontSize: 16),
                        ),
                        dataSource: dataList,
                        textField: 'name',
                        valueField: 'name',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: "cancel",
                        fillColor: AppColors.white,
                        hintWidget: Text(
                          translate(context, "please_choose"),
                        ),
                        initialValue: _myActivities,
                        onSaved: (value) {
                          List arry = [];

                          if (value == null) return;
                          setState(() {
                            _myActivities = value;
                          });
                          for (int i = 0; i < _myActivities.length; i++) {
                            arry.add(_myActivities[i].toString());
                          }
                          setState(() {
                            _myActivities = arry;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _controllers['dateOfBirth'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            labelText: "DATA DI NASCITA"),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: picked ?? DateTime.now(),
                            firstDate: DateTime(1930),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            setState(() {
                              picked = pickedDate;
                              _controllers['dateOfBirth'].text = formattedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      FormField(
                        builder: (FormFieldState state) {
                          return DropdownButtonHideUnderline(
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: <Widget>[
                                  InputDecorator(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          top: 3.0.h,
                                        ),
                                        labelText: translate(context, "gender"),
                                        labelStyle: const TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16),
                                        prefixIcon: Icon(Icons.wc_rounded,
                                            size: 4.0.h,
                                            color: ref
                                                .read(flavorProvider)
                                                .lightPrimary)),
                                    child: DropdownButtonHideUnderline(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: DropdownButtonFormField<String>(
                                          hint: Text(
                                            translate(context, "select_gender"),
                                            style: AppTheme.h3Style.copyWith(
                                                fontSize: 14.0.sp,
                                                color: AppColors.black),
                                          ),
                                          value: _gender,
                                          onChanged: (String? newValue) {
                                            state.didChange(newValue);
                                            setState(() {
                                              _gender = newValue;
                                            });
                                          },
                                          items: <String>[
                                            (translate(context, "male")),
                                            (translate(context, "female")),
                                            (translate(context, "other")),
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CheckboxListTile(
                        value: checked[0],
                        onChanged: (bool? value) {
                          setState(() {
                            checked[0] = value!;
                          });
                        },
                        activeColor: ref.read(flavorProvider).primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        subtitle: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: translate(context,
                                    "I confirm that I have read,consent and"),
                                style: AppTheme.bodyText.copyWith(
                                    color: AppColors.lightGrey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.0.sp)),
                            TextSpan(
                              text: translate(context, "agree to the"),
                              style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.0.sp),
                            ),
                            TextSpan(
                              text:
                                  ' ${translate(context, "Terms_Conditions")}.',
                              style: TextStyle(
                                color: AppColors.blueColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.0.sp,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => showModalBottomSheet(
                                    context: context,
                                    builder: (builder) {
                                      return const TermsConditionScreen();
                                    }),
                            )
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CheckboxListTile(
                        activeColor: ref.read(flavorProvider).primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: checked[1],
                        onChanged: (bool? value) {
                          setState(() {
                            checked[1] = value!;
                          });
                        },
                        subtitle: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: translate(context,
                                    "I confirm that I have read and accept") +
                                ' ',
                            style: TextStyle(
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.0.sp),
                          ),
                          TextSpan(
                            text: translate(context, "Privacy_Policy") + '.',
                            style: TextStyle(
                              color: AppColors.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.0.sp,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => showModalBottomSheet(
                                    context: context,
                                    builder: (builder) {
                                      return const PrivacyPolicyScreen();
                                    },
                                  ),
                          ),
                        ])),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CheckboxListTile(
                          activeColor: ref.read(flavorProvider).primary,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: checked[2],
                          onChanged: (bool? value) {
                            setState(() {
                              checked[2] = value!;
                            });
                          },
                          subtitle: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: translate(context,
                                      "I agree to recieve general emails and"),
                                  style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.0.sp)),
                              TextSpan(
                                  text: translate(
                                      context,
                                      ref.read(flavorProvider).isParapharmacy
                                          ? "product offers from Contacta Parapharmacy"
                                          : "product offers from Contacta Pharmacy"),
                                  style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.0.sp)),
                            ]),
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      StandardButton(
                        onTap: () {
                          if (validation()) {
                            sendOTP();
                          }
                        },
                        text: translate(context, 'sign_up'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Sei già registrato? ',
                          style: const TextStyle(color: AppColors.black),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const PreLoginScreen()))
                                    },
                              text: 'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: ref.read(flavorProvider).primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
