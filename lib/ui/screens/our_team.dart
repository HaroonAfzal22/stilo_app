import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../../utils/ImageString.dart';

class OurTeamScreen extends ConsumerStatefulWidget {
  const OurTeamScreen({Key? key}) : super(key: key);
  static const routeName = '/our-team-screen';

  @override
  ConsumerState<OurTeamScreen> createState() => _OurTeamScreenState();
}

class _OurTeamScreenState extends ConsumerState<OurTeamScreen> {
  List<dynamic>? teamList;
  final ApisNew _apisNew = ApisNew();

  Future<void> getTeam() async {
    final result = await _apisNew.getTeamData(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
        'sede_id': ref.read(siteProvider)!.id,
      },
    );
    setState(() {
      teamList = result.data;
    });
  }

  Widget _Content(title, description) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[100],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$title",
                          style: TextStyle(
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.w500,
                              color: ref.read(flavorProvider).primary),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              ic_cancel,
                              height: 18,
                              color: AppColors.darkGrey,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 10.0),
              child: ListView(
                children: [
                  Text(
                    description,
                    style: AppTheme.h4Style.copyWith(
                        fontSize: 10.0.sp, color: AppColors.veryDarkGrey),
                  )
                ],
              ),
            ),
          ),
        ]);
  }

  @override
  void initState() {
    super.initState();
    getTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          translate(context, 'our_team'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "Our_team_disposal"),
                  style: AppTheme.bodyText.copyWith(
                      color: AppColors.black,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.bold)),
              Text(
                translate(context, "Our_team_disposal_des"),
                style: AppTheme.bodyText.copyWith(
                  fontSize: 11.0.sp,
                  color: AppColors.darkGrey.withOpacity(
                    .8,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              if (teamList != null && teamList!.isEmpty)
                NoData(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  text: translate(context, "No_Team"),
                )
              else if (teamList != null)
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: teamList!.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 5.0,
                                    spreadRadius: 4),
                              ]),
                          child: InkWell(
                            onTap: () {
                              /*   showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return SizedBox(
                                    height: double.infinity,
                                    child: _Content(ourTeamData[index]['name'],
                                        ourTeamData[index]['description']));
                              },
                            );*/
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 15.0.h,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          teamList![index]['asset_image'],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 10, left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${teamList![index]['name']}",
                                            style: AppTheme.h4Style.copyWith(
                                                fontSize: 13.0.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${teamList![index]['speciality']}",
                                            style: AppTheme.h4Style.copyWith(
                                                fontSize: 9.0.sp,
                                                fontWeight: FontWeight.w300,
                                                color: ref
                                                    .read(flavorProvider)
                                                    .lightPrimary),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              "${teamList![index]['description']}",
                                              // maxLines: 3,
                                              // overflow: TextOverflow.ellipsis,
                                              style: AppTheme.h4Style.copyWith(
                                                  fontSize: 10.0.sp,
                                                  color:
                                                      AppColors.veryDarkGrey),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ));
                    })
              else
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
