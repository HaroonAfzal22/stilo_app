import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/products/product_list_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/product.dart';

class ProductListPromoAndShowCase extends ConsumerStatefulWidget {
  const ProductListPromoAndShowCase({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProductListPromoAndShowCase> createState() =>
      _ProductListPromoAndShowCaseState();
}

class _ProductListPromoAndShowCaseState
    extends ConsumerState<ProductListPromoAndShowCase> {
  List<Product>? promoProducts;
  List<Product>? showCaseProducts;
  List<Product> products = [];
  final ApisNew _apisNew = ApisNew();

  Future<void> fetchPromoProducts() async {
    final response = await _apisNew.fetchPromoProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    setState(() {
      products.addAll(response.data
          .map<Product>(
            (element) => Product.fromMap(element),
          )
          .toList());
    });
  }

  Future<void> fetchFeatureProducts() async {
    final response = await _apisNew.fetchFeatureProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      "is_stilo": 1,
    });
    setState(() {
      products.addAll(response.data
          .map<Product>(
            (element) => Product.fromMap(element),
          )
          .toList());
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPromoProducts();
    fetchFeatureProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (products.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.width / 2 - 32,
        child: ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) => ProductPreviewItem(
            product: products[index],
          ),
        ),
      );
    } else if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: NoData(
          text: translate(context, 'no_promo_no_feature'),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Center(
          child: CircularProgressIndicator(
            color: ref.read(flavorProvider).lightPrimary,
          ),
        ),
      );
    }
  }
}
