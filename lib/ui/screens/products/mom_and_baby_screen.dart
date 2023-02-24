import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/products/product_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class MomAndBabyScreen extends ConsumerStatefulWidget {
  const MomAndBabyScreen({Key? key}) : super(key: key);
  static const routeName = '/mom-and-baby-screen';

  @override
  ConsumerState<MomAndBabyScreen> createState() => _MomAndBabyScreenState();
}

class _MomAndBabyScreenState extends ConsumerState<MomAndBabyScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Product>? products;
  final ApisNew _apisNew = ApisNew();
  final ScrollController _scrollController = ScrollController();
  int numPage = 0;
  bool doScrool = true;

  Future<void> getMomAndBabyProducts() async {
    final result = await _apisNew.getMomAndBabyProducts(
      {'pharmacy_id': ref.read(flavorProvider).pharmacyId, 'page_no': numPage},
    );
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

      getMomAndBabyProducts();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getMomAndBabyProducts();
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          translate(context, 'mom_child'),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
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
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2 - 100),
                    text: translate(context, "No_Product"))
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCardButton extends ConsumerWidget {
  const ProductCardButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 0.0.h),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ref.read(flavorProvider).primary,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: Text(
            translate(context, "view_details"),
            textAlign: TextAlign.center,
            style: AppTheme.h5Style.copyWith(
                fontSize: 8.0.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
