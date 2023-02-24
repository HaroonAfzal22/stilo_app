import 'package:contacta_pharmacy/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/search_list.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';

class SavedProductItem extends ConsumerWidget {
  const SavedProductItem({Key? key, required this.product}) : super(key: key);

  final ProductItem product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    //TODO fix
                    child: Image.asset("assets/images/noImage.png"),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text('${product.drugType}',
                                style: AppTheme.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.darkGrey)),
                          ),
                          //_ratingbar(),
                          //TODO ripristinare
                          // Text(
                          //   '${PreferenceUtils.getString("currency")} ${double.parse('500').toStringAsFixed(2)}/ ${translate(context, "packaging")}',
                          //   style: AppTheme.subTitleStyle.copyWith(
                          //       color: Colors.grey[500], fontSize: 10),
                          // ),
                          //TODO riprendere
                          // _button(index),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        //TODO deprecated?
        /*     secondaryActions: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: IconSlideAction(
                    // caption: 'Delete',
                    color: ref.read(flavorProvider).primary,
                    iconWidget:
                        !productList[index].addedWishList
                            ? Icon(
                                Icons.favorite_outline,
                                color: Colors.grey[200],
                              )
                            : const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                    onTap: () {},
                  )),
            ],*/
      ],
    );
  }
}

class SavedProductItemAsProduct extends ConsumerWidget {
  const SavedProductItemAsProduct({Key? key, required this.product})
      : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    //TODO fix
                    child: Image.asset("assets/images/noImage.png"),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(product.productName,
                                style: AppTheme.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.darkGrey)),
                          ),
                          //_ratingbar(),
                          //TODO ripristinare
                          // Text(
                          //   '${PreferenceUtils.getString("currency")} ${double.parse('500').toStringAsFixed(2)}/ ${translate(context, "packaging")}',
                          //   style: AppTheme.subTitleStyle.copyWith(
                          //       color: Colors.grey[500], fontSize: 10),
                          // ),
                          //TODO riprendere
                          // _button(index),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
