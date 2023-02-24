import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/custom_outlined_button.dart';
import 'package:contacta_pharmacy/ui/screens/coupons_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../providers/cart_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/custom_product_tile.dart';

class CartFirstTab extends ConsumerStatefulWidget {
  const CartFirstTab({Key? key}) : super(key: key);

  @override
  ConsumerState<CartFirstTab> createState() => _CartFirstTabState();
}

class _CartFirstTabState extends ConsumerState<CartFirstTab> {
  bool hide = false;
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider).cart;
    print(cart.length);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(context, 'You have') +
                        ' ' +
                        cart.length.toString() +
                        ' ' +
                        translate(context, 'items in your cart'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  CustomOutlinedButton(
                      text: hide == false
                          ? translate(context, 'collapsed')
                          : translate(context, 'expand'),
                      onTap: () {
                        setState(() {
                          hide = !hide;
                        });
                      })
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (hide == false)
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                shrinkWrap: true,
                itemCount: cart.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                              color: ref
                                  .read(flavorProvider)
                                  .lightPrimary
                                  .withOpacity(.2),
                              spreadRadius: 1,
                              blurRadius: 5)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                                alignment: Alignment.center,
                                child: cart[index].item.images.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 5, right: 5),
                                        child: Image.asset(
                                          "assets/images/noImage.png",
                                          height: 80,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 5, right: 5),
                                        child: CachedNetworkImage(
                                          imageUrl: cart[index].item.images[0]
                                              ['img'],
                                          height: 100,
                                        ))),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  right: 0, left: 10, bottom: 10, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      cart[index]
                                          .item
                                          .productName
                                          .split("|")[0],
                                      style: AppTheme.bodyText.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  cart[index].item.code == ''
                                      ? const SizedBox()
                                      : IntrinsicHeight(
                                          child: Text(
                                              'Codice: ${cart[index].item.code ?? ''}',
                                              style: AppTheme.bodyText.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[400])),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          translate(context, "quantity") +
                                              ": " +
                                              cart[index].quantity.toString(),
                                          style: AppTheme.bodyText
                                              .copyWith(fontSize: 10.0.sp)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      //TODO addQuantity
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Importo cad.',
                                            style: AppTheme.bodyText
                                                .copyWith(fontSize: 10.0.sp),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (cart[index]
                                                      .item
                                                      .promotionalPrice !=
                                                  null &&
                                              cart[index].item.isPromotional ==
                                                  'Y')
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                NumberFormat.currency(
                                                        locale: 'it_IT',
                                                        symbol: '€')
                                                    .format(cart[index]
                                                        .item
                                                        .promotionalPrice),
                                                style: AppTheme.bodyText
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                              ),
                                            )
                                          else
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                NumberFormat.currency(
                                                        locale: 'it_IT',
                                                        symbol: '€')
                                                    .format(cart[index]
                                                        .item
                                                        .productPrice),
                                                style: AppTheme.bodyText
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                ref
                                                    .watch(cartProvider)
                                                    .removeItemFromCart(
                                                        cart[index].item,
                                                        cart[index].quantity);
                                              },
                                              child: Image.asset(
                                                "assets/icons/cart_delete.png",
                                                height: 18,
                                                width: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              const SizedBox(),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${translate(context, "total_product")} :" ' ' +
                        cart.length.toString(),
                    style: AppTheme.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ref.read(flavorProvider).lightPrimary)),
                GestureDetector(
                  onTap: () {
                    ref.watch(cartProvider).emptyCart();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.darkRed,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      translate(
                        context,
                        'empty_cart',
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            if (ref.read(cartProvider).customProducts.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Text('I prodotti da foto caricati'),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(' (' +
                        ref
                            .read(cartProvider)
                            .customProducts
                            .length
                            .toString() +
                        ') '),
                  ],
                ),
              ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => CustomProductTile(
                      customProduct:
                          ref.watch(cartProvider).customProducts[index],
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: ref.watch(cartProvider).customProducts.length),

            ///GALENICHE
            /*         if (ref.read(cartProvider).galenicPreparations.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Text('Le preparazioni galeniche caricate'),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(' (' +
                        ref
                            .read(cartProvider)
                            .galenicPreparations
                            .length
                            .toString() +
                        ') '),
                  ],
                ),
              ),*/
/*            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => GalenicPreparationTile(
                    galenicPreparation:
                        ref.watch(cartProvider).galenicPreparations[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: ref.watch(cartProvider).galenicPreparations.length),*/
            if (Constant.isCouponActive == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Coupon',
                      style: AppTheme.h4Style
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(CouponsScreen.routeName);
                    },
                    child: Text(
                      translate(context, 'view_all'),
                      style: AppTheme.h6Style.copyWith(
                          color: ref.read(flavorProvider).lightPrimary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),

            if (Constant.isCouponActive == true)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 5)
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          hintText: translate(context, 'promocode'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: Colors.black,
                          height: 50,
                          child: Center(
                            child: Text(
                              translate(context, 'apply'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Text(
              translate(context, 'price_detail'),
              style: AppTheme.h4Style.copyWith(
                  color: ref.read(flavorProvider).primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, 'cart_total'),
                  style: AppTheme.bodyText,
                ),
                Text(
                  NumberFormat.currency(locale: 'it_IT', symbol: '€')
                      .format(ref.watch(cartProvider).getTotalAmount()),
                  style:
                      AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, 'vat_gst'),
                  style: AppTheme.bodyText,
                ),
                Text(
                  '€ 0,00',
                  style: AppTheme.bodyText,
                ),
              ],
            ),
            if (Constant.isCouponActive == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(context, 'coupan_discount'),
                    style: AppTheme.bodyText,
                  ),
                  Text(
                    '€ 0,00',
                    style: AppTheme.bodyText,
                  ),
                ],
              ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, 'Total') +
                      ' ' +
                      translate(context, 'order'),
                  style:
                      AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  NumberFormat.currency(locale: 'it_IT', symbol: '€')
                      .format(ref.watch(cartProvider).getTotalAmount()),
                  style:
                      AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
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
