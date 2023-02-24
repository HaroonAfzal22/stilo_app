import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../screens/products/mom_and_baby_screen.dart';
import '../../screens/products/product_detail_screen.dart';

class ProductGridTile extends ConsumerWidget {
  const ProductGridTile({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product);
      },
      child: Container(
          width: 200,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.grey.withOpacity(.1),
                  spreadRadius: 3,
                  blurRadius: 5)
            ],
          ),
          child: Container(
            // height: 10.0.h,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: AppColors.white),
            // width: 18.0.w,
            child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, top: 0, right: 10, bottom: 0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            color: AppColors.lightSaffron,
                            // shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7.0),
                            child: product.images.isEmpty
                                ? Container(
                                    child: product.images.isEmpty
                                        ? Image.asset(
                                            "assets/images/noImage.png",
                                            height: 16.0.h,
                                            width: 16.0.h,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                "${product.images[0]['img']}",
                                            height: 16.0.h,
                                            width: 16.0.h,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                  "assets/images/noImage.png");
                                            }),
                                  )
                                : Container(
                                    child: product.images.isEmpty
                                        ? Image.asset(
                                            "assets/images/noImage.png",
                                            height: 16.0.h,
                                            width: 16.0.h,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                "${product.images[0]['img']}",
                                            height: 16.0.h,
                                            width: 16.0.h,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                  "assets/images/noImage.png");
                                            }),
                                  ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          product.productName + "\n",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.bodyText.copyWith(
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //TODO fix
                        /*  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           
                            product.productPrice == null
                                //TODO fix
                                ? Text('',
                                    // '${PreferenceUtils.getString("currency")}${double.parse("0.0").toStringAsFixed(2)}',
                                    style: AppTheme.h3Style.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.0.sp,
                                        color:
                                            ref.read(flavorProvider).primary))
                                //TODO fix
                                : Text('',
                                    // '${PreferenceUtils.getString("currency")}${double.parse(productList[index]['product_price'].toString()).toStringAsFixed(2)}',
                                    style: AppTheme.h3Style.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.0.sp,
                                        color:
                                            ref.read(flavorProvider).primary)),
                            //TODO fix
                            /*    productList[index]['period'] == ""
                              ? Text(
                                  productList[index]['period'] ==
                                          "monthly"
                                      ? translate(
                                          context, "month")
                                      : productList[index]
                                                  ['period'] ==
                                              "Daily"
                                          ? translate(
                                              context, "day")
                                          : productList[index][
                                                      'period'] ==
                                                  "Weekly"
                                              ? translate(
                                                  context,
                                                  "week")
                                              : productList[index]['period'] ==
                                                      "quarterly"
                                                  ? translate(
                                                      context,
                                                      "quarter")
                                                  : productList[index]['period'] ==
                                                          "yearly"
                                                      ? translate(
                                                          context,
                                                          "year")
                                                      : translate(
                                                          context,
                                                          "month"),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: AppTheme.h5Style.copyWith(
                                      color: AppColors.lightGrey,
                                      fontSize: 8.0.sp))
                              : const SizedBox()*/
                          ],
                        ), */

                        // _ratingbar(),
                        // const SizedBox(height: 5),
                        Text(product.manufacturerTitle ?? '',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: AppTheme.h5Style.copyWith(
                                color: AppColors.lightGrey, fontSize: 8.0.sp)),
                        product.code == null
                            ? const SizedBox()
                            : Text(
                                'Cod.${product.code}',
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: AppTheme.h5Style.copyWith(
                                    color: AppColors.lightGrey,
                                    fontSize: 8.0.sp),
                              ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    const ProductCardButton()
                  ],
                )),
          )),
    );
  }
}
