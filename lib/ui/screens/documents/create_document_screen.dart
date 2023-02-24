import 'dart:convert';
import 'dart:developer';
import 'dart:io' as Io;

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescription_sent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class CreateDocument extends ConsumerStatefulWidget {
  static String routeName = "/create-document";

  const CreateDocument({Key? key}) : super(key: key);

  @override
  _CreateDocumentState createState() => _CreateDocumentState();
}

class _CreateDocumentState extends ConsumerState<CreateDocument> {
  bool loading = false;
  bool switchControl = false;
  String switchControlText = "N";
  Io.File? data;
  final ApisNew _apisNew = ApisNew();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      data = ModalRoute.of(context)!.settings.arguments as Io.File;
      //switchControl = data['share_pharmacy'] == "Y" ? true : false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //TODO translate
          title: Text(translate(context, 'save_doc'))),
      body: Builder(
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 0, left: 0),
          child: data != null
              ? SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      //  _list(),
                      Container(
                        height: 50.0.h,
                        color: AppColors.grey.withOpacity(.3),
                        child: Center(
                            child: data!.path.contains("png") ||
                                    data!.path.contains("jpeg") ||
                                    data!.path.contains("jpg")
                                ? Hero(
                                    tag: 'imageHero',
                                    child: Image.file(
                                      data!,
                                      height: 40.0.h,
                                      width: 40.0.h,
                                    ),
                                  )
                                : data!.path.toLowerCase().contains("pdf")
                                    ? SvgPicture.asset(
                                        'assets/icons/pdf.svg',
                                        height: 100,
                                        width: 100,
                                      )
                                    : data!.path
                                                .toLowerCase()
                                                .contains("docx") ||
                                            data!.path
                                                .toLowerCase()
                                                .contains("doc")
                                        ? SvgPicture.asset(
                                            'assets/icons/doc.svg',
                                            height: 100,
                                            width: 100,
                                          )
                                        : Image.asset(
                                            "assets/icons/ic_document.png",
                                            height: 100,
                                            width: 100,
                                          )),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(children: [
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
                                        ref.read(flavorProvider).isParapharmacy
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
                                        activeTrackColor:
                                            ref.read(flavorProvider).primary,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: Colors.grey,
                                      )),
                                ]))
                      ]),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, right: 15),
                        child: Divider(
                          color: AppColors.lightGrey,
                          endIndent: 30,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      //TODO fix

                      Column(
                        children: [
                          Visibility(
                            visible: data!.path.endsWith(".pdf") ? false : true,
                            child: Container(
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
                                  foregroundColor:
                                      ref.read(flavorProvider).primary,
                                  padding: const EdgeInsets.all(2.0),
                                ),
                                onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return DocumentPreview(data: data!);
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
                          const SizedBox(
                            height: 20,
                          ),
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
                                EasyLoading.show(status: "caricamento");
                                EasyLoading.instance.userInteractions = false;
                                var tempFile = Io.File(data!.path);
                                int sizeInBytes = tempFile.lengthSync();
                                double sizeInMb = sizeInBytes / (1024 * 1024);
                                if (sizeInMb > 5) {
                                  showredToast(translate(context, "longer_img"),
                                      context);
                                } else {
                                  final bytes = tempFile.readAsBytesSync();
                                  String img64 = base64Encode(bytes);
                                  var result = await _apisNew.addDocument({
                                    "user_id":
                                        ref.read(authProvider).user?.userId,
                                    "pharmacy_id":
                                        ref.read(flavorProvider).pharmacyId,
                                    "document_image": img64,
                                  });
                                  EasyLoading.dismiss();
                                  if (result.statusCode == 200) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            ItemSent.routeName,
                                            (route) => false);
                                  } else {
                                    showredToast(
                                        translate(context, "no_upload"),
                                        context);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Text(
                                translate(context, "save"),
                                style: TextStyle(
                                  fontSize: 11.0.sp,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 8.0.h,
                            width: 70.0.w,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: const BorderSide(color: Colors.red)),
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
                          ),
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
                  Navigator.pop(context);
                },
                child: GestureDetector(
                  onTap: () => Navigator.popUntil(
                      context, ModalRoute.withName('/saved-documents-screen')),
                  child: Container(
                      height: 4.0.h,
                      width: 20.0.w,
                      decoration: BoxDecoration(
                        color: AppColors.darkRed,
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

                if (Io.Platform.isAndroid) {
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
//timeInSecForIosWeb: 1,
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

  void toggleSwitch(bool value, data) {
    shareData(data, value);

    if (switchControl == false) {
      setState(() {
        switchControl = true;
        switchControlText = "Y";
        //textHolder = 'Switch is ON';
      });
      print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.

    } else {
      setState(() {
        switchControl = false;
        switchControlText = "N";
        //textHolder = 'Switch is OFF';
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }
}

class DocumentPreview extends StatelessWidget {
  final Io.File data;

  const DocumentPreview({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        //TODO fixare pagina bianca
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: data.path.contains("png") ||
                    data.path.contains("jpeg") ||
                    data.path.contains("jpg")
                ? Image.file(data)
                //todo translate
                : const SizedBox(
                    child: Center(
                        child: Text(
                            "Preview pdf non disponibile, scaricare il documento")),
                  ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
