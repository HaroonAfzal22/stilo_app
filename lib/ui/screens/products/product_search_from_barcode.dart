import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/product.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class ProductsSearchFromBarcode extends ConsumerStatefulWidget {
  const ProductsSearchFromBarcode({Key? key}) : super(key: key);
  static const routeName = '/products-search-from-barcode';

  @override
  _ProductsSearchFromBarcodeState createState() =>
      _ProductsSearchFromBarcodeState();
}

class _ProductsSearchFromBarcodeState
    extends ConsumerState<ProductsSearchFromBarcode> {
  final TextEditingController _controller = TextEditingController();
  Product? product;
  String? value;
  final ApisNew _apisNew = ApisNew();

  Future<void> searchItems() async {
    final result = await _apisNew.productBarcodeSearch({
      'barcode_number': value,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    product = result;
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
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: ref.read(flavorProvider).lightPrimary,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: TextField(
                  onSubmitted: (val) {
                    setState(() {
                      value = val;
                    });
                    searchItems();
                  },
                  textAlignVertical: TextAlignVertical.center,
                  controller: _controller,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: translate(context, 'search_hint'),
                  ),
                ),
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
            if (product != null)
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
                  itemCount: product != null ? 1 : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return SearchResultItem(
                      product: product!,
                    );
                  },
                ),
              )
            else if (product == null)
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
