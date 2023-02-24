import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../config/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/flavor.dart';
import '../../models/product.dart';
import '../../translations/translate_string.dart';
import '../custom_widgets/products/product_grid_tile.dart';

class VetOffersScreen extends ConsumerStatefulWidget {
  const VetOffersScreen({Key? key}) : super(key: key);
  static const routeName = '/vet-offers-screen';

  @override
  ConsumerState<VetOffersScreen> createState() => _VetOffersScreenState();
}

class _VetOffersScreenState extends ConsumerState<VetOffersScreen> {
  final ScrollController _scrollController = ScrollController();
  int numPage = 0;
  bool doScrool = true;

  Future<void> getVetProducts() async {
    final result = await _apisNew.getProductSubCategories({
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
      "is_vaterinary_product": "Y",
      "page_no": numPage
    });
    doScrool = result.isNotEmpty;
    products ??= [];
    products!.addAll(result);
    setState(() {});
  }

  void _onScrollEvent() {
    final extentAfter = _scrollController.position.extentAfter;
    if (extentAfter == 0 && doScrool) {
      numPage++;
      _scrollController.position
          .jumpTo(_scrollController.position.maxScrollExtent - 0.1);
      getVetProducts();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScrollEvent);
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getVetProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  final ApisNew _apisNew = ApisNew();
  // final TextEditingController _controller = TextEditingController();
  List<Product>? products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          translate(context, 'offers_veterinary_department'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              //TODO prossimo rilascio
              //SearchBar(controller: _controller),
              const SizedBox(
                height: 16,
              ),
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
              // GridView.builder(
              //     physics: const NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     gridDelegate:
              //         const SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 2,
              //             childAspectRatio: 0.54,
              //             crossAxisSpacing: 5,
              //             mainAxisSpacing: 10),
              //     itemCount: products!.length,
              //     itemBuilder: (context, index) {
              //       return ProductGridTile(
              //         product: products![index],
              //       );
              //     })
              else if (products != null && products!.isEmpty)
                NoData(
                  text: translate(context, "No_Product"),
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
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
