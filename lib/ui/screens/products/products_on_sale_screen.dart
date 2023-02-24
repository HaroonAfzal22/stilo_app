import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/pharma_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/products/product_grid_tile.dart';

class ProductsOnSaleScreen extends ConsumerStatefulWidget {
  const ProductsOnSaleScreen({Key? key}) : super(key: key);
  static const routeName = '/products-on-sale-screen';

  @override
  _ProductsOnSaleScreenState createState() => _ProductsOnSaleScreenState();
}

class _ProductsOnSaleScreenState extends ConsumerState<ProductsOnSaleScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Product>? productList;
  final ApisNew _apisNew = ApisNew();

  Future<void> fetchPromoProducts() async {
    final response = await _apisNew.fetchPromoProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    setState(() {
      productList = response.data
          .map<Product>(
            (element) => Product.fromMap(element),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPromoProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          translate(context, 'promotional'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO fixare nel secondo rilascio
            //SearchBar(controller: _controller),
            PharmaHeader(
              title: translate(context, 'product_on_offer'),
              subtitle: translate(context, 'product_on_offer_des'),
              imgUrl: 'assets/images/ic_promotionimg.png',
            ),
            const SizedBox(
              height: 16,
            ),
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
            /*  GridView.builder(
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
                  return ProductGridTile(product: productList![index]);
                },
              ) */
            else if (productList != null && productList!.isEmpty)
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 180),
                child: const NoData(),
              )
            else
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 180),
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
    );
  }
}
