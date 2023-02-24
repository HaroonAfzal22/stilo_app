import 'dart:convert';
import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/permissionConfig.dart';
import 'package:contacta_pharmacy/models/customProduct.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/pharma_header.dart';
import 'package:contacta_pharmacy/ui/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/buttons/custom_two_options_button.dart';
import '../prescriptions/prescription_sent.dart';

class ProductsAddProductFromPhotoScreen extends ConsumerStatefulWidget {
  const ProductsAddProductFromPhotoScreen({Key? key}) : super(key: key);
  static const routeName = '/products-add-product-from-photo';

  @override
  _ProductsAddProductFromPhotoScreenState createState() =>
      _ProductsAddProductFromPhotoScreenState();
}

class _ProductsAddProductFromPhotoScreenState
    extends ConsumerState<ProductsAddProductFromPhotoScreen> {
  final Map<String, dynamic> _controllers = {
    'productNotes': TextEditingController(),
    'name': TextEditingController(),
  };

  final picker = ImagePicker();
  List<XFile> imageList = [];
  final ApisNew _apisNew = ApisNew();
  XFile? image;
  String? img64;

  Future<void> sendToPharmacy() async {
    if (ref.read(authProvider).user != null) {
      if (validation()) {
        final bytes = File(image!.path).readAsBytesSync();
        img64 = base64Encode(bytes);
        EasyLoading.show(status: 'Caricamento');
        EasyLoading.instance.userInteractions = false;
        final result = await sendCustomProductToPharmacy();
        EasyLoading.dismiss();
        if (result.statusCode == 200) {
          Navigator.of(context).pushReplacementNamed(ItemSent.routeName);
        }
      }
    } else {
      showredToast(translate(context, 'login_required'), context);
    }
  }

  Future<dynamic> sendCustomProductToPharmacy() async {
    return _apisNew.sendCustomProductToPharmacy({
      "user_id": ref.read(authProvider).user?.userId,
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
      "productName": _controllers['name'].text,
      "notes": _controllers['productNotes'].text,
      "img": img64,
    });
  }

  bool validation() {
    if (image == null) {
      showredToast(translate(context, "err_image"), context);
      return false;
    } else if (!switchValue) {
      showredToast(translate(context, "err_switch"), context);
      return false;
    }
    return true;
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
          translate(context, 'take_product_photos'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PharmaHeader(
                  title: translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? 'send_product_photo_parapharmacy'
                          : 'send_product_photo_pharmacy'),
                  subtitle: translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? 'send_product_photo_des_parapharmacy'
                          : 'send_product_photo_des_pharmacy'),
                  imgUrl: 'assets/images/camera.png'),
              const SizedBox(
                height: 16,
              ),
              Text(
                translate(
                  context,
                  'photo_insertion',
                ),
                style: AppTheme.h6Style.copyWith(
                    color: ref.read(flavorProvider).lightPrimary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 5,
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (user == null) {
                                //TODO translate
                                showredToast(
                                    translate(context, 'login_required'),
                                    context);
                              } else {
                                var isAuthorized =
                                    await PermissionConfig.getPermission();
                                if (!isAuthorized) {
                                  showredToast(
                                      translate(context, "permission_denied"),
                                      context);
                                } else {
                                  await _imgFromCamera();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                color: ref.read(flavorProvider).lightPrimary,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    translate(context, 'take_picture'),
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (user == null) {
                                showredToast(
                                    translate(context, 'login_required'),
                                    context);
                              } else {
                                var isAuthorized =
                                    await PermissionConfig.getPermission();
                                if (!isAuthorized) {
                                  showredToast(
                                      translate(context, "permission_denied"),
                                      context);
                                } else {
                                  await _imgFromGallery();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                color: ref.read(flavorProvider).lightPrimary,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.photo_album_sharp,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      translate(context, 'upload_photo'),
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    imageList.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            height: imageList.length * 90.0,
                            child: ListView.builder(
                              itemCount: imageList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                                                      color:
                                                          AppColors.blueColor,
                                                      width: 3),
                                                  image: DecorationImage(
                                                    image: FileImage(File(
                                                        imageList[index].path)),
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 05,
                                            ),
                                            Expanded(
                                                child: Text(
                                              (translate(context,
                                                      "uploaded_image") +
                                                  " " +
                                                  (index + 1).toString()),
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
                          ),
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
                height: 24,
              ),
              Text(
                translate(context, 'product_name'),
                style: AppTheme.h2Style.copyWith(
                  color: AppColors.black,
                  fontSize: 12.0.sp,
                ),
              ),
              TextField(
                controller: _controllers['name'],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                translate(context, "notes_preferences"),
                style: AppTheme.h2Style
                    .copyWith(color: AppColors.black, fontSize: 15),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: _controllers['productNotes'],
                decoration: Constant.borderTextFieldDecoration(
                        ref.read(flavorProvider).lightPrimary)
                    .copyWith(
                        hintText:
                            translate(context, 'Enter_notes_preferencess')),
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
              Row(
                children: [
                  FirstOptionButton(
                    onTap: () {
                      sendToPharmacy();
                    },
                  ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  // SecondOptionButton(
                  //   onTap: () {
                  //     if (user != null) {
                  //       if (validation()) {
                  //         var uuid = const Uuid();
                  //         cart.addCustomProductToCart(
                  //           CustomProduct(
                  //               id: uuid.v1(),
                  //               uploadedPhoto: imageList,
                  //               productName: 'name',
                  //               notes: 'notes'),
                  //         );
                  //         Navigator.of(context)
                  //             .pushReplacementNamed(CartScreen.routeName);
                  //       }
                  //     } else {
                  //       showredToast(
                  //           translate(context, 'login_required'), context);
                  //     }
                  //   },
                  // ),
                ],
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

  _imgFromCamera() async {
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

  _imgFromGallery() async {
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
}
