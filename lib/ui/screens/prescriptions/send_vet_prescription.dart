import 'dart:convert';
import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/pharma_header.dart';
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
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/bottom_sheets/bottom_sheet_info_vet_prescription.dart';
import '../../custom_widgets/buttons/custom_two_options_button.dart';
import '../../custom_widgets/prescriptions/prescription_expandable_red.dart';
import '../cart/cart_screen.dart';

class SendVetPrescription extends ConsumerStatefulWidget {
  const SendVetPrescription(
      {this.layoutType, this.cartEnabled = false, Key? key})
      : super(key: key);

  final String? layoutType;
  final bool cartEnabled;

  static const routeName = '/send-vet-prescription';
  @override
  SendVetPrescriptionState createState() => SendVetPrescriptionState();
}

class SendVetPrescriptionState extends ConsumerState<SendVetPrescription> {
  List<XFile> imageList = [];
  final ApisNew _apisNew = ApisNew();
  XFile? image;
  String? img64;

  final Map<String, dynamic> _controllers = {
    'numPrescriptionVet': TextEditingController(),
    'codFiscale': TextEditingController(),
    'preferences': TextEditingController(),
  };

  Future<void> sendVetPrescriptionToPharmacy(
      CartProvider cart, bool cartEnabled) async {
    final nav = Navigator.of(context);

    if (cartEnabled) {
      var uuid = const Uuid();
      cart.addPrescriptionToCart(
        Prescription(
          id: uuid.v1(),
          uploadedPhoto: image,
          orderId: null,
          number: _controllers['numPrescriptionVet'].text,
          recipePin: _controllers['codFiscale'].text,
          type: "vet",
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
          "number": _controllers['numPrescriptionVet'].text,
          // "cadico_tax": _controllers['codFiscale'].text,
          "recipe_pin": _controllers['codFiscale'].text,
          "notes": _controllers['preferences'].text,
          "type": "Vet",
          "recipe_image": img64
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

  bool validation() {
    if (image != null && !switchValue) {
      showredToast(translate(context, "err_switch"), context);
      return false;
    } else if (image != null && switchValue) {
      return true;
      //TODO finire
    } else {
      return true;
    }
    /*  } else {
      if (_controllers['numPrescriptionVet'].text.isEmpty) {
        showredToast(translate(context, "err_numPrescriptionVet"), context);
        return false;
      } else if (_controllers['codFiscale'].text.isEmpty) {
        showredToast(translate(context, "err_codFiscale"), context);
        return false;
      }
       else if (!RegExp("[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]")
          .hasMatch(_controllers['codFiscale'].text)) {
        showredToast('Codice fiscale non valido', context);
        return false;

      else if (!switchValue) {
        showredToast(translate(context, "err_switch"), context);
        return false;
      } else
        return true;
    }*/
  }

  bool switchValue = false;
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
                        ? 'submit_veterinary_recipe_parapharmacy'
                        : 'submit_veterinary_recipe_pharmacy'),
                subtitle: translate(
                    context,
                    ref.read(flavorProvider).isParapharmacy
                        ? 'submit_veterinary_des_parapharmacy'
                        : 'submit_veterinary_des_pharmacy'),
                imgUrl: 'assets/images/addrecipt2.png'),
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
                              const BottomSheetInfoVetPrescription(),
                        );
                      },
                      child: const Icon(Icons.info)),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
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
                              alignment: Alignment.centerLeft,
                              child: Text('Numero Ricetta'),
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
                              alignment: Alignment.centerLeft,
                              child: Text('PIN'),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextField(
                                controller: _controllers['codFiscale'],
                                decoration: Constant.borderTextFieldDecoration(
                                    ref.read(flavorProvider).lightPrimary),
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrescriptionExpandableRed(
                  photoCallBack: (p0) => {
                        setState(() {
                          image = p0;
                        })
                      }),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    translate(context, 'add_details'),
                    style: AppTheme.h6Style.copyWith(
                        color: ref.read(flavorProvider).lightPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
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
                ),
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
                          sendVetPrescriptionToPharmacy(
                              cart, widget.cartEnabled);
                        }
                      } else {
                        showredToast(
                            translate(context, 'login_required'), context);
                      }
                    },
                  ),
                  //TODO temp

                  // const SizedBox(
                  //   width: 16,
                  // ),
                  // SecondOptionButton(
                  //   onTap: () {
                  //     if (user != null) {
                  //       if (validation()) {
                  //         var uuid = const Uuid();
                  //         cart.addPrescriptionToCart(
                  //           Prescription(
                  //               id: uuid.v1(),
                  //               uploadedPhoto: image,
                  //               orderId: null,
                  //               cadicoTax: _controllers['codFiscale'].text),
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
