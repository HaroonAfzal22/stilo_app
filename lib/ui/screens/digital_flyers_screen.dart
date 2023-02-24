import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../config/MyApplication.dart';
import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../custom_widgets/no_data.dart';

class DigitalFlyersScreen extends ConsumerStatefulWidget {
  const DigitalFlyersScreen({Key? key}) : super(key: key);
  static const routeName = '/digital-flyers-screen';

  @override
  ConsumerState<DigitalFlyersScreen> createState() =>
      _DigitalFlyersScreenState();
}

class _DigitalFlyersScreenState extends ConsumerState<DigitalFlyersScreen> {
  final ApisNew _apisNew = ApisNew();
  List<dynamic>? flyers;

  @override
  void initState() {
    super.initState();
    getFlyers();
  }

  Future<void> getFlyers() async {
    final result = await _apisNew.getFlyers(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );
    flyers = result.data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, "flyers"),
          textAlign: TextAlign.center,
          style: AppTheme.h4Style.copyWith(
              color: ref.read(flavorProvider).primary,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "our_flyers"),
                  style: AppTheme.bodyText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.bold)),
              Text(
                translate(context, "our_flyers_des"),
                style: AppTheme.bodyText
                    .copyWith(fontSize: 10.0.sp, color: AppColors.lightGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              if (flyers != null && flyers!.isNotEmpty)
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  shrinkWrap: true,
                  itemCount: flyers!.length,
                  itemBuilder: (context, index) =>
                      DigitalFlyerItem(flyer: flyers![index]),
                )
              else if (flyers != null && flyers!.isEmpty)
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 130),
                  child: NoData(
                    text: translate(
                        context,
                        ref.read(flavorProvider).isParapharmacy
                            ? 'No_Flyers_parapharmacy'
                            : 'No_Flyers_pharmacy'),
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ),
                ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalFlyerItem extends ConsumerWidget {
  const DigitalFlyerItem({
    Key? key,
    required this.flyer,
  }) : super(key: key);

  final dynamic flyer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 20.0.h,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: '${flyer['image']}',
                  fit: BoxFit.fitWidth,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10),
            child: Text(
              '${flyer['name']}',
              style: AppTheme.h5Style
                  .copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.bold),
            ),
          ),
          //TODO fix
          /*    Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
              ),
              child: Html(
                  data:
                  """<div> ${flyersData[index]['short_description'].toString().substring(0, flyersData[index]['short_description'].toString().length >= 50 ? 50 : flyersData[index]['short_description'].toString().length)} </div>""",
                  onLinkTap: (String url, RenderContext context, Map<String, String> attributes, dom.Element element) {
                    launchUrl(url);
                    //open URL in webview, or launch URL in browser, or any other logic here
                  }
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    launchUrl("${flyer['url']}");
                    /*   Navigator.pushNamed(context, FlyerDetails.routeName,
                arguments: flyersData[index]);*/
                  },
                  child: Container(
                    height: 3.2.h,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(translate(context, "read_the_digital_flyers"),
                            style: AppTheme.h5Style.copyWith(
                                color: AppColors.white, fontSize: 10.0.sp))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
