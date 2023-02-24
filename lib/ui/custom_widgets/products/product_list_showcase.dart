import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/product.dart';

//TODO refactor suddividere in due Widget uno fetcha promo + vetrina l'altro solo vetrina

class ProductListShowCase extends ConsumerStatefulWidget {
  const ProductListShowCase({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProductListShowCase> createState() =>
      _ProductListShowCaseState();
}

class _ProductListShowCaseState extends ConsumerState<ProductListShowCase> {
  List<Product>? products;
  final ApisNew _apisNew = ApisNew();

  Future<void> fetchShowcaseProducts() async {
    //TODO fixare params and endpoint
    final response = await _apisNew.fetchFeatureProducts(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
        "is_stilo": 1,
      },
    );
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
    if (products != null && products!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 130,
        child: ListView.builder(
          itemCount: products!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) => ProductPreviewItem(
            product: products![index],
          ),
        ),
      );
    } else if (products != null && products!.isEmpty) {
      return const NoData();
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CircularProgressIndicator(
          color: ref.read(flavorProvider).lightPrimary,
        ),
      );
    }
  }
}

class ProductPreviewItem extends ConsumerWidget {
  const ProductPreviewItem({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width / 2 - 32,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
        child: Stack(
          children: [
            SizedBox(
              height: 16,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: product.isPromotional == 'Y'
                            ? Colors.amber
                            : ref.read(flavorProvider).primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      //TODO add translation
                      child: Text(
                        product.isPromotional == 'Y' ? 'Promo' : 'Vetrina',
                        style: const TextStyle(
                            height: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 9),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: product.images.isEmpty
                      ? Image.asset("assets/images/noImage.png")
                      : CachedNetworkImage(
                          imageUrl: product.images[0]['img'] ??
                              'https://via.placeholder.com/140x100',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/noImage.png"),
                        ),
                ),
                const SizedBox(
                  height: 8,
                ),
                //TODO fixare UI
                Text(
                  product.productName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductPreviewItemNoLabel extends StatelessWidget {
  const ProductPreviewItemNoLabel({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 170,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                padding: const EdgeInsets.all(4),
                //TODO fix
                child: product.images.isEmpty
                    ? Image.asset("assets/images/noImage.png")
                    : Image.network(
                        product.images[0]['img'] ??
                            'https://via.placeholder.com/140x100',
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            //TODO fixare UI
            Text(
              product.productName.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
