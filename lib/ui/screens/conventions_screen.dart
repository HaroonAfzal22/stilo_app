import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/apisNew.dart';
import '../../config/MyApplication.dart' as myapp;
import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../../utils/ImageString.dart';

class ConventionsScreen extends ConsumerStatefulWidget {
  const ConventionsScreen({Key? key}) : super(key: key);
  static const routeName = '/conventions-screen';

  @override
  ConsumerState<ConventionsScreen> createState() => _ConventionsScreenState();
}

class _ConventionsScreenState extends ConsumerState<ConventionsScreen> {
  List<dynamic>? conventions;
  //TODO apisNEW replace
  final ApisNew _apisNew = ApisNew();

  Future<void> getConventions() async {
    final result = await _apisNew.getConventions(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );
    setState(() {
      conventions = result.data;
    });
  }

  @override
  void initState() {
    super.initState();
    getConventions();
  }

  @override
  Widget build(BuildContext context) {
    return conventions == null
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                color: ref.read(flavorProvider).lightPrimary,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(translate(context, 'events_conventions')),
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, "our_conventions"),
                      style: TextStyle(
                          fontSize: 15.0.sp, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          translate(context, "there_are") + ' ',
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0.sp),
                        ),
                        Text(
                          conventions == null
                              ? "0"
                              : conventions!.length.toString(),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0.sp),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          translate(context, "convention"),
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.lightGrey.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0.sp),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (conventions != null && conventions!.isEmpty)
                      NoData(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 2 - 100),
                        text: 'Non ci sono convenzioni',
                      )
                    else if (conventions == null)
                      Center(
                        child: CircularProgressIndicator(
                          color: ref.read(flavorProvider).primary,
                        ),
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: conventions?.length,
                        itemBuilder: (BuildContext context, index) =>
                            ConventionItem(conventions: conventions![index]),
                      )
                  ],
                ),
              ),
            ),
          );
  }
}

class ConventionItem extends ConsumerWidget {
  const ConventionItem({
    Key? key,
    required this.conventions,
  }) : super(key: key);

  final dynamic conventions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                    color:
                        ref.read(flavorProvider).lightPrimary.withOpacity(.1),
                    spreadRadius: 3,
                    blurRadius: 5)
              ],
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ref.read(flavorProvider).lightPrimary,
                                width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        // alignment: Alignment.center,
                        child: Image.network(
                          conventions['image'],
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${conventions['name']}",
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.bodyText.copyWith(
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text("${conventions['specialization']}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTheme.bodyText.copyWith(
                                fontSize: 10.0.sp,
                                color: AppColors.darkGrey.withOpacity(.8))),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      conventions['website'] != ""
                          ? InkWell(
                              onTap: () {
                                myapp.launchUrl("${conventions['website']}");
                              },
                              child: Image.asset(
                                ic_who_loves,
                                height: 3.0.h,
                              ),
                            )
                          : Container(),
                      conventions['website'] != ""
                          ? Text(
                              translate(context, "website"),
                              style: AppTheme.h5Style.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 8),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      conventions['phone_number'] != ""
                          ? InkWell(
                              onTap: () {
                                launch(
                                    "tel://${conventions['phone_number'].replaceAll(' ', '')}");
                              },
                              child: Image.asset(
                                ic_convension_call,
                                height: 3.0.h,
                              ),
                            )
                          : Container(),
                      conventions['phone_number'] != ""
                          ? Text(
                              translate(context, "who_loves"),
                              style: AppTheme.h5Style.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 8),
                            )
                          : Container(),
                    ],
                  )
                ])))
      ],
    );
  }
}
