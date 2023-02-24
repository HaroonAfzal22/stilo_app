import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class SettingsEditProfile extends ConsumerStatefulWidget {
  const SettingsEditProfile({Key? key}) : super(key: key);
  static const routeName = '/settings-edit-profile';

  @override
  _SettingsEditProfileState createState() => _SettingsEditProfileState();
}

class _SettingsEditProfileState extends ConsumerState<SettingsEditProfile> {
  final _formKey = GlobalKey<FormState>();
  final ApisNew _apisNew = ApisNew();
  DateTime? pickedDate;
  final Map<String, dynamic> _controllers = {
    'name': TextEditingController(),
    'lastName': TextEditingController(),
    'email': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'address': TextEditingController(),
    'city': TextEditingController(),
    'cap': TextEditingController(),
    'province': TextEditingController(),
    'country': TextEditingController(),
    'dateOfBirth': TextEditingController(),
  };

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
    } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(_controllers['email'].text)) {
      showredToast(translate(context, "err_valid_email"), context);
      return false;
    } else if (_controllers['phoneNumber'].text.isEmpty) {
      showredToast(translate(context, "err_mobile"), context);
      return false;
    } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
        .hasMatch(_controllers['phoneNumber'].text)) {
      showredToast(translate(context, "err_valid_mobile"), context);
      return false;
    } else if (_controllers['address'].text.isEmpty) {
      showredToast(translate(context, "err_address"), context);
      return false;
    } else if (_controllers['city'].text.isEmpty) {
      showredToast(translate(context, "err_city"), context);
      return false;
    } else if (_controllers['cap'].text.isEmpty) {
      showredToast(translate(context, "err_postalcode"), context);
      return false;
    } else if (_controllers['province'].text.isEmpty) {
      showredToast(translate(context, "err_province"), context);
      return false;
    } else if (_controllers['country'].text.isEmpty) {
      showredToast(translate(context, "err_country"), context);
      return false;
    } else if (_controllers['dateOfBirth'].text.isEmpty) {
      showredToast(translate(context, "err_dateofbirth"), context);
      return false;
    } else if (pickedDate != null && pickedDate!.isUnderage()) {
      showredToast(translate(context, "err_valid_age"), context);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initUser();
    });
  }

  void initUser() {
    final user = ref.read(authProvider).user;
    if (user != null) {
      _controllers['name'].text = user.firstName;
      _controllers['lastName'].text = user.lastName;
      _controllers['email'].text = user.email;
      _controllers['phoneNumber'].text = user.contactNumber;
      _controllers['city'].text = user.city ?? '';
      _controllers['cap'].text = user.postalCode ?? '';
      _controllers['province'].text = user.province ?? '';
      _controllers['country'].text = user.country ?? '';
      _controllers['dateOfBirth'].text = user.dateOfBirth ?? '';
      _controllers['address'].text = user.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          translate(context, 'view_profile'),
          style: TextStyle(color: ref.read(flavorProvider).primary),
        ),
      ),
      body: ref.read(authProvider).user != null
          ? SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: false,
                        controller: _controllers['name'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'NOME *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: _controllers['lastName'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'COGNOME *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: _controllers['email'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail), labelText: 'EMAIL *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: _controllers['phoneNumber'],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: 'NUMERO DI CELLULARE *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: false,
                        controller: _controllers['address'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: 'INDIRIZZO *'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: false,
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
                              enabled: false,
                              controller: _controllers['cap'],
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: "CAP *"),
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled: false,
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
                        enabled: false,
                        controller: _controllers['country'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.place),
                            labelText: "PAESE *"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: false,

                        /*       onTap: () async {
                          pickedDate = await showDatePicker(
                            context: context,
                            initialDate: pickedDate ?? DateTime.now(),
                            firstDate: DateTime(1930),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate!);
                            setState(() {
                              pickedDate = pickedDate;
                              _controllers['dateOfBirth'].text = formattedDate;
                            });
                          }
                        },*/
                        controller: _controllers['dateOfBirth'],
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            labelText: "DATA DI NASCITA"),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
/*
                      GestureDetector(
                        onTap: () {
                          if (validation()) {
                            print({
                              "user_id": ref.read(authProvider).user?.userId,
                              "name": _controllers['name'].text,
                              "lastName": _controllers['lastName'].text,
                              "email": _controllers['email'].text,
                              "phoneNumber": _controllers['phoneNumber'].text,
                              "address": _controllers['address'].text,
                              "city": _controllers['city'].text,
                              "province": _controllers['province'].text,
                              "cap": _controllers['cap'].text,
                              "country": _controllers['country'].text,
                              "dateOfBirth": _controllers['dateOfBirth'].text,
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                              color: ref.read(flavorProvider).lightPrimary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Text(
                              translate(context, 'edit'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
*/
                      const SizedBox(
                        height: 64,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const NoUser(),
    );
  }
}
