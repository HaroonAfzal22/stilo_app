import 'dart:convert';
import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/custom_two_options_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/pharma_header.dart';
import 'package:contacta_pharmacy/ui/screens/cart/cart_screen.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescription_sent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../models/prescription.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/bottom_sheets/bottom_sheet_info_med_prescription.dart';
import '../../custom_widgets/prescriptions/prescription_expandable_red.dart';

class SendMedPrescription extends ConsumerStatefulWidget {
  final String? layoutType;
  final bool cartEnabled;
  const SendMedPrescription(
      {this.layoutType, this.cartEnabled = false, Key? key})
      : super(key: key);
  static const routeName = '/send-med-prescription';
  @override
  SendMedPrescriptionState createState() => SendMedPrescriptionState();
}

class SendMedPrescriptionState extends ConsumerState<SendMedPrescription> {
  List<XFile>? imageList = [];
  final ApisNew _apisNew = ApisNew();

  final Map<String, dynamic> _controllers = {
    'numPrescriptionMed': TextEditingController(),
    'codFiscale': TextEditingController(),
    'prefixPrescription': TextEditingController(),
    'preferences': TextEditingController(),
  };
  bool switchValue = false;
  String selectedValue = 'Generico';
  XFile? image;

  bool validation() {
    if (image != null && !switchValue) {
      showredToast(translate(context, "err_switch"), context);
      return false;
    } else if (image != null && switchValue) {
      return true;
    } else {
      if (_controllers['prefixPrescription'].text.isEmpty) {
        showredToast(translate(context, "err_prefix_prescription"), context);
        return false;
      } else if (_controllers['numPrescriptionMed'].text.isEmpty) {
        showredToast(translate(context, "err_numPrescriptionMed"), context);
        return false;
      } else if (_controllers['codFiscale'].text.isEmpty) {
        showredToast(translate(context, "err_codFiscale"), context);
        return false;
      } else if (!RegExp("[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]")
          .hasMatch(_controllers['codFiscale'].text)) {
        showredToast(translate(context, 'err_codFiscale'), context);
        return false;
      } else if (!switchValue) {
        showredToast(translate(context, "err_switch"), context);
        return false;
      }
      return true;
    }
  }

  Future<void> sendMedPrescriptionToPharmacy(
      CartProvider cart, bool cartEnabled) async {
    final nav = Navigator.of(context);

    if (cartEnabled) {
      var uuid = const Uuid();

      cart.addPrescriptionToCart(
        Prescription(
          id: uuid.v1(),
          orderId: null,
          number: _controllers['prefixPrescription'].text,
          cadicoTax: _controllers['codFiscale'].text,
          recipePin: _controllers['numPrescriptionMed'].text,
          type: "med",
          uploadedPhoto: image,
        ),
      );
      Navigator.of(context)
          .pushReplacementNamed(CartScreen.routeName, arguments: 1);
    } else {
      try {
        EasyLoading.show(status: 'Caricamento');
        EasyLoading.instance.userInteractions = false;

        String? img64;
        if (image != null) {
          final bytes = File(image!.path).readAsBytesSync();
          img64 = base64Encode(bytes);
        }

        final result = await _apisNew.sendPrescriptionToPharmacy({
          "user_id": ref.read(authProvider).user?.userId,
          "pharmacy_id": ref.read(flavorProvider).pharmacyId,
          "number": _controllers['numPrescriptionMed'].text,
          "cadico_tax": _controllers['codFiscale'].text,
          "drug_preference": selectedValue,
          "notes": _controllers['preferences'].text,
          "type": "Medical",
          "recipe_pin": _controllers['prefixPrescription'].text,
          "recipe_image": img64,
        });

        if (result.statusCode == 200) {
          nav.pushNamedAndRemoveUntil(ItemSent.routeName, (route) => false);
        } else {
          throw Exception();
        }
      } catch (e) {
        showredToast(
            "Si è verificato un errore durante l'invio della ricetta. Riprovare più tardi",
            context);
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  void initState() {
    super.initState();
/*    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                "Ricorda di consegnare la ricetta in farmacia (la ricetta inviata non sostituisce la ricetta cartacea)"
                )
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ho capito'),
                )
              ],
            ),
          ),
        ),
      );
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          translate(context, 'submit_recipe'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PharmaHeader(
              title: translate(
                  context,
                  ref.read(flavorProvider).isParapharmacy
                      ? 'send_medical_prescription_parapharmacy'
                      : 'send_medical_prescription_pharmacy'),
              subtitle: translate(
                  context,
                  ref.read(flavorProvider).isParapharmacy
                      ? 'medical_prescription_subtitle_parapharmacy'
                      : 'medical_prescription_subtitle_pharmacy'),
              imgUrl: 'assets/images/addrecipt.png',
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    translate(context, 'recipe_module1'),
                    style: AppTheme.h6Style.copyWith(
                        color: ref.read(flavorProvider).lightPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) =>
                            const BottomSheetInfoMedPrescription(),
                      );
                    },
                    child: const Icon(Icons.info),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (ref.read(flavorProvider).hasElectronicReceipt)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 4,
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: Text(
                        translate(context, 'electronic_recipe'),
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        translate(context, 'select_electronic_recipe'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: AppTheme.bodyText.copyWith(
                            fontSize: 8.0.sp, color: AppColors.lightGrey),
                      ),
                      leading: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Image.asset('assets/icons/e_reciet.png')),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              const Align(
                                child: Text('Numero Ricetta'),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              widget.layoutType == "med"
                                  ? Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: TextFormField(
                                              controller: _controllers[
                                                  'prefixPrescription'],
                                              decoration: Constant
                                                  .borderTextFieldDecoration(ref
                                                      .read(flavorProvider)
                                                      .lightPrimary),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              onChanged: (val) {}),
                                        ),
                                        const SizedBox(
                                          width: 32,
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: TextFormField(
                                              controller: _controllers[
                                                  'numPrescriptionMed'],
                                              decoration: Constant
                                                  .borderTextFieldDecoration(ref
                                                      .read(flavorProvider)
                                                      .lightPrimary),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              onChanged: (val) {}),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        const SizedBox(),
                                        Expanded(
                                          child: TextFormField(
                                              controller: _controllers[
                                                  'numPrescriptionVet'],
                                              decoration: Constant
                                                  .borderTextFieldDecoration(ref
                                                      .read(flavorProvider)
                                                      .lightPrimary),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              onChanged: (val) {}),
                                        ),
                                      ],
                                    ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Align(
                                child: Text('Codice Fiscale'),
                                alignment: Alignment.centerLeft,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                  controller: _controllers['codFiscale'],
                                  decoration:
                                      Constant.borderTextFieldDecoration(ref
                                          .read(flavorProvider)
                                          .lightPrimary),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9a-zA-Z]")),
                                    UpperCaseTextFormatter(),
                                  ], // Only num
                                  onChanged: (val) {}),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (ref.read(flavorProvider).hasElectronicReceipt)
              const SizedBox(
                height: 20,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrescriptionExpandableRed(photoCallBack: (p0) {
                setState(() {
                  image = p0;
                });
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  translate(context, 'add_details'),
                  style: AppTheme.h6Style.copyWith(
                      color: ref.read(flavorProvider).lightPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  translate(context, 'indicates_preferences'),
                  style: AppTheme.h2Style.copyWith(
                      color: AppColors.darkGrey.withOpacity(.5),
                      fontSize: 14.0.sp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                isExpanded: true,
                // value: translate(context, 'No preference'),
                value: selectedValue,
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 0.75,
                  color: Colors.black54,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      selectedValue = newValue;
                    }
                  });
                },
                items: <String>[
                  'Generico',
                  'Originale',
                  'No preferenze',
                  /*       translate(context, 'Generic'),
                  translate(context, 'Original pharmacy'),
                  translate(context, 'No preference'),*/
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                child: Text(
                  translate(context, 'indicates_preferences'),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _controllers['preferences'],
                decoration: Constant.borderTextFieldDecoration(
                        ref.read(flavorProvider).lightPrimary)
                    .copyWith(
                  hintText: translate(
                    context,
                    'Enter_notes_preferences',
                  ),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 2,
                maxLines: 5,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      translate(
                          context,
                          ref.read(flavorProvider).isParapharmacy
                              ? 'agree_text_parapharmacy'
                              : 'agree_text_pharmacy'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Switch(
                        value: switchValue,
                        onChanged: (val) {
                          setState(() {
                            switchValue = !switchValue;
                          });
                        }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FirstOptionButton(
                    onTap: () {
                      if (user != null) {
                        if (validation()) {
                          sendMedPrescriptionToPharmacy(
                              cart, widget.cartEnabled);
                        }
                      } else {
                        showredToast(
                            translate(context, 'login_required'), context);
                      }
                    },
                  ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  // SecondOptionButton(
                  //   onTap: () {
                  //     if (user != null) {
                  //       var uuid = const Uuid();
                  //       if (validation()) {
                  //         cart.addPrescriptionToCart(
                  //           Prescription(
                  //             uploadedPhoto: image,
                  //             id: uuid.v1(),
                  //             orderId: null,
                  //             number: _controllers['prefixPrescription'].text,
                  //             cadicoTax: _controllers['codFiscale'].text,
                  //             recipePin:
                  //                 _controllers['numPrescriptionMed'].text,
                  //           ),
                  //         );
                  //         Navigator.of(context).pushReplacementNamed(
                  //             CartScreen.routeName,
                  //             arguments: 1);
                  //       }
                  //     } else {
                  //       showredToast(
                  //           translate(context, 'login_required'), context);
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 64,
            ),
          ],
        ),
      ),
    );
  }
}
