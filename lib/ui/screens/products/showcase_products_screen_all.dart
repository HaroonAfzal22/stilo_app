import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/products/product_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/apisNew.dart';
import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../custom_widgets/no_data.dart';

class ShowcaseProductsScreenAll extends ConsumerStatefulWidget {
  const ShowcaseProductsScreenAll({Key? key}) : super(key: key);
  static const routeName = '/showcase-products-screen-all';

  @override
  _ShowcaseProductsScreenAllState createState() =>
      _ShowcaseProductsScreenAllState();
}

class _ShowcaseProductsScreenAllState
    extends ConsumerState<ShowcaseProductsScreenAll> {
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

  @override
  void initState() {
    super.initState();
    fetchShowcaseProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'featured_products'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (products != null && products!.isNotEmpty)
                AlignedGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products!.length,
                  itemBuilder: (context, index) {
                    return ProductGridTile(
                      product: products![index],
                    );
                  },
                )
              /*  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.54,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10),
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      return ProductGridTile(
                        product: products![index],
                      );
                    }) */
              else if (products != null && products!.isEmpty)
                NoData(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                )
              else
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
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
