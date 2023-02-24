import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/config/permissionConfig.dart';
import 'package:contacta_pharmacy/models/document.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/documents/create_document_screen.dart';
import 'package:contacta_pharmacy/ui/screens/documents/show_document_detail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';

class SavedDocumentsFirstTab extends ConsumerStatefulWidget {
  const SavedDocumentsFirstTab({Key? key}) : super(key: key);

  @override
  _SavedDocumentsFirstTabState createState() => _SavedDocumentsFirstTabState();
}

class _SavedDocumentsFirstTabState
    extends ConsumerState<SavedDocumentsFirstTab> {
  List<PharmaDocument>? documentsList;
  final ApisNew _apisNew = ApisNew();

  Future<void> getDocuments() async {
    final result = await _apisNew.getDocuments({
      'user_id': ref.read(authProvider).user?.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'all'
    });
    documentsList = [];
    for (var documentItem in result.data) {
      documentsList!.add(PharmaDocument.fromJson(documentItem));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      getDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (documentsList != null)
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.1.h,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemCount: documentsList!.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? const AddDocumentBox()
                        : DocumentBox(
                            document: documentsList![index - 1],
                          );
                  })
            else
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class AddDocumentBox extends ConsumerWidget {
  const AddDocumentBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (context) => AddDocumentModal(
            sendFileToParent: (p0) {},
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ref.read(flavorProvider).lightPrimary,
              ref.read(flavorProvider).primary
            ],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ic_add_document,
              height: 4.0.h,
              color: Colors.white,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              translate(context, "add_document"),
              textAlign: TextAlign.center,
              style: AppTheme.h6Style.copyWith(
                  color: AppColors.white, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}

class DocumentBox extends StatefulWidget {
  const DocumentBox({Key? key, required this.document}) : super(key: key);

  final PharmaDocument document;

  @override
  State<DocumentBox> createState() => _DocumentBoxState();
}

class _DocumentBoxState extends State<DocumentBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ShowDocumentDetail.routeName,
          arguments: widget.document,
        );
      },
      child: 1 > 0
          ? SvgPicture.asset('assets/icons/doc.svg')
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.0),
                /*    image: DecorationImage(
                        fit: BoxFit.contain,
                        image:
                            fileName.toString().toLowerCase().contains("png") ||
                                    fileName
                                        .toString()
                                        .toLowerCase()
                                        .contains("jpeg") ||
                                    fileName
                                        .toString()
                                        .toLowerCase()
                                        .contains("jpg")
                                ? NetworkImage(
                                    documentsList[index]['document_image'])
                                : AssetImage("assets/icons/ic_document.png")),*/
              ),
            ),
    );
  }
}

class AddDocumentModal extends StatefulWidget {
  final Function(File) sendFileToParent;
  const AddDocumentModal({
    Key? key,
    required this.sendFileToParent,
  }) : super(key: key);

  @override
  State<AddDocumentModal> createState() => _AddDocumentModalState();
}

class _AddDocumentModalState extends State<AddDocumentModal> {
  Future<File?> _fileFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }

  Future<File?> _imgFromGallery() async {
    final picker = ImagePicker();
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //todo translate
              const Text(
                "Seleziona documento da",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var isAuthorized =
                                  await PermissionConfig.getPermission();
                              if (!isAuthorized) {
                                showredToast(
                                    translate(context, "permission_denied"),
                                    context);
                              } else {
                                var file = await _fileFromStorage();
                                if (file != null) {
                                  Navigator.pushNamed(
                                      context, CreateDocument.routeName,
                                      arguments: file);
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: const Icon(
                              Icons.file_copy,
                              size: 75,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text('File'),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var isAuthorized =
                                  await PermissionConfig.getPermission();
                              if (!isAuthorized) {
                                showredToast(
                                    translate(context, "permission_denied"),
                                    context);
                              } else {
                                var file = await _imgFromGallery();
                                if (file != null) {
                                  Navigator.pushNamed(
                                      context, CreateDocument.routeName,
                                      arguments: file);
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: const Icon(
                              Icons.camera_enhance,
                              size: 75,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    translate(context, 'Gallery'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
