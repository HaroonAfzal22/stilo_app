import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/products/product_grid_tile.dart';

class ProductCategoryDetail extends ConsumerStatefulWidget {
  const ProductCategoryDetail({Key? key}) : super(key: key);
  static const routeName = '/product-category-detail-screen';

  @override
  _ProductCategoryDetailState createState() => _ProductCategoryDetailState();
}

class _ProductCategoryDetailState extends ConsumerState<ProductCategoryDetail> {
  // final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApisNew _apisNew = ApisNew();
  Map<String, dynamic>? subCategory;
  int? categoryId;
  String? productGmpCategory;
  bool doScrool = true;
  List<Product>? products;
  int numPage = 0;

  Future<void> search() async {
    final response = await _apisNew.searchProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      "type": "normal",
      "search": "",
      "barcode_number": "",
      "product_category_id": (categoryId ?? "0"),
      "product_subcategory_id": (subCategory?['id'] ?? 'null'),
      "page_no": numPage,
    });
    doScrool = response.isNotEmpty;
    products ??= [];
    products!.addAll(response);
    setState(() {});
  }

  Future<void> getProductsGmp() async {
    List<Product> response;

    response = await _apisNew.getProductsGmp({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      "product_category_id": (categoryId ?? "0"),
      "product_gmp_category": productGmpCategory,
      "page_no": numPage,
    });

    doScrool = response.isNotEmpty;
    products ??= [];
    products!.addAll(response);
    setState(() {});
  }

  void _onScrollEvent() async {
    final extentAfter = _scrollController.position.extentAfter;
    if (extentAfter == 0 && doScrool) {
      numPage++;
      _scrollController.position
          .jumpTo(_scrollController.position.maxScrollExtent - 0.1);
      if ((categoryId!) < 9) {
        await search();
      } else {
        await getProductsGmp();
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScrollEvent);

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var obj =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      print(obj);
      setState(() {
        categoryId = obj['category'] as int?;
        subCategory = obj['subcategory'];
        productGmpCategory = obj['product_gmp_category'];
      });
      if ((categoryId!) < 9) {
        await search();
      } else {
        await getProductsGmp();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          subCategory != null ? subCategory!['title'] : '',
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            //TODO prossimo rilascio
            /*   SearchBar(controller: _controller),
            const SizedBox(
              height: 16,
            ),*/
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            else if (products == null)
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                child: Center(
                  child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary),
                ),
              ),
            if (products != null && products!.isEmpty)
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                child: Center(
                  child: Text(
                    translate(context, 'no_product_list'),
                  ),
                ),
              ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
