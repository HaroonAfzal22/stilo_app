import 'package:badges/badges.dart';
import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/home_item.dart';
import 'package:contacta_pharmacy/ui/screens/cart/cart_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/galenic_preparation_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/gluten_free_products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/mom_and_baby_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_categories_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_add_product_from_photo.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_on_sale_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_search_results.dart';
import 'package:contacta_pharmacy/ui/screens/products/saved_products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/showcase_products_screen_preview.dart';
import 'package:contacta_pharmacy/ui/screens/vet_offers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../config/MyApplication.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/bottom_sheets/bottom_sheet_prescription.dart';
import '../../custom_widgets/custom_drawer.dart';
import '../../custom_widgets/products/product_list_showcase.dart';
import '../../custom_widgets/title_text.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final flavor = ref.read(flavorProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          drawer: const CustomDrawer(),
          key: _key,
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: const [
              /*       GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                child: Image.asset(
                  'assets/icons/cart_blue.png',
                  height: 20,
                  width: 20,
                ),
              ),*/
              CartIconWithBadge(),
              SizedBox(
                width: 16,
              ),
            ],
            elevation: 0,
            centerTitle: true,
            title: Text(
              translate(context, 'products'),
            ),
            leading: IconButton(
              onPressed: () {
                _key.currentState!.openDrawer();
              },
              icon: Image.asset(
                'assets/icons/ic_menu.png',
                color: ref.read(flavorProvider).lightPrimary,
                height: 18,
                width: 34,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: TextField(
                    onSubmitted: (value) {
                      Navigator.of(context).pushNamed(
                          ProductsSearchResults.routeName,
                          arguments: value);
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
                      //TODO rivedere???
                      /*     suffixIcon: IconButton(
                        onPressed: () async {
                          var code = await scanBarcode();
                          if (code != null) {
                            Navigator.of(context).pushNamed(
                                ProductsSearchResults.routeName,
                                arguments: code);
                          }
                        },
                        icon: Image.asset(
                          'assets/images/barcode.png',
                          height: 50,
                          width: 50,
                        ),
                      ),*/
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: translate(context, 'search_hint'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ProductCategoriesScreen.routeName);
                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/ic_productlist.svg',
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 24,
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: Text(
                                translate(context, 'list_product'),
                                style: AppTheme.bodyText.copyWith(
                                    color: AppColors.white,
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ProductsAddProductFromPhotoScreen.routeName);
                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/ic_add_photo_product.svg',
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 24,
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: Text(
                                translate(context, 'add_product'),
                                style: AppTheme.bodyText.copyWith(
                                    color: AppColors.white,
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (flavor.sendReceiptEnabled && !flavor.isParapharmacy)
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (BuildContext context) =>
                                  const PrescriptionBottomSheet(),
                            );
                          },
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/images/ic_send_recipt_product.svg',
                                width: MediaQuery.of(context).size.width * 0.5 -
                                    24,
                              ),
                              Positioned(
                                left: 8,
                                top: 8,
                                child: Text(
                                  translate(
                                      context,
                                      ref.read(flavorProvider).isParapharmacy
                                          ? 'submit_recipe_parapharmacy'
                                          : 'submit_recipe_pharmacy'),
                                  style: AppTheme.bodyText.copyWith(
                                      color: AppColors.white,
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (flavor.sendReceiptEnabled && !flavor.isParapharmacy)
                        const SizedBox(
                          width: 8,
                        ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ProductsOnSaleScreen.routeName);
                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/images/ic_product_order.svg',
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 24,
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: Text(
                                translate(context, 'product_offer'),
                                style: AppTheme.bodyText.copyWith(
                                    color: AppColors.white,
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(
                          text: translate(context, 'featured_products'),
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.left,
                          height: null,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ShowCaseProductsScreenPreview.routeName);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate(context, 'all')),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const ProductListShowCase(),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ItemTileIconWithBackground(
                        title: translate(context, 'Saved_product'),
                        text: translate(context, 'Saved_product_des'),
                        image: Icons.favorite,
                        color: const Color(0xFFED7F5E),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SavedProductsScreen.routeName);
                        },
                      ),
                      if (flavor.hasGalenic)
                        const SizedBox(
                          height: 8,
                        ),
                      if (flavor.hasGalenic)
                        ItemTileSVGWithBackground(
                          title: translate(context, 'Galenic_prepration'),
                          color: const Color(0xFF5286F5),
                          text: translate(
                              context,
                              ref.read(flavorProvider).isParapharmacy
                                  ? 'Galenic_prepration_des_parapharmacy'
                                  : 'Galenic_prepration_des_pharmacy'),
                          image: 'assets/icons/galenicpreparation.svg',
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(GalenicPreparationScreen.routeName);
                          },
                        ),
                      if (flavor.hasGlutenFree)
                        const SizedBox(
                          height: 8,
                        ),
                      if (flavor.hasGlutenFree)
                        ItemTileSVGWithBackground(
                          title: translate(context, 'Gluten_product'),
                          text: translate(context, 'Gluten_product_des'),
                          image: 'assets/icons/glutenfree.svg',
                          color: const Color(0xFFF4B961),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(GlutenFreeProductsScreen.routeName);
                          },
                        ),
                      if (flavor.hasMomChild)
                        const SizedBox(
                          height: 8,
                        ),
                      if (flavor.hasMomChild)
                        ItemTileIconWithBackground(
                          title: translate(context, 'momchild'),
                          color: const Color(0xFF83CDF1),
                          text: translate(context, 'momchild_des'),
                          image: Icons.child_friendly,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MomAndBabyScreen.routeName);
                          },
                        ),
                      if (flavor.hasVeterinary)
                        const SizedBox(
                          height: 8,
                        ),
                      if (flavor.hasVeterinary)
                        ItemTileIconWithBackground(
                          title: translate(
                              context, 'offers_veterinary_department'),
                          text: translate(context,
                              'offers_veterinary_department_description'),
                          image: Icons.pets,
                          color: const Color(0xFFEB59BC),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(VetOffersScreen.routeName);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartIconWithBadge extends ConsumerWidget {
  const CartIconWithBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartSize = ref.watch(cartProvider).size;
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: -8),
      badgeColor: ref.read(flavorProvider).lightPrimary,
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.fade,
      badgeContent: Text(
        cartSize.toString(),
        style: const TextStyle(color: Colors.white),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (ref.read(authProvider).user != null) {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          } else {
            showredToast(translate(context, 'login_required'), context);
          }
        },
        child: Image.asset(
          'assets/icons/cart_blue.png',
          height: 20,
          width: 20,
          color: ref.read(flavorProvider).lightPrimary,
        ),
      ),
    );
  }
}
