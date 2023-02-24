import 'dart:convert';
import 'dart:developer';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../config/EncodeDecode.dart';
import '../../config/MyApplication.dart';
import '../../config/constant.dart';
import '../../config/preference_utils.dart';
import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';
import '../../utils/ImageString.dart';

class TermsConditionScreen extends ConsumerStatefulWidget {
  static String routeName = "/terms-conditions-screen";

  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  _TermsConditionScreenState createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends ConsumerState<TermsConditionScreen> {
  var temp;
  dynamic data;

  bool loading = false;
  final ApisNew _apisNew = ApisNew();

  String? parsedDate;
  String? parsedHour;

  Future<void> getTermsAndConditions() async {
    final result = await _apisNew.cms({
      "slug": "TermsAndCondition",
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    data = result.data;
    final user = ref.read(authProvider).user;
    if (user != null && user.privacyAccepted != null) {
      //TODO fix
      /* var splitted = user.privacyAccepted!.split('T');
      print(splitted);
      print(splitted.length);
      parsedDate = splitted[0];
      parsedHour = splitted[1];*/
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTermsAndConditions();
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
      body: Builder(
        builder: (BuildContext context) => Container(
          child: loading
              ? const SizedBox()
              : data == null
                  ? const SizedBox()
                  : SizedBox(
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.5.w, vertical: 1.5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 10,
                                              top: 0,
                                              bottom: 0),
                                          child: Row(
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
                                              text:
                                                  "${translate(context, "accepted_at")} ",
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          TextSpan(
                                              text: ref
                                                      .read(authProvider)
                                                      .user
                                                      ?.privacyAccepted ??
                                                  '',
                                              /*  DateFormat(
                                                      'dd MMMM yyyy',
                                                      PreferenceUtils
                                                          .getString(
                                                              "language"))
                                                  .format(DateFormat(
                                                          "dd/MM/yyyy HH:mm:ss")
                                                      .parse(PreferenceUtils
                                                          .getString(
                                                              "created_date"))),*/
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          //TODO fix
                                          /*      TextSpan(
                                              text:
                                                  " ${translate(context, "at")} ",
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          TextSpan(
                                              text:
                                                  parsedHour?.substring(0, 8) ??
                                                      '',*/
                                          /*   DateFormat('hh:mm')
                                                  .format(DateFormat(
                                                          "dd/MM/yyyy HH:mm:ss")
                                                      .parse(PreferenceUtils
                                                          .getString(
                                                              "created_date"))),*/
                                          /*     style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),*/
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (data['terms_and_conditions'] != null)
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0.w, vertical: 10),
                                child: ListView(
                                  children: [
                                    Html(
                                      data: data['terms_and_conditions'],
                                    )
                                    /*     Html(
                                        data: temp['data']['long_description'],
                                        onLinkTap: (String url, RenderContext context, Map<String, String> attributes, dom.Element element) {
                                          launchUrl(url);
                                          //open URL in webview, or launch URL in browser, or any other logic here
                                        }
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  void termsCondition() async {
    log(PreferenceUtils.getString("terms_condition"), name: "Tems Data");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = json.decode(PreferenceUtils.getString("terms_condition"));
    setState(() {
      temp = data;
    });
  }

  void termsConditionApi() async {
    MyApplication.getInstance()
        ?.checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        EncodeDecode enc = EncodeDecode();

        setState(() {
          loading = true;
        });

        var dataToBesent = enc.encode({
          ' "slug":"TermsAndCondition" ,  "pharmacy_id":"${PreferenceUtils.getString("pharmacy_id")}"'
        });
        log(dataToBesent, name: "TermsAndCondition");
        try {
          Dio dio = Dio();

          dio
              .post(
            Constant.cms,
            data: dataToBesent,
          )
              .then((value) async {
            var temp2 = json.decode(enc.decode(value.toString()));

            log("${temp2}", name: "terms_condition");
            if (value.statusCode == 200) {
              if (temp2['code'] == 200) {
                // SharedPreferences preferences =
                // await SharedPreferences.getInstance();
                PreferenceUtils.setString(
                    "terms_condition", json.encode(temp2));
                setState(() {
                  loading = false;
                  temp = temp2;
                });

                //Navigator.pushNamed(context, new.routeName);
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
          print(e);
          showInSnackBar(translate(context, "error_fetching_data"), context);
        }
      }
    });
  }
}
