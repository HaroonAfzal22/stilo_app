import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/showcase_products_screen_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';

import '../../../apis/apisNew.dart';
import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class ShowCaseProductsScreenPreview extends ConsumerStatefulWidget {
  const ShowCaseProductsScreenPreview({Key? key}) : super(key: key);
  static const routeName = '/showcase-products-screen';

  @override
  ConsumerState<ShowCaseProductsScreenPreview> createState() =>
      _ShowCaseProductsScreenPreviewState();
}

class _ShowCaseProductsScreenPreviewState
    extends ConsumerState<ShowCaseProductsScreenPreview> {
  List<Product>? products;
  final ApisNew _apisNew = ApisNew();

  Future<void> fetchShowcaseProducts() async {
    final response = await _apisNew.fetchFeatureProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      "is_stilo": 1,
    });
    setState(() {
      products = response.data
          .map<Product>(
            (element) => Product.fromMap(element),
          )
          .toList();
    });
  }

  AutoScrollController controller = AutoScrollController();

  @override
  void initState() {
    super.initState();
    fetchShowcaseProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: Text(
          translate(
            context,
            'showcase_products',
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(context, "featured_product_title"),
                maxLines: 1,
                style: AppTheme.h4Style.copyWith(
                  fontSize: 16.0.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                translate(context, "featured_product_des"),
                style: AppTheme.bodyText.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (products != null && products!.isNotEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: products!.length,
                      controller: controller,
                      itemBuilder: (context, index) {
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: controller,
                          index: index,
                          child: SizedBox(
                              width: 60.0.w,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 2,
                                color: AppColors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: AppColors.lightSaffron,
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              child: products![index]
                                                      .images
                                                      .isEmpty
                                                  ? Image.asset(
                                                      "assets/images/noImage.png",
                                                      height: 25.0.h,
                                                      width: 30.0.w,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          "${products![index].images[0]['img']}",
                                                      height: 25.0.h,
                                                      width: 30.0.w,
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Image.asset(
                                                            "assets/images/noImage.png");
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        products![index].productName,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTheme.bodyText.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          NumberFormat.currency(
                                                  locale: 'it_IT', symbol: '€')
                                              .format(products![index]
                                                  .productPrice),
                                          style: AppTheme.h6Style.copyWith(
                                              color: ref
                                                  .read(flavorProvider)
                                                  .primary,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ProductDetailScreen.routeName,
                                              arguments: products![index]);
                                        },
                                        child: Container(
                                          height: 5.0.h,
                                          width: 40.0.w,
                                          decoration: BoxDecoration(
                                            color: ref
                                                .read(flavorProvider)
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  translate(
                                                      context, "find_out_more"),
                                                  style: AppTheme.h5Style
                                                      .copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontSize: 8.0.sp))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }),
                )
              else if (products != null && products!.isEmpty)
                Container(
                    margin: const EdgeInsets.only(top: 100, bottom: 50),
                    child: Center(
                      child: Text(
                        translate(context, 'no_feature_products'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
              else
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ShowcaseProductsScreenAll.routeName);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      translate(context, "discover_button"),
                      style: AppTheme.h3Style.copyWith(
                          fontSize: 10.0.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 64,
              )
            ],
          ),
        ),
      ),
    );
  }
}
