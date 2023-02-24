import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/flavor.dart';
import '../../custom_widgets/no_data.dart';
import '../../custom_widgets/products/product_grid_tile.dart';

class AllGlutenFreeProductsScreen extends ConsumerStatefulWidget {
  const AllGlutenFreeProductsScreen({Key? key}) : super(key: key);
  static const routeName = 'all-gluten-free-products-screen';

  @override
  _AllGlutenFreeProductsScreenState createState() =>
      _AllGlutenFreeProductsScreenState();
}

class _AllGlutenFreeProductsScreenState
    extends ConsumerState<AllGlutenFreeProductsScreen> {
  List<Product>? productList;
  final ApisNew _apisNew = ApisNew();

  Future<void> getAllGlutenFreeProducts() async {
    final result = await _apisNew.getAllGlutenFreeProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    productList = result;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllGlutenFreeProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prodotti senza glutine'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (productList != null && productList!.isNotEmpty)
              AlignedGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productList!.length,
                itemBuilder: (context, index) {
                  return ProductGridTile(
                    product: productList![index],
                  );
                },
              )
            /*   GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.54,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10),
                itemCount: productList!.length,
                itemBuilder: (context, index) {
                  return ProductGridTile(
                    product: productList![index],
                  );
                },
              ) */
            else if (productList != null && productList!.isEmpty)
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
    );
  }
}
