import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/products/product_list_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/product.dart';

class ProductSimilarList extends ConsumerStatefulWidget {
  final int productSubCategory;
  const ProductSimilarList({
    required this.productSubCategory,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProductSimilarList> createState() => _ProductSimilarListState();
}

class _ProductSimilarListState extends ConsumerState<ProductSimilarList> {
  List<Product>? products;
  final ApisNew _apisNew = ApisNew();

  Future<void> getSimilarProduct() async {
    final result = await _apisNew.getSimilarProduct({
      'type': "normal",
      'page_no': 1,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'product_subcategory_id': widget.productSubCategory
    });
    var tempList = result.data as List;
    products = [];
    if (tempList.length > 9) {
      tempList = tempList.sublist(0, 9);
    }
    for (var similarProductItem in tempList) {
      products!.add(Product.fromMap(similarProductItem));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSimilarProduct();
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? NoData(
            margin: const EdgeInsets.only(top: 20),
            text: translate(context, "no_product_list"))
        // const Center(
        //     child: CircularProgressIndicator(
        //       color: ref.read(flavorProvider).lightPrimary,
        //     ),
        //   )
        : products!.isEmpty
            ? const Center(child: Text("nessun prodotto simile"))
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 130,
                child: ListView.builder(
                  itemCount: products!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, index) =>
                      ProductPreviewItemNoLabel(
                    product: products![index],
                  ),
                ),
              );
  }
}
