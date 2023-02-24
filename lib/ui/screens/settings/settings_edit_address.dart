import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/models/address.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class SettingsEditAddress extends StatefulWidget {
  const SettingsEditAddress({Key? key}) : super(key: key);
  static const routeName = '/settings-edit-address';

  @override
  _SettingsEditAddressState createState() => _SettingsEditAddressState();
}

class _SettingsEditAddressState extends State<SettingsEditAddress> {
  final ApisNew _apisNew = ApisNew();
  String? addressType;
  final Map<String, dynamic> _controllers = {
    'name': TextEditingController(),
    'lastName': TextEditingController(),
    'address': TextEditingController(),
    'cap': TextEditingController(),
    'province': TextEditingController(),
    'region': TextEditingController(),
    'country': TextEditingController(),
  };

  validation() {
    if (_controllers['name'].text.length < 2) {
      showredToast(translate(context, "err_firstname"), context);
      return false;
    } else if (_controllers['lastName'].text.length < 2) {
      showredToast(translate(context, "err_lastname"), context);
      return false;
    } else if (_controllers['address'].text.length < 5) {
      showredToast(translate(context, "err_address"), context);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      address = ModalRoute.of(context)!.settings.arguments as Address;
      //todo aggiungi cognome
      //todo correggi tipi lavori in ingresso
      //_controllers['lastName'] = address!.lastName;
      //addressType = "work";
      _controllers['name'].text = address!.name;
      _controllers['address'].text = address!.address;
      _controllers['cap'].text = address!.cap;
      _controllers['province'].text = address!.province;
      _controllers['region'].text = address!.region;
      _controllers['country'].text = address!.country;
      setState(() {});
    });
  }

  Address? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            translate(context, 'edit_address'),
          ),
        ),
        body: address != null
            ? SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, "adress_managment"),
                          style: AppTheme.h3Style.copyWith(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black)),
                      Text(
                        translate(context, "desc_address_management"),
                        style: AppTheme.h3Style.copyWith(
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black.withOpacity(.6),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: <Widget>[
                              InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    top: 3.0.h,
                                  ),
                                  labelText: translate(context, "address_type"),
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 16),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: DropdownButtonFormField<String>(
                                      hint: Text(
                                        translate(
                                            context, "select_adress_types"),
                                        style: AppTheme.h3Style.copyWith(
                                            fontSize: 10.0.sp,
                                            color: AppColors.grey),
                                      ),
                                      value: addressType,
                                      onChanged: (String? newValue) {
                                        addressType = newValue;
                                      },
                                      items: <String>[
                                        (translate(context, "work")),
                                        (translate(context, "home")),
                                        (translate(context, "others")),
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.white)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.white))),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controllers['name'],
                              decoration: InputDecoration(
                                labelText: translate(context, "first_name") +"*",
                                contentPadding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 5.0, 5.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _controllers['lastName'],
                              decoration: InputDecoration(
                                labelText: translate(context, "last_name")+"*",
                                contentPadding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 5.0, 5.0),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _controllers['address'],
                        decoration: InputDecoration(
                          labelText: translate(context, "address")+"*",
                          contentPadding:
                              const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controllers['cap'],
                              decoration: InputDecoration(
                                labelText: translate(context, "cap"),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 5.0, 5.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _controllers['province'],
                              decoration: InputDecoration(
                                labelText: translate(context, "province"),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 5.0, 5.0),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controllers['region'],
                              decoration: InputDecoration(
                                labelText: translate(context, "region"),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 5.0, 5.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _controllers['country'],
                              decoration: InputDecoration(
                                labelText: translate(context, "country"),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 5.0, 5.0),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: CustomOutlinedButton(
                            text: translate(context, 'save_changes'),
                            onTap: () {
                              if (validation()) {
                                Address updatedAddress = Address(
                                  userId: "1394",
                                  id: address!.id,
                                  addressType: addressType,
                                  name: _controllers['name'].text,
                                  address: _controllers['address'].text,
                                  cap: _controllers['cap'].text,
                                  province: _controllers['province'].text,
                                  region: _controllers['region'].text,
                                  country: _controllers['country'].text,
                                );
                                _apisNew.updateAddress(updatedAddress.toJson());
                                Navigator.pop(context);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
