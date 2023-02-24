import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/converter.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_search_results.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_show_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../config/preference_utils.dart';
import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';
import '../../custom_widgets/no_user.dart';

//TODO da ottimizzare

class SavedProductsScreen extends ConsumerStatefulWidget {
  const SavedProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/saved-products-screen';

  @override
  ConsumerState<SavedProductsScreen> createState() =>
      _SavedProductsScreenState();
}

class _SavedProductsScreenState extends ConsumerState<SavedProductsScreen> {
  List<dynamic>? productList;
  final ApisNew _apisNew = ApisNew();

  Future<void> getWishList() async {
    final result = await _apisNew.getWishList({
      'user_id': ref.read(authProvider).user?.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    productList = result.data;
    setState(() {});
  }

  Future<void> deleteFromWishList(int productId) async {
    final ApisNew _apisNew = ApisNew();
    final result = await _apisNew.removeFromWishList({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'user_id': ref.read(authProvider).user?.userId,
      'product_id': productId,
    });
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      getWishList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ref.read(flavorProvider).lightPrimary,
        onPressed: () {
          if (user != null) {
            Navigator.of(context).pushNamed(ProductsSearchResults.routeName);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          translate(context, 'wishlist'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "your_wishlist"),
                  style: AppTheme.h3Style.copyWith(
                      fontSize: 12.0.sp, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Text(
                  translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? "your_wishlist_des_parapharmacy"
                          : "your_wishlist_des_pharmacy"),
                  style: AppTheme.h3Style
                      .copyWith(fontSize: 10.0.sp, color: AppColors.lightGrey)),
              const SizedBox(
                height: 24,
              ),
              if (productList != null && productList!.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightSaffron,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: productList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = productList![index];
                      if (productList![index]['product_name'] == null) {
                        return const SizedBox();
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ProductDetailScreen.routeName,
                                arguments: fromMapDetailToProduct(
                                    productList![index]));
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          margin: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: ref
                                                .read(flavorProvider)
                                                .primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          //TODO fix
                                          child: 0 > 1
                                              ? Image.network(
                                                  '${product['imgUrl'].length > 0 ? product['imgUrl'] : ""}',
                                                  height: 10.0.h,
                                                  width: 10.0.h,
                                                )
                                              : Image.asset(
                                                  "assets/images/noImage.png"),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 140,
                                                  child: Text(
                                                      '${product['product_name']}',
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .darkGrey)),
                                                ),
                                                /*  if (product['price'] != null)
                                                  Text(
                                                    NumberFormat.currency(
                                                            locale: 'it_IT',
                                                            symbol: '€')
                                                        .format(double.parse(
                                                            product['price']
                                                                .replaceAll(
                                                                    ',', '.'))),
                                                    style: AppTheme
                                                        .subTitleStyle
                                                        .copyWith(
                                                            color: Colors
                                                                .grey[500],
                                                            fontSize: 10),
                                                  ),*/
                                                //TODO riprendere
                                                // _button(index),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //TODO completare
                                        SizedBox(
                                          height: 80,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: IconButton(
                                                onPressed: () async {
                                                  final result =
                                                      await deleteFromWishList(
                                                          int.parse(product[
                                                              'product_id']));
                                                  productList = null;
                                                  getWishList();
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  // color: Colors.black54,
                                                  size: 26,
                                                )),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              //TODO deprecated?
                              /*     secondaryActions: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: IconSlideAction(
                    // caption: 'Delete',
                    color: ref.read(flavorProvider).primary,
                    iconWidget:
                          !productList[index].addedWishList
                              ? Icon(
                                  Icons.favorite_outline,
                                  color: Colors.grey[200],
                                )
                              : const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                    onTap: () {},
                  )),
            ],*/
                            ],
                          ),
                        );
                      }
                    },
                  ),
                )
              else if (user != null &&
                  productList != null &&
                  productList!.isEmpty)
                NoData(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2 - 150),
                    text: translate(context, "No_Product"))
              else if (user == null)
                const NoUser()
              else
                Center(
                    child: CircularProgressIndicator(
                  color: ref.read(flavorProvider).lightPrimary,
                )),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavedProduct extends ConsumerStatefulWidget {
  const SavedProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  final dynamic product;

  @override
  ConsumerState<SavedProduct> createState() => _SavedProductState();
}

class _SavedProductState extends ConsumerState<SavedProduct> {
  //TODO fixare
  Future<dynamic> deleteFromWishList(int productId) async {
    final ApisNew _apisNew = ApisNew();
    final result = await _apisNew.removeFromWishList({
      'pharmacy_id': 1,
      'user_id': ref.read(authProvider).user?.userId,
      'product_id': productId,
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 0),
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
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    //TODO fix
                    child: 0 > 1
                        ? Image.network(
                            '${widget.product['imgUrl'].length > 0 ? widget.product['imgUrl'] : ""}',
                            height: 10.0.h,
                            width: 10.0.h,
                          )
                        : Image.asset("assets/images/noImage.png"),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text('${widget.product['product_name']}',
                                style: AppTheme.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.darkGrey)),
                          ),
                          Text(
                            '${PreferenceUtils.getString("currency")} ${double.parse('500').toStringAsFixed(2)}/ ${translate(context, "packaging")}',
                            style: AppTheme.subTitleStyle.copyWith(
                                color: Colors.grey[500], fontSize: 10),
                          ),
                          //TODO riprendere
                          // _button(index),
                        ],
                      ),
                    ),
                  ),
                  //TODO completare
                  SizedBox(
                    height: 80,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                          onPressed: () {
                            deleteFromWishList(
                                int.parse(widget.product['product_id']));
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            // color: Colors.black54,
                            size: 26,
                          )),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        //TODO deprecated?
        /*     secondaryActions: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: IconSlideAction(
                    // caption: 'Delete',
                    color: ref.read(flavorProvider).primary,
                    iconWidget:
                        !productList[index].addedWishList
                            ? Icon(
                                Icons.favorite_outline,
                                color: Colors.grey[200],
                              )
                            : const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                    onTap: () {},
                  )),
            ],*/
      ],
    );
  }
}

class ButtonCart extends ConsumerWidget {
  const ButtonCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              //TODO fix
              color: 1 > 0
                  ? AppColors.darkRed
                  : ref.read(flavorProvider).lightPrimary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SvgPicture.asset(
                    ic_add_cart_white,
                    height: 2.0.h,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  //TODO fixare
                  1 > 0
                      ? translate(context, "remove")
                      : translate(context, "add"),
                  style: AppTheme.h6Style
                      .copyWith(color: AppColors.white, fontSize: 12),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddNew extends StatelessWidget {
  const AddNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -10,
      right: 8,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductsShowAll.routeName);
        },
        child: Image.asset(
          ic_addnew_item,
          height: 4.0.h,
          width: 4.0.h,
        ),
      ),
    );
  }
}
