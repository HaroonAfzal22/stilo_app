import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/product.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/products/product_grid_tile.dart';

class RentalProducts extends ConsumerStatefulWidget {
  const RentalProducts({Key? key}) : super(key: key);
  static const routeName = '/rental-products';

  @override
  ConsumerState<RentalProducts> createState() => _RentalProductsState();
}

class _RentalProductsState extends ConsumerState<RentalProducts> {
  List<Product>? products;
  final ApisNew _apisNew = ApisNew();

  Future<void> fetchRentalProducts() async {
    final result = await _apisNew.getRentalProducts({
      'user_id': ref.read(authProvider).user?.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    products = result;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      fetchRentalProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          translate(context, 'service_rental'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            if (user == null)
              const NoUser()
            else if (products != null && products!.isEmpty)
              NoData(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                text: translate(
                    context,
                    ref.read(flavorProvider).isParapharmacy
                        ? "No_Rental_Product_parapharmacy"
                        : "No_Rental_Product_pharmacy"),
              )
            else if (products != null)
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
            /*   GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.54,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ProductGridTile(
                      product: products![index],
                    );
                  }) */
            else
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
