import 'dart:io';

import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/config/permissionConfig.dart';
import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class PrescriptionExpandableRed extends ConsumerStatefulWidget {
  const PrescriptionExpandableRed({Key? key, required this.photoCallBack})
      : super(key: key);
  final Function(XFile) photoCallBack;

  @override
  ConsumerState<PrescriptionExpandableRed> createState() =>
      _PrescriptionExpandableRedState();
}

class _PrescriptionExpandableRedState
    extends ConsumerState<PrescriptionExpandableRed> {
  final picker = ImagePicker();
  List<XFile> imageList = [];
  XFile? image;

  _imgFromCamera() async {
    final user = ref.read(authProvider).user;
    if (user == null) {
      showredToast(translate(context, 'login_required'), context);
    } else {
      image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (image != null) {
        setState(() {
          imageList.add(image!);
        });
      }
    }
  }

  _imgFromGallery() async {
    final user = ref.read(authProvider).user;

    if (user == null) {
      showredToast(translate(context, 'login_required'), context);
    } else {
      image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (image != null) {
        setState(() {
          imageList.add(image!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            )
          ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            title: Text(
              ref.read(flavorProvider).redRecipes ??
                  translate(context, 'red_recipes'),
              overflow: TextOverflow.ellipsis,
              style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              translate(context, 'select_red_recipes'),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: AppTheme.bodyText
                  .copyWith(fontSize: 8.0.sp, color: AppColors.lightGrey),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(2),
              child: Image.asset('assets/images/addphoto.png'),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    if (imageList.isEmpty)
                      Text(
                        translate(
                          context,
                          'choose_option',
                        ),
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyText,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    if (imageList.isEmpty)
                      const SizedBox(
                        height: 8,
                      ),
                    if (imageList.isEmpty)
                      OptionsRow(
                        onCameraTap: () async {
                          var isAuthorized =
                              await PermissionConfig.getPermission();
                          if (!isAuthorized) {
                            showredToast(
                                translate(context, "permission_denied"),
                                context);
                          } else {
                            await _imgFromCamera();
                            widget.photoCallBack(image!);
                          }
                        },
                        onGalleryTap: () async {
                          var isAuthorized =
                              await PermissionConfig.getPermission();
                          if (!isAuthorized) {
                            showredToast(
                                translate(context, "permission_denied"),
                                context);
                          } else {
                            await _imgFromGallery();
                            widget.photoCallBack(image!);
                          }
                        },
                      ),
                    imageList.length > 0
                        ? Container(
                            width: 100.0.w,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "${translate(context, "upload_images")}",
                              textAlign: TextAlign.center,
                              style: AppTheme.bodyText,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          )
                        : const SizedBox(),
                    Container(
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
                                        (translate(context, "uploaded_image") +
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionsRow extends StatefulWidget {
  const OptionsRow({
    Key? key,
    required this.onCameraTap,
    required this.onGalleryTap,
  }) : super(key: key);

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  State<OptionsRow> createState() => _OptionsRowState();
}

class _OptionsRowState extends State<OptionsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SingleOption(
          icon: Icons.camera_alt,
          text: 'Scatta una foto',
          onTap: widget.onCameraTap,
        ),
        const SizedBox(
          width: 8,
        ),
        SingleOption(
          icon: Icons.folder_shared_rounded,
          text: 'Carica da gallery',
          onTap: widget.onGalleryTap,
        )
      ],
    );
  }
}

class SingleOption extends StatelessWidget {
  const SingleOption({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: Colors.deepPurple.withOpacity(0.75),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 2,
              ),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
