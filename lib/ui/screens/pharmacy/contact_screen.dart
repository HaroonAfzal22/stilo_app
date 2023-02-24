import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/contacts.dart';
import '../../../models/flavor.dart';
import '../../../providers/time_tables_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';

class ContactScreen extends ConsumerStatefulWidget {
  static String routeName = "/contact-screen";

  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

Widget _Appbar(context, WidgetRef ref) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    leading: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(children: [
        Icon(
          Icons.arrow_back_ios_outlined,
          size: 10.0.sp,
          color: Colors.grey,
        ),
        Text(translate(context, "back"),
            style: AppTheme.bodyText
                .copyWith(color: AppColors.darkGrey, fontSize: 6.0.sp))
      ]),
    ),
    title: Text(
      "Contacts",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: ref.read(flavorProvider).primary,
          fontSize: 15.0.sp,
          fontWeight: FontWeight.w600),
    ),
    actions: [
      Container(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 21,
                width: 21,
                child: SvgPicture.asset("assets/icons/ic_watch.svg"),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 21,
                width: 21,
                child: SvgPicture.asset("assets/icons/ic_notification.svg"),
              ),
            )
          ],
        ),
      )
    ],
  );
}

Widget _Image(String logo) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 150),
        child: Image.asset(
          logo,
        ),
      ),
    ),
  );
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  // bool loading = true;
  // dynamic contactUsData;
  final translator = GoogleTranslator();

  var data = {};
  final ApisNew _apisNew = ApisNew();

  Widget _Detail(AsyncValue contactState) {
    if (contactState.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: ref.read(flavorProvider).lightPrimary,
        ),
      );
    }

    final Contact contactUsData = contactState.value;

    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(children: <Widget>[
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Image.asset(
                    ic_address,
                    color: ref.read(flavorProvider).lightPrimary,
                    height: 18,
                    width: 18,
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ref.watch(sitesProvider).length > 1)
                      Text(
                        ref.read(siteProvider)!.name,
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.bold),
                        maxLines: 3,
                      ),
                    Text(
                      "${contactUsData.address ?? ""} ",
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w500),
                      maxLines: 3,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            height: 0,
            thickness: 1,
            endIndent: 10,
            color: Color.fromRGBO(112, 112, 112, 0.2),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              launch("mailto:${contactUsData.email}");
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      ic_mail,
                      color: ref.read(flavorProvider).lightPrimary,
                      height: 15,
                      width: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 8,
                      child: Text(
                        "${contactUsData.email ??= ""} ",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            height: 0,
            thickness: 1,
            endIndent: 10,
            color: Color.fromRGBO(112, 112, 112, 0.2),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              if (contactUsData.phone != null) {
                launch(
                    "tel://${contactUsData.phone.toString().replaceAll(' ', '')}");
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      ic_call,
                      height: 16,
                      width: 16,
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 8,
                      child: Text(
                        "${contactUsData.phone ??= ""} ",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (contactUsData.whatsapp != null)
            const Divider(
              height: 0,
              thickness: 1,
              endIndent: 10,
              color: Color.fromRGBO(112, 112, 112, 0.2),
            ),
          if (contactUsData.whatsapp != null)
            const SizedBox(
              height: 16,
            ),
          if (contactUsData.whatsapp != null)
            InkWell(
              onTap: () {
                if (contactUsData.whatsapp != null) {
                  launchUrl(
                      "https://wa.me/${contactUsData.whatsapp.toString().replaceAll(" ", "")}");
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: ref.read(flavorProvider).lightPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 8,
                      child: Text(
                        contactUsData.whatsapp ?? "",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ),
          if (contactUsData.whatsapp != null)
            const SizedBox(
              height: 16,
            ),
          if (contactUsData.facebookLink != null)
            const Divider(
              height: 0,
              thickness: 1,
              endIndent: 10,
              color: Color.fromRGBO(112, 112, 112, 0.2),
            ),
          if (contactUsData.facebookLink != null)
            const SizedBox(
              height: 16,
            ),
          if (contactUsData.facebookLink != null)
            InkWell(
              onTap: () {
                launchUrl("${contactUsData.facebookLink}");
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: ref.read(flavorProvider).lightPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 8,
                        child: Text(
                          contactUsData.facebookLink ?? "",
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ),
            ),
          if (contactUsData.facebookLink != null)
            const SizedBox(
              height: 16,
            ),
          if (contactUsData.instagramLink != null)
            const Divider(
              height: 0,
              thickness: 1,
              endIndent: 10,
              color: Color.fromRGBO(112, 112, 112, 0.2),
            ),
          if (contactUsData.instagramLink != null)
            const SizedBox(
              height: 16,
            ),
          if (contactUsData.instagramLink != null)
            InkWell(
              onTap: () {
                launchUrl("${contactUsData.instagramLink}");
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.instagram,
                          color: ref.read(flavorProvider).lightPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 8,
                        child: Text(
                          contactUsData.instagramLink ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ),
            ),
          if (contactUsData.instagramLink != null)
            const SizedBox(
              height: 16,
            ),
          const Divider(
            height: 0,
            thickness: 1,
            endIndent: 10,
            color: Color.fromRGBO(112, 112, 112, 0.2),
          ),
          const SizedBox(
            height: 16,
          ),
/*
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    ic_contectwatch,
                    height: 20,
                    width: 20,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                */
/*  Expanded(
                flex: 8,
                child: ScopedModelDescendant(

                  builder:
                    // TODO ripristinare

                  (BuildContext context, Widget child, AppModel model) {
                    return model.openingHoursList == null &&
                            model.openingHoursList.length == 0
                        ? SizedBox()
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: model.openingHoursList.length,
                            itemBuilder: (context, index) {
                              var startMorningTime = DateFormat('HH:mm').format(
                                  DateFormat('HH:mm').parse(model
                                      .openingHoursList[index]
                                      .startMoringDate));
                              var endMorningTime = DateFormat('HH:mm').format(
                                  DateFormat('HH:mm').parse(model
                                      .openingHoursList[index].endMoringDate));
                              var startEveTime = DateFormat('HH:mm').format(
                                  DateFormat('HH:mm').parse(model
                                      .openingHoursList[index].startEveDate));
                              var endEveTime = DateFormat('HH:mm').format(
                                  DateFormat('HH:mm').parse(model
                                      .openingHoursList[index].endEveDate));

                              return Text(
                                "${model.openingHoursList[index].day}: ${startMorningTime}-${endMorningTime}${startEveTime == endEveTime ? '' : '\n'}${startEveTime == endEveTime ? '' : startEveTime == startMorningTime && endEveTime == endMorningTime ? '' : startEveTime}${startEveTime == endEveTime ? '' : startEveTime == startMorningTime && endEveTime == endMorningTime ? '' : '-'}${startEveTime == endEveTime ? '' : startEveTime == startMorningTime && endEveTime == endMorningTime ? '' : endEveTime}",
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: AppColors.dark_grey,
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                          );
                  },
                ),
              )
            ],
          ),
        ),
        */ /*


                const Divider(
                  thickness: 1,
                  endIndent: 10,
                  color: Color.fromRGBO(112, 112, 112, 0.2),
                ),
              ],
            ),
          )
*/
        ]));
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  Widget _Button(AsyncValue contactState) {
    final Contact contactUsData = contactState.value;

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48.0.w,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                    side: BorderSide(
                        color: ref.read(flavorProvider).lightPrimary)),
                backgroundColor: Colors.white,
                foregroundColor: ref.read(flavorProvider).lightPrimary,
                padding: const EdgeInsets.all(2.0),
              ),
              onPressed: () {
                if (contactUsData.phone != null) {
                  launch(
                      "tel://${contactUsData.phone.toString().replaceAll(' ', '')}");
                }
              },
              child: Text(
                translate(context, "call_us"),
                style: TextStyle(
                  fontSize: 11.0.sp,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: 48.0.w,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                    side: BorderSide(
                        color: ref.read(flavorProvider).lightPrimary)),
                backgroundColor: ref.read(flavorProvider).lightPrimary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.all(2.0),
              ),
              onPressed: () {
                launchUrl(
                    "https://www.google.com/maps/search/${Uri.encodeFull("${contactUsData.address}")}");
              },
              child: Text(
                translate(context, "open_map"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.0.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(contactsProvider);

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            translate(context, 'contacts'),
            style: TextStyle(color: ref.read(flavorProvider).primary),
          ),
        ),
        //TODO appbar
        // globalAppBar(context, translate(context, "contacts"),
        //     json.decode(PreferenceUtils.getString("pharmacy_info"))),
        body: Builder(
            builder: (BuildContext context) => Container(
                child: contactState.isLoading
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, right: 0, left: 0),
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              _Image("assets/flavor/logo.png"),
                              _Detail(contactState),
                              _Button(contactState)
                            ]))))));
  }

  // Future<void> getContacts() async {
  //   final Response result = await _apisNew.getContact({
  //     "pharmacy_id": ref.read(flavorProvider).pharmacyId,
  //     "sede_id": ref.read(siteProvider)!.id,
  //   });
  //   contactUsData = result.data;
  //   loading = false;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // getContacts();
  }
}
