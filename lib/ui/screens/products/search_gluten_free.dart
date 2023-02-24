import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/glutenFreeCategory.dart';
import 'package:contacta_pharmacy/models/product.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/products/product_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/constant.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';

class SearchGlutenFree extends ConsumerStatefulWidget {
  const SearchGlutenFree({Key? key}) : super(key: key);
  static const routeName = '/search-glutenfree';

  @override
  _SearchGlutenFreeState createState() => _SearchGlutenFreeState();
}

class _SearchGlutenFreeState extends ConsumerState<SearchGlutenFree> {
  final TextEditingController _controller = TextEditingController();
  List<Product>? productList;
  GlutenFreeCategory? value;
  final ApisNew _apisNew = ApisNew();
  final ScrollController _scrollController = ScrollController();
  int numPage = 0;
  bool doScrool = true;

  // Future<void> searchItems() async {
  //   final result = await _apisNew.searchGlutenFreeProducts(
  //     {
  //       'pharmacy_id': Constant.pharmacy_id,
  //     },
  //   );
  //   productList = result
  //       .where((p) => p.productCategoryId == value!.id.toString())
  //       .toList();
  // }

  Future<void> searchItemById() async {
    final result = await _apisNew.getProductSubCategories({
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
      "is_gultan": "Y",
      "product_subcategory_id": value?.id,
      "page_no": numPage
    });
    doScrool = result.isNotEmpty;
    productList ??= [];
    productList!.addAll(result);
    setState(() {});
  }

  void _onScrollEvent() {
    final extentAfter = _scrollController.position.extentAfter;
    if (extentAfter == 0 && doScrool) {
      numPage++;
      _scrollController.position
          .jumpTo(_scrollController.position.maxScrollExtent - 0.1);
      searchItemById();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScrollEvent);
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      value = ModalRoute.of(context)!.settings.arguments as GlutenFreeCategory;
      await searchItemById();
      setState(() {});
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
        title: Text(
          value == null ? "" : value!.title!,
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            /*      Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: ref.read(flavorProvider).lightPrimary,
              child: SearchBar(
                controller: _controller,
                onChanged: (value) {},
              ),
            ),*/

            const SizedBox(
              height: 16,
            ),
            if (productList != null && productList!.isEmpty)
              NoData(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  text: translate(context, "No_Product"))
            else if (productList != null && productList!.isNotEmpty)
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: AlignedGridView.count(
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
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.54,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10),
                    itemCount: productList!.length,
                    itemBuilder: (context, index) {
                      return ProductGridTile(
                        product: productList![index],
                      );
                    }), */
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
              )
          ],
        ),
      ),
    );
  }
}
