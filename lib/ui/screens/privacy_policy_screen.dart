import 'dart:convert';
import 'dart:developer';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../config/EncodeDecode.dart';
import '../../config/MyApplication.dart';
import '../../config/constant.dart';
import '../../config/preference_utils.dart';
import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';
import '../../utils/ImageString.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  static String routeName = "/privacy-policy";

  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen> {
  bool loading = false;
  var aboutus = {};
  var temp;
  final ApisNew _apisNew = ApisNew();
  dynamic data;
  String? parsedDate;
  String? parsedHour;

  Future<void> getPrivacyPolicy() async {
    final result = await _apisNew.cms({
      "slug": "PrivacyPolicy",
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    data = result.data;
    final user = ref.read(authProvider).user;
/*    if (user != null && user.privacyAccepted != null) {
      var splitted = user.privacyAccepted!.split('T');
      parsedDate = splitted[0];
      parsedHour = splitted[1];
    }*/

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            translate(context, "Information"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ref.read(flavorProvider).primary,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 20, top: 10, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            temp != null
                                ? Text(
                                    "${temp['data']['title']}",
                                    style: TextStyle(
                                        fontSize: 16.0.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            ref.read(flavorProvider).primary),
                                  )
                                : const SizedBox(),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 0, bottom: 0),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        ic_cancel,
                                        height: 1.5.h,
                                        color: AppColors.darkGrey,
                                      )),
                                ],
                              ),
                            )
                          ]),
                      const SizedBox(
                        height: 5,
                      ),

                      RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "${translate(context, "accepted_at")} ",
                                  style: const TextStyle(color: Colors.black)),
                              TextSpan(
                                text: ref
                                        .read(authProvider)
                                        .user
                                        ?.privacyAccepted ??
                                    '',
                                //TODO fix
                                /*     DateFormat('dd MMMM yyyy', 'it').format(
                                  DateFormat("dd/MM/yyyy HH:mm:ss").parse(
                                    PreferenceUtils.getString("created_date"),
                                  ),
                                ),*/
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              /*    TextSpan(
                                  text: " ${translate(context, "at")} ",
                                  style: const TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: parsedHour?.substring(0, 8) ?? '',
                                  //TODO fix
                                  */ /*              DateFormat('hh:mm').format(
                                  DateFormat("dd/MM/yyyy HH:mm:ss").parse(
                                      PreferenceUtils.getString(
                                          "created_date"))),*/ /*
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),*/
                            ]),
                      ),
                      // Text(
                      //     "Date Time: ${DateFormat('dd MMM yy hh:mm:ss').format(DateFormat("yyyy-mm-dd hh:mm:ss").parse(aboutus['date']))} "),
                    ],
                  ),
                ),
              ),
              data != null
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.w, vertical: 12),
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Html(
                              data: data['privacy_policy'],
                            ),

                            /*    Html(
                    //data:htmldata
                      data:temp['data']['long_description'],
                      onLinkTap: (String url, RenderContext context, Map<String, String> attributes, dom.Element element) {
                        launchUrl(url);
                        //open URL in webview, or launch URL in browser, or any other logic here
                      }
                  )*/
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ]));
  }

  privacyPolicy() async {
    setState(() {
      temp = json.decode(PreferenceUtils.getString("privacy_policy"));
    });
  }

  privacyPolicyApi() async {
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet) {
        setState(() {
          loading = true;
        });
        EncodeDecode enc = EncodeDecode();

        var dataToBesent = enc.encode({
          ' "slug":"PrivacyPolicy","pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}"'
        });

        log(dataToBesent, name: "PrivacyPolicy Data");

        try {
          Dio dio = Dio();

          dio
              .post(
            Constant.cms,
            data: dataToBesent,
          )
              .then((value) async {
            var temp2 = json.decode(enc.decode(value.toString()));
            log("$temp2", name: "privacy_policy");
            if (value.statusCode == 200) {
              if (temp2['code'] == 200) {
                PreferenceUtils.setString("privacy_policy", json.encode(temp2));

                setState(() {
                  temp = temp2;
                  loading = false;
                  log(' $temp ', name: "PP");
                });
              } else {
                setState(() {
                  loading = false;
                });
              }
            }
          }).onError((error, stackTrace) {
            setState(() {
              loading = false;
            });
          });
        } catch (e) {
          setState(() {
            loading = false;
          });
        }
      }
    });
  }
}
