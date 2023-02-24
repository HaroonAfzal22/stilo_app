import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/product.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/search_bar.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class ProductsSearchResults extends ConsumerStatefulWidget {
  const ProductsSearchResults({Key? key}) : super(key: key);
  static const routeName = '/products-search-results';

  @override
  _ProductsSearchResultsState createState() => _ProductsSearchResultsState();
}

class _ProductsSearchResultsState extends ConsumerState<ProductsSearchResults> {
  final TextEditingController _controller = TextEditingController();
  List<Product>? productList;
  String? value;
  final ApisNew _apisNew = ApisNew();

  Future<void> searchItems() async {
    final result = await _apisNew.searchAllProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'normal',
      'search': _controller.text,
    });
    productList = result;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      value = ModalRoute.of(context)!.settings.arguments as String?;
      if (value != null) _controller.text = value!;
      searchItems();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'research'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: ref.read(flavorProvider).lightPrimary,
              child: SearchBar(
                controller: _controller,
                onSubmitted: (value) {
                  setState(() {
                    productList = null;
                  });
                  searchItems();
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              translate(
                context,
                'search_result',
              ),
              style: AppTheme.h3Style
                  .copyWith(fontSize: 18.0.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            if (productList != null && productList!.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  color: AppColors.lightSaffron,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SearchResultItem(
                      product: productList![index],
                    );
                  },
                ),
              )
            else if (productList != null && productList!.isEmpty)
              NoData(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  text: translate(context, "No_Product"))
            else
              CircularProgressIndicator(
                color: ref.read(flavorProvider).lightPrimary,
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

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    print(product.singleImage);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product);
      },
      child: Column(
        children: [
          Center(
            child: Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
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
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: product.images.isEmpty
                              ? Image.asset("assets/images/noImage.png")
                              : CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: product.images[0]['img'] ?? '',
                                  errorWidget: (context, url, error) =>
                                      Image.asset("assets/images/noImage.png"),
                                ),
                          /*      productList['product_image'] != null
                              ? productList['product_image'].length > 0
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          '${productList['product_image'].length > 0 ? productList['product_image'][0]['img'] : ""}',
                                      fit: BoxFit.contain,
                                      */ /*fit: BoxFit.cover,
                            height: 20.0.h,
                            width: 10.0.h,*/ /*
                                      //scale: 5,
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                            "assets/images/noImage.png");
                                      },
                                    )
                                  : Image.asset("assets/images/noImage.png")
                              : productList['prodcut_image'].length > 0
                                  ? Image.network(
                                      '${productList['prodcut_image'].length > 0 ? productList['prodcut_image'][0]['img'] : ""}',
                                      fit: BoxFit.fitHeight,
                                      errorBuilder: (context, error, trace) {
                                        return Image.asset(
                                            "assets/images/noImage.png");
                                      },
                                    )
                                  : Image.asset("assets/images/noImage.png"),*/
                        ),
                        Expanded(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 170,
                              child: Text(
                                product.productName,
                                style: AppTheme.h6Style.copyWith(
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            product.productCode == null && product.code == null
                                ? const SizedBox()
                                : Text('Code ${product.productCode}',
                                    style: AppTheme.h6Style.copyWith(
                                        fontSize: 9.0.sp,
                                        color: AppColors.darkGrey
                                            .withOpacity(.5))),
                            const SizedBox(
                              height: 3,
                            ),
                            //TODO recover
                            // _button(index),
                            const SizedBox(
                              height: 8.0,
                            )
                          ],
                        )),
                        const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            )),
                      ],
                    ),
                  ],
                )),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
