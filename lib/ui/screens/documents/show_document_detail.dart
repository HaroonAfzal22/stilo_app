import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/permissionConfig.dart';
import 'package:contacta_pharmacy/models/document.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/documents/item_deleted.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/EncodeDecode.dart';
import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../config/preference_utils.dart';
import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class ShowDocumentDetail extends ConsumerStatefulWidget {
  static String routeName = "/document-detail";

  const ShowDocumentDetail({Key? key}) : super(key: key);

  @override
  _ShowDocumentDetailState createState() => _ShowDocumentDetailState();
}

class _ShowDocumentDetailState extends ConsumerState<ShowDocumentDetail> {
  bool loading = false;
  bool switchControl = false;
  String switchControlText = "N";
  PharmaDocument? data;

  final ApisNew _apisNew = ApisNew();

  Future<void> deleteDocument() async {
    final result = await _apisNew.deleteDocument({
      "user_id": ref.read(authProvider).user?.userId,
      "document_id": data!.id
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      data = ModalRoute.of(context)!.settings.arguments as PharmaDocument;
      print(data?.toJson());
      switchControlText = data!.sharePharmacy!;
      switchControl = switchControlText == "Y" ? true : false;
      setState(() {});
    });
  }

  Future<void> download({required String url}) async {
    bool hasPermission = true; // await _requestWritePermission();
    if (!hasPermission) return;
    EasyLoading.show(status: "Download");
    EasyLoading.instance.userInteractions = false;
    var dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String fileName = url;

    Dio dio = Dio();
    await dio.download(url, "${dir!.path}/$url");
    EasyLoading.dismiss();
    if (url.endsWith(".pdf")) {
      OpenFilex.open("${dir.path}/$fileName", type: 'application/pdf');
    } else {
      OpenFilex.open("${dir.path}/$fileName");
    }
  }

  // requests storage permission
  // Future<bool> _requestWritePermission() async {
  //   await Permission.storage.request();
  //   return await Permission.storage.request().isGranted;
  // }

  Future<String> getFilePath(fileName) async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String appDocumentsPath = directory!.path;
    String filePath = appDocumentsPath;
    return filePath;
  }

  void saveFile(filename) async {
    File file = File(await getFilePath(filename)); // 1
    file.writeAsString(
        "This is my demo text that will be saved to : demoTextFile.txt"); // 2
  }

  Widget _container(PharmaDocument data, context) {
    var completePath = data.documentImage ?? "";
    var fileName = (completePath.split('/').last);

    return Container(
      height: 50.0.h,
      color: AppColors.grey.withOpacity(.3),
      child: InkWell(
        onTap: () {
          if (fileName.toString().contains("png") ||
              fileName.toString().contains("jpeg") ||
              fileName.toString().contains("jpg")) {}
        },
        child: Center(
          child: fileName.toString().contains("png") ||
                  fileName.toString().contains("jpeg") ||
                  fileName.toString().contains("jpg")
              ? Image.network(
                  "${data.documentImage}",
                  height: 40.0.h,
                  width: 40.0.h,
                )
              : fileName.toString().toLowerCase().contains("pdf")
                  ? SvgPicture.asset(
                      'assets/icons/pdf.svg',
                      height: 100,
                      width: 100,
                    )
                  : fileName.toString().toLowerCase().contains("docx") ||
                          fileName.toString().toLowerCase().contains("doc")
                      ? SvgPicture.asset(
                          'assets/icons/doc.svg',
                          height: 100,
                          width: 100,
                        )
                      : Image.asset(
                          "assets/icons/ic_document.png",
                          height: 100,
                          width: 100,
                        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO translate
        title: const Text('Dettaglio'),
      ),
      body: Builder(
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 0, left: 0),
          child: data != null
              ? SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      //  _list(),
                      _container(data!, context),
                      const SizedBox(
                        height: 5,
                      ),
                      //TODO fix
                      /*    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(fileName),
                      ),*/
                      data!.isAddedByPharmacy == "N"
                          ? Column(children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 15, right: 15, bottom: 8),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          translate(
                                              context,
                                              ref
                                                      .read(flavorProvider)
                                                      .isParapharmacy
                                                  ? "shared_with_parapharmacy"
                                                  : "shared_with_pharmacy"),
                                          style: AppTheme.h3Style.copyWith(
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Transform.scale(
                                            scale: 1,
                                            child: Switch(
                                              onChanged: (v) {
                                                toggleSwitch(v, data);
                                              },
                                              value: switchControl,
                                              activeColor: Colors.white,
                                              activeTrackColor: ref
                                                  .read(flavorProvider)
                                                  .primary,
                                              inactiveThumbColor: Colors.white,
                                              inactiveTrackColor: Colors.grey,
                                            )),
                                      ]))
                            ])
                          : const SizedBox(),
                      data!.isAddedByPharmacy == "N"
                          ? const Padding(
                              padding: EdgeInsets.only(left: 25, right: 15),
                              child: Divider(
                                color: AppColors.lightGrey,
                                endIndent: 30,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      //TODO fix

                      Column(
                        children: [
                          SizedBox(
                            height: 8.0.h,
                            width: 70.0.w,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(
                                        color:
                                            ref.read(flavorProvider).primary)),
                                backgroundColor:
                                    ref.read(flavorProvider).primary,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.all(2.0),
                              ),
                              onPressed: () async {
                                await _apisNew.updateDocument({
                                  "user_id":
                                      ref.read(authProvider).user?.userId,
                                  "document_id": data!.id,
                                  "is_share": switchControlText
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                translate(context, "confirm"),
                                style: TextStyle(
                                  fontSize: 11.0.sp,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 8.0.h,
                            width: 70.0.w,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(
                                        color:
                                            ref.read(flavorProvider).primary)),
                                backgroundColor: Colors.white,
                                foregroundColor:
                                    ref.read(flavorProvider).primary,
                                padding: const EdgeInsets.all(2.0),
                              ),
                              onPressed: () async {
                                // var docs =
                                //     'https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiGtKiqvIf4AhVwi_0HHUo8BSQQFnoECAkQAQ&url=https%3A%2F%2Fwww.amministrazionicomunali.it%2Fdocs%2Fmod_f24%2FModello_F24_2013.pdf&usg=AOvVaw1VWTaunUb7xOSwz5BQvs88';
                                var isAuthorized =
                                    await PermissionConfig.getPermission();
                                if (!isAuthorized) {
                                  showredToast(
                                      translate(context, "permission_denied"),
                                      context);
                                } else {
                                  download(url: data!.documentImage ?? "");
                                }
                              },
                              child: Text(
                                translate(context, "Download_document"),
                                style: TextStyle(
                                  fontSize: 11.0.sp,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: data!.documentImage!.endsWith(".pdf")
                                ? false
                                : true,
                            child: SizedBox(
                              height: 8.0.h,
                              width: 70.0.w,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: ref
                                              .read(flavorProvider)
                                              .primary)),
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      ref.read(flavorProvider).primary,
                                  padding: const EdgeInsets.all(2.0),
                                ),
                                onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return DocumentDetailPreview(
                                    data: data!.documentImage!,
                                  );
                                })),
                                child: Text(
                                  translate(context, "view_document"),
                                  style: TextStyle(
                                    fontSize: 11.0.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          data!.sharePharmacy == "N"
                              ? Visibility(
                                  visible: data!.documentImage!.endsWith(".pdf")
                                      ? false
                                      : true,
                                  child: const SizedBox(
                                    height: 15,
                                  ),
                                )
                              : const SizedBox(),
                          data!.sharePharmacy == "N"
                              ? SizedBox(
                                  height: 8.0.h,
                                  width: 70.0.w,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          side: const BorderSide(
                                              color: Colors.red)),
                                      backgroundColor: Colors.red,
                                      foregroundColor: AppColors.white,
                                      padding: const EdgeInsets.all(2.0),
                                    ),
                                    onPressed: () {
                                      showAlertDelete(context);
                                    },
                                    child: Text(
                                      translate(context, "Delete_Document"),
                                      style: TextStyle(
                                        fontSize: 11.0.sp,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ]))
              : Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
        ),
      ),
    );
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  showAlertDelete(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: dialogContentDelete(context),
          );
        });
  }

  Widget dialogContentDelete(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 5.0.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: ref.read(flavorProvider).primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              )),
          child: Center(
            child: Text(translate(context, "Delete_Document"),
                textAlign: TextAlign.center,
                style: AppTheme.h6Style.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            translate(context, "delete_document_confirmation"),
            style: AppTheme.bodyText,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 0),
          decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  deleteData(data);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      ItemDeleted.routeName, (route) => false);
                  // Navigator.popUntil(
                  //     context, ModalRoute.withName('/saved-documents-screen'));
                },
                child: Container(
                    height: 4.0.h,
                    width: 20.0.w,
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text(
                      translate(context, "delete"),
                      //"${translate(context, "logout")}",
                      style: AppTheme.bodyText.copyWith(
                        color: AppColors.white,
                        fontSize: 10.0.sp,
                      ),
                      textAlign: TextAlign.center,
                    ))),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: Container(
                    height: 4.0.h,
                    width: 20.0.w,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.read(flavorProvider).primary)),
                    child: Center(
                        child: Text(
                      translate(context, "Cancel"),
                      style: AppTheme.bodyText.copyWith(
                        color: AppColors.black,
                        fontSize: 10.0.sp,
                      ),
                      textAlign: TextAlign.center,
                    ))),
              ),
            ],
          ),
        )
      ],
    );
  }

  deleteData(data) {
    deleteDocument();
  }

  shareData(data, flag) {
    setState(() {
      loading = true;
    });
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        setState(() {
          loading = true;
        });

        EncodeDecode enc = EncodeDecode();
        log('${PreferenceUtils.getInt("user_id").toString()} ', name: "Loggg");

        var dataToBesent = enc.encode({
          '"user_id" : "${PreferenceUtils.getInt("user_id").toString()}","user_device_id":"${PreferenceUtils.getString("user_device_id").toString()}","access_token":"${PreferenceUtils.getString("accesstoken").toString()}","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}", "document_id":"${data["id"]}" ,"share_pharmacy":"${flag ? "Y" : "N"}"'
        });
        try {
          Dio dio = Dio();

          dio
              .post(
            Constant.documentShare,
            data: dataToBesent,
          )
              .then((value) async {
            var temp = json.decode(enc.decode(value.toString()));
            print("$temp Documents Data");
            if (value.statusCode == 200) {
              if (temp['code'] == 200) {
                final translator = GoogleTranslator();
                var translation = await translator.translate(
                    "Condivisione modificata con successo!",
                    to: PreferenceUtils.getString("language"));

                if (Platform.isAndroid) {
                  var fToast;

                  fToast = FToast();
                  fToast.init(context);
                  Widget toast = Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                    child: Text(
                      "$translation",
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );

                  fToast.showToast(
                    child: toast,
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: const Duration(seconds: 5),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: ("$translation"),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: ref.read(flavorProvider).lightPrimary,
                      textColor: AppColors.white,
                      fontSize: 16.0);
                }

                setState(() {
                  loading = false;
                });

                Navigator.pop(context, true);
              } else if (temp['code'] == 999) {
                setState(() {
                  loading = false;
                });
                showInSnackBar("${temp['message']}", context);
                sessionExpired(context);
              } else {
                // showInSnackBar("${temp['message']}", context);
                setState(() {
                  loading = false;
                });
              }
            }
          });
        } catch (e) {
          print(e);
          showInSnackBar(translate(context, "error_fetching_data"), context);
          setState(() {
            loading = false;
          });
        }
      }
    });
  }

  downloadImage(url) async {
    if (Platform.isIOS) {
      try {
        // Saved with this method.
        var imageId = await ImageDownloader.downloadImage("$url");
        if (imageId == null) {
          return;
        }
        var documentDirectory = await getApplicationDocumentsDirectory();

        // Below is a method of obtaining saved image information.
        var fileName = await ImageDownloader.findName(imageId);

        var path = await ImageDownloader.findPath(imageId);
        var size = await ImageDownloader.findByteSize(imageId);

        var mimeType = await ImageDownloader.findMimeType(imageId);
      } on PlatformException catch (error) {
        print(error);
      }
    } else {
      launchUrl(data!.documentImage!);
    }
  }

  void toggleSwitch(bool value, data) {
    shareData(data, value);

    if (switchControl == false) {
      setState(() {
        switchControl = true;
        switchControlText = "Y";
      });
    } else {
      setState(() {
        switchControl = false;
        switchControlText = "N";
      });
    }
  }
}

class DocumentDetailPreview extends StatelessWidget {
  final String? data;

  const DocumentDetailPreview({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        //TODO fixare pagina bianca
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: data == null
                  ? const SizedBox()
                  : data!.endsWith(".pdf")
                      ? const SizedBox(
                          //todo translate
                          child: Center(
                              child: Text(
                                  "Preview pdf non disponibile, scaricare il documento")),
                        )
                      : Image.network(data!)),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
