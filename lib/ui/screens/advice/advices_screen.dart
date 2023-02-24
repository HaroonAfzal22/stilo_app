import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/models/advice.dart';
import 'package:contacta_pharmacy/models/adviceCategory.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advice_category_screen.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advice_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

//TODO aggiungere LoadingState e categoriesScreen

class AdvicesScreen extends ConsumerStatefulWidget {
  const AdvicesScreen({Key? key}) : super(key: key);
  static const routeName = '/advices-screen';

  @override
  ConsumerState<AdvicesScreen> createState() => _AdvicesScreenState();
}

class _AdvicesScreenState extends ConsumerState<AdvicesScreen> {
  final List<Color> colors = const [
    Color(0xffFFB468),
    Color(0xff007F7A),
    Color(0xffE8505B),
    Color(0xffC550BA),
    Color(0xff4B8376),
    Color(0xffE3844C),
  ];
  final ApisNew _apisNew = ApisNew();
  List<Advice>? advicesData;
  List<AdviceCategory>? adviceCategoriesData;
  Map<int, bool> adviceCheckEmptyMap = {};

  Future<bool> checkEmptyCategories(int adviceCatId) async {
    final result = await _apisNew.getAdviceForCategory({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'category_id': adviceCatId,
    });
    return result.data.length == 0;
  }

  Future<void> getAdvices() async {
    final result = await _apisNew.getPharmacyAdvices(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );
    advicesData = [];
    for (var adviceItem in result.data) {
      advicesData!.add(Advice.fromJson(adviceItem));
    }
    setState(() {});
  }

  Future<void> getAdviceCategories() async {
    final result = await _apisNew.getPharmacyAdviceCategories(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );
    adviceCategoriesData = [];
    for (var adviceCategoryItem in result.data) {
      var adviceCatElement = AdviceCategory.fromJson(adviceCategoryItem);
      adviceCategoriesData!.add(adviceCatElement);
      var isEmpty = await checkEmptyCategories(adviceCatElement.id!);
      adviceCheckEmptyMap[adviceCatElement.id!] = isEmpty;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await getAdviceCategories();
      await getAdvices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return advicesData == null || adviceCategoriesData == null
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
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text(
                translate(context, 'advice'),
              ),
            ),
            body: advicesData == null
                ?  Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          TitleText(
                              color: Colors.black,
                              text: translate(
                                  context, 'latest_recommendations_inserted'),
                              textAlign: TextAlign.start),
                          const SizedBox(
                            height: 16,
                          ),
                          if (advicesData != null && advicesData!.isEmpty)
                            NoData(
                                margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 2 -
                                            100),
                                text: translate(
                                    context,
                                    ref.read(flavorProvider).isParapharmacy
                                        ? "No_Advice_parapharmacy"
                                        : "No_Advice_pharmacy"))
                          else if (advicesData != null)
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 16,
                              ),
                              itemCount: advicesData!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => AdviceItem(
                                advice: advicesData![index],
                              ),
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          TitleText(
                            textAlign: TextAlign.start,
                            text: translate(context, 'search_by_category'),
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (adviceCategoriesData != null &&
                              adviceCategoriesData!.isEmpty)
                            NoData(
                                margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 2 -
                                            100),
                                text: translate(
                                    context,
                                    ref.read(flavorProvider).isParapharmacy
                                        ? "No_Advice_parapharmacy"
                                        : "No_Advice_pharmacy"))
                          else if (adviceCategoriesData != null)
                            GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 2.1,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 2),
                                itemCount: adviceCategoriesData!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      bool isEmptyCat = adviceCheckEmptyMap[
                                              adviceCategoriesData![index]
                                                  .id] ??
                                          true;
                                      if (!isEmptyCat) {
                                        Navigator.of(context).pushNamed(
                                          AdviceCategoryScreen.routeName,
                                          arguments:
                                              adviceCategoriesData![index],
                                        );
                                      } else {
                                        showredToast(
                                            translate(
                                                context, "no_advice_available"),
                                            context);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 0),
                                      decoration: BoxDecoration(
                                        color: colors[
                                            Random().nextInt(colors.length)],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(
                                            adviceCategoriesData![index].title!,
                                            style: AppTheme.h6Style.copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                        ],
                      ),
                    ),
                  ),
          );
  }
}

class AdviceItem extends StatelessWidget {
  const AdviceItem({Key? key, required this.advice}) : super(key: key);

  final Advice advice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AdviceDetail.routeName, arguments: advice);
        // context: context,
        // isScrollControlled: true,
        // builder: (context) => AdviceDetail(advice));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  height: 60,
                  imageUrl: advice.image!,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          advice.title!,
                          style: TextStyle(
                            // fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0.sp,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  Text(
                    translate(context, "Posted") + ' ' + advice.date!,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.h6Style.copyWith(
                      fontSize: 8.0.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightGrey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
    required this.color,
    required this.text,
    required this.onTap,
    //required this.adviceCategory,
  }) : super(key: key);

  final Color color;
  final String text;
  final VoidCallback onTap;
  // final AdviceCategory adviceCategory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              "text",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
