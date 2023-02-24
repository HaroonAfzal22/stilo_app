import 'dart:convert';
import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/permissionConfig.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/prescription_expandable_red.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/prescriptions/pharma_header.dart';
import '../prescriptions/prescription_sent.dart';

class GalenicPreparationScreen extends ConsumerStatefulWidget {
  const GalenicPreparationScreen({Key? key}) : super(key: key);
  static const routeName = '/galenic-preparation-screen';

  @override
  ConsumerState<GalenicPreparationScreen> createState() =>
      _GalenicPreparationScreenState();
}

class _GalenicPreparationScreenState
    extends ConsumerState<GalenicPreparationScreen> {
  final picker = ImagePicker();
  List<XFile> imageList = [];
  final ApisNew _apisNew = ApisNew();

  final Map<String, dynamic> _controllers = {
    'galenicNotes': TextEditingController(),
  };

  bool validation() {
    if (image == null) {
      showredToast(translate(context, "err_image"), context);
      return false;
    }
    if (!switchValue) {
      showredToast(translate(context, "err_switch"), context);
      return false;
    } else {
      return true;
    }
  }

  Future<void> sendGalenicPreparationToPharmacy() async {
    String? img64;
    if (ref.read(authProvider).user == null) {
      showredToast(translate(context, 'login_required'), context);
    } else {
      if (validation()) {
        if (image != null) {
          final bytes = File(image!.path).readAsBytesSync();
          img64 = base64Encode(bytes);
          EasyLoading.show(status: 'Caricamento');
          EasyLoading.instance.userInteractions = false;
          final result = await _apisNew.sendGalenicPreparationToPharmacy(
            {
              'user_id': ref.read(authProvider).user?.userId,
              'pharmacy_id': ref.read(flavorProvider).pharmacyId,
              'notes': _controllers['galenicNotes'].text,
              'img': img64,
            },
          );
          EasyLoading.dismiss();

          if (result != null) {
            Navigator.of(context).pushReplacementNamed(ItemSent.routeName);
          }
        }
      }
    }
  }

  Future<void> getImageFromCamera() async {
    image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        imageList.add(image!);
      });
    } else {
      return;
    }
  }

  Future<void> getImageFromGallery() async {
    image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        imageList.add(image!);
      });
    } else {
      return;
    }
  }

  bool switchValue = false;
  XFile? image;
  final ImagePicker _picker = ImagePicker();
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
          translate(context, 'galenic_prep'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PharmaHeaderSVG(
                title: translate(
                    context,
                    ref.read(flavorProvider).isParapharmacy
                        ? 'send_galenic_preparation_parapharmacy'
                        : 'send_galenic_preparation_pharmacy'),
                subtitle: translate(
                    context,
                    ref.read(flavorProvider).isParapharmacy
                        ? 'send_galenic_preparation_des_parapharmacy'
                        : 'send_galenic_preparation_des_pharmacy'),
                imgUrl: 'assets/icons/galenicpreparation.svg',
                color: const Color(0xFF5286F5),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                translate(context, 'upload_preparation_photo'),
                style: AppTheme.h6Style.copyWith(
                    color: ref.read(flavorProvider).lightPrimary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      translate(context, 'choose_option'),
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyText,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    OptionsRow(
                      onCameraTap: () async {
                        if (user == null) {
                          showredToast(
                              translate(context, 'login_required'), context);
                        } else {
                          var isAuthorized =
                              await PermissionConfig.getPermission();
                          if (!isAuthorized) {
                            showredToast(
                                translate(context, "permission_denied"),
                                context);
                          } else {
                            await getImageFromCamera();
                          }
                        }
                      },
                      onGalleryTap: () async {
                        if (user == null) {
                          showredToast(
                              translate(context, 'login_required'), context);
                        } else {
                          var isAuthorized =
                              await PermissionConfig.getPermission();
                          if (!isAuthorized) {
                            showredToast(
                                translate(context, "permission_denied"),
                                context);
                          } else {
                            await getImageFromGallery();
                          }
                        }
                      },
                    ),
                    imageList.isNotEmpty
                        ? Container(
                            width: 100.0.w,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              translate(context, "upload_images"),
                              textAlign: TextAlign.center,
                              style: AppTheme.bodyText,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: imageList.length * 90.0,
                      child: ListView.builder(
                        itemCount: imageList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                                color: AppColors.blueColor,
                                                width: 3),
                                            image: DecorationImage(
                                              image: FileImage(
                                                File(imageList[index].path),
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                        child: Image.file(
                                          File(imageList[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 05,
                                      ),
                                      Expanded(
                                          child: Text(
                                        ('Immagine caricata'),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500]),
                                      ))
                                    ],
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                        onTap: () {
                                          imageList.removeAt(index);
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.grey[400],
                                          size: 18,
                                        )))
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                translate(context, 'add_details'),
                style: AppTheme.h6Style.copyWith(
                    color: ref.read(flavorProvider).lightPrimary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                translate(context, "Tell_preferences"),
                style: AppTheme.h2Style.copyWith(
                    color: AppColors.darkGrey.withOpacity(.7), fontSize: 15),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: _controllers['galenicNotes'],
                decoration: Constant.borderTextFieldDecoration(
                        ref.read(flavorProvider).lightPrimary)
                    .copyWith(
                  hintText: translate(context, 'Enter_notes_preparation'),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 2,
                maxLines: 5,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
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
              const SizedBox(
                height: 16,
              ),
              StandardButton(
                text: ref.read(flavorProvider).isParapharmacy
                    ? 'Invia a parafarmacia'
                    : 'Invia a farmacia',
                onTap: () {
                  sendGalenicPreparationToPharmacy();
                },
              ),
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
