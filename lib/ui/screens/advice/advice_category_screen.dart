import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/advice.dart';
import 'package:contacta_pharmacy/models/adviceCategory.dart';
import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advice_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class AdviceCategoryScreen extends ConsumerStatefulWidget {
  const AdviceCategoryScreen({Key? key}) : super(key: key);

  static const routeName = '/advice-category-screen';

  @override
  ConsumerState<AdviceCategoryScreen> createState() =>
      _AdviceCategoryScreenState();
}

class _AdviceCategoryScreenState extends ConsumerState<AdviceCategoryScreen> {
  AdviceCategory? adviceCategory;
  List<Advice>? adviceList;
  final ApisNew _apisNew = ApisNew();

  Future<void> getAdviceCategories() async {
    final result = await _apisNew.getAdviceForCategory({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'category_id': adviceCategory!.id,
    });
    adviceList = [];

    for (var adviceItem in result.data) {
      adviceList!.add(Advice.fromJson(adviceItem));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      adviceCategory =
          ModalRoute.of(context)!.settings.arguments as AdviceCategory;
      if (adviceCategory != null) {
        getAdviceCategories();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          translate(context, 'advice'),
        ),
      ),
      body: adviceList != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: adviceList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => AdviceCategoryItems(
                      advice: adviceList![index],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: ref.read(flavorProvider).lightPrimary,
              ),
            ),
    );
  }
}

class AdviceCategoryItems extends StatelessWidget {
  const AdviceCategoryItems({required this.advice, Key? key}) : super(key: key);

  final Advice advice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AdviceDetail.routeName, arguments: advice);
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
  }) : super(key: key);

  final Color color;
  final String text;
  final VoidCallback onTap;

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
          child: const Center(
            child: Text(
              "text",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
