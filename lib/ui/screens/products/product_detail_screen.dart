import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/models/productDetail.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/products/similar_product.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_photo_detail.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/scheda_prodotto.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../apis/apisNew.dart';
import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail-screen';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool favorite = false;
  int qty = 1;
  double firstSectionCurrentIndex = 0;
  double secondSectionCurrentIndex = 0;
  double thirdSectionCurrentIndex = 0;
  double fourthSectionCurrentIndex = 0;
  ProductDetail? product;
  Product? prod;
  int? productId;
  final ApisNew _apisNew = ApisNew();
  List<Map<String, dynamic>> firstSection = [];

  Future<void> getProductDetail() async {
    if (ref.read(authProvider).user != null) {
      var resp = await _apisNew.getWishList({
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
        'user_id': ref.read(authProvider).user?.userId,
      });
      List wishList = resp.data.toList();
      favorite = wishList.any((element) =>
          element['product_id'].toString() == productId.toString());
    }
    product = await _apisNew.getProductDetail({
      'product_id': productId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    if (product == null) {
      showredToast('Errore nel caricamento del prodotto', context);
      Navigator.of(context).pop();
    }
    setState(() {});
  }

  Widget loadFirstSection() {
    if (product != null && product!.firstSection.isNotEmpty) {
      return Column(children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            onPageChanged: (page) {
              setState(() {
                firstSectionCurrentIndex = page.toDouble();
              });
            },
            itemCount: product!.firstSection.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(context, product!.firstSection[index]['title']),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  //'Indicazioni terapeutiche',
                  style: AppTheme.h3Style
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 16.0.sp),
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  parseHtmlString(
                          product!.firstSection[index]['description']) ??
                      '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    DotsIndicator(
                        dotsCount: product!.firstSection.length,
                        position: firstSectionCurrentIndex),
                    IconButton(
                      onPressed: () => openBottomSheetFirst(index),
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ]);
    } else {
      return const SizedBox();
    }
  }

  Widget loadSecondSection() {
    if (product != null && product!.secondSection.isNotEmpty) {
      return Column(children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            onPageChanged: (page) {
              setState(() {
                secondSectionCurrentIndex = page.toDouble();
              });
            },
            itemCount: product!.secondSection.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(context, product!.secondSection[index]['title']),
                  //'Indicazioni terapeutiche',
                  style: AppTheme.h3Style
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 16.0.sp),
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  parseHtmlString(
                          product!.secondSection[index]['description']) ??
                      '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Center(
                      child: DotsIndicator(
                          dotsCount: product!.secondSection.length,
                          position: secondSectionCurrentIndex),
                    ),
                    IconButton(
                      onPressed: () => openBottomSheetSecond(index),
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ]);
    } else {
      return const SizedBox();
    }
  }

  Widget loadThirdSection() {
    if (product != null && product!.thirdSection.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 150,
            child: PageView.builder(
              onPageChanged: (page) {
                setState(() {
                  thirdSectionCurrentIndex = page.toDouble();
                });
              },
              itemCount: product!.thirdSection.length,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(context, product!.thirdSection[index]['title']),
                    //'Indicazioni terapeutiche',
                    style: AppTheme.h3Style.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 16.0.sp),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    parseHtmlString(
                            product!.thirdSection[index]['description']) ??
                        '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Center(
                        child: DotsIndicator(
                            dotsCount: product!.thirdSection.length,
                            position: thirdSectionCurrentIndex),
                      ),
                      IconButton(
                        onPressed: () => openBottomSheetThird(index),
                        icon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget loadFourthSection() {
    if (product != null && product!.fourthSection.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 150,
            child: PageView.builder(
              onPageChanged: (page) {
                setState(() {
                  fourthSectionCurrentIndex = page.toDouble();
                });
              },
              itemCount: product!.fourthSection.length,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(context, product!.fourthSection[index]['title']),
                    //'Indicazioni terapeutiche',
                    style: AppTheme.h3Style.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 16.0.sp),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    parseHtmlString(
                            product!.fourthSection[index]['description']) ??
                        '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => openBottomSheetFourth(index),
                        icon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
    //TODO sostituire con productDetail
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      prod = ModalRoute.of(context)?.settings.arguments as Product;
      productId = prod?.id;
      getProductDetail();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final cart = ref.watch(cartProvider);

    if (product != null) {
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                translate(context, 'product'),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              actions: const [
                CartIconWithBadge(),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.only(top: 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (product!.images.isNotEmpty) {
                            Navigator.of(context).pushNamed(
                                ProductPhotoDetail.routeName,
                                arguments: product!.images[0]['img']);
                          }
                        },
                        child: product!.images.isEmpty
                            ? Image.asset("assets/images/noImage.png")
                            : ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: CachedNetworkImage(
                                  imageUrl: product?.images[0]['img'],
                                  errorWidget: (context, url, error) =>
                                      Image.asset("assets/images/noImage.png"),
                                  /*           loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: ref.read(flavorProvider).lightPrimary,
                                      ),
                                    );
                                  },*/
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    //TODO fix
                    DotsIndicator(dotsCount: 1),
                    const SizedBox(
                      height: 16,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 24, right: 16, left: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 6,
                                blurRadius: 8,
                                color: AppColors.black.withOpacity(0.15),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product?.requiresPrescription != null &&
                                  product!.requiresPrescription == 'Y')
                                Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.darkRed,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    translate(context, 'require_prescription'),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              Text(
                                product?.productName ?? '',
                                style: AppTheme.h3Style.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0.sp),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if (product?.isPromotional == 'Y' &&
                                      product?.promotionalPrice != null)
                                    Row(
                                      children: [
                                        Text(
                                          NumberFormat.currency(
                                                  locale: 'it_IT', symbol: '€')
                                              .format(product!.productPrice),
                                          style: AppTheme.h3Style.copyWith(
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 15.0.sp,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                                  locale: 'it_IT', symbol: '€')
                                              .format(
                                                  product!.promotionalPrice),
                                          style: AppTheme.h3Style.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0.sp,
                                          ),
                                        )
                                      ],
                                    )
                                  else
                                    Text(
                                      NumberFormat.currency(
                                              locale: 'it_IT', symbol: '€')
                                          .format(product?.productPrice ?? '0'),
                                      style: AppTheme.h3Style.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0.sp,
                                      ),
                                    )
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text(
                                    translate(context, 'quantity'),
                                    style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: AppColors.darkGrey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (qty > 1) qty--;
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ref
                                                      .read(flavorProvider)
                                                      .lightPrimary, // Color
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                // Modify this till it fills the color properly
                                              ),
                                            ),
                                            const Icon(
                                              Icons.remove, // Icon
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ref
                                                  .read(flavorProvider)
                                                  .lightPrimary),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          qty.toString(),
                                          style: TextStyle(
                                            color: ref
                                                .read(flavorProvider)
                                                .lightPrimary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            qty++;
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ref
                                                      .read(flavorProvider)
                                                      .lightPrimary, // Color
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                // Modify this till it fills the color properly
                                              ),
                                            ),
                                            const Icon(
                                              Icons.add, // Icon
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(color: Colors.grey),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  showPrimaryToast(
                                      '${prod?.productName} aggiunto al carrello con successo',
                                      ref.read(flavorProvider).lightPrimary);
                                  cart.addToCart(
                                      Product(
                                          id: prod?.id,
                                          productName: prod?.productName ?? '',
                                          productCode: prod?.productCode,
                                          requiresPrescription:
                                              prod?.requiresPrescription,
                                          code: prod?.code,
                                          manufacturerTitle:
                                              prod?.manufacturerTitle,
                                          productCategoryId:
                                              prod?.productCategoryId ?? '',
                                          isPromotional: product?.isPromotional,
                                          productPriceVat:
                                              prod?.productPriceVat,
                                          productPrice: prod?.productPrice,
                                          productDisplayPrice:
                                              prod?.productDisplayPrice,
                                          inWishList: prod?.inWishList,
                                          productImage: prod?.productImage,
                                          promotionalPrice:
                                              product?.promotionalPrice),
                                      qty);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: ref
                                            .read(flavorProvider)
                                            .lightPrimary,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/cart.svg",
                                              width: 20,
                                              height: 20,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Aggiungi al carrello',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.0.sp,
                                                  color: AppColors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 8,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              if (product?.scheda != null)
                                StandardButtonLight(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          SchedaProdotto.routeName,
                                          arguments: product?.scheda);
                                    },
                                    text: 'Scheda prodotto'),
                              loadFirstSection(),
                              loadSecondSection(),
                              loadThirdSection(),
                              loadFourthSection(),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          translate(context, 'producer'),
                                          style: AppTheme.h3Style.copyWith(
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          product?.manufacturerTitle ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.h3Style.copyWith(
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          translate(context, 'code_no'),
                                          style: AppTheme.h3Style.copyWith(
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          product?.code ?? '',
                                          maxLines: 1,
                                          style: AppTheme.h3Style.copyWith(
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          translate(context, 'category'),
                                          style: AppTheme.h3Style.copyWith(
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          product?.category ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.h3Style.copyWith(
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          translate(context, 'tipo'),
                                          style: AppTheme.h3Style.copyWith(
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          product?.productTypeTitle ?? '',
                                          maxLines: 1,
                                          style: AppTheme.h3Style.copyWith(
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          translate(context, 'prescription'),
                                          style: AppTheme.h3Style.copyWith(
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          product?.productPrescriptionTypeDetails ??
                                              '',
                                          maxLines: 1,
                                          style: AppTheme.h3Style.copyWith(
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          translate(context, 'iva'),
                                          style: AppTheme.h3Style.copyWith(
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          product?.productPriceVat ?? '',
                                          maxLines: 1,
                                          style: AppTheme.h3Style.copyWith(
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider()
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 6),
                                child: Row(
                                  children: [
                                    Text(translate(context, 'similar_products'),
                                        style: TextStyle(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black))
                                  ],
                                ),
                              ),
                              if (product != null &&
                                  product!.productCategoryId != null)
                                ProductSimilarList(
                                    productSubCategory:
                                        int.parse(product!.productCategoryId!)),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        if (ref.read(authProvider).user != null)
                          Positioned(
                            right: 32,
                            top: -12,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: AbsorbPointer(
                                absorbing: user == null,
                                child: IconButton(
                                  onPressed: () {
                                    favorite = !favorite;
                                    if (favorite) {
                                      _apisNew.addToWishList({
                                        'product_id': productId,
                                        'pharmacy_id':
                                            ref.read(flavorProvider).pharmacyId,
                                        'user_id':
                                            ref.read(authProvider).user?.userId,
                                      });
                                    } else {
                                      _apisNew.removeFromWishList({
                                        'product_id': productId,
                                        'pharmacy_id':
                                            ref.read(flavorProvider).pharmacyId,
                                        'user_id':
                                            ref.read(authProvider).user?.userId,
                                      });
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: favorite ? Colors.red : Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            color: ref.read(flavorProvider).lightPrimary,
          ),
        ),
      );
    }
  }

  void openBottomSheetFirst(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(context, product!.firstSection[index]['title']),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w500,
                        color: ref.read(flavorProvider).primary),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                parseHtmlString(product!.firstSection[index]['description']) ??
                    '',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void openBottomSheetSecond(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(context, product!.secondSection[index]['title']),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w500,
                        color: ref.read(flavorProvider).primary),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                parseHtmlString(product!.secondSection[index]['description']) ??
                    '',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void openBottomSheetThird(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(context, product!.thirdSection[index]['title']),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w500,
                        color: ref.read(flavorProvider).primary),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                parseHtmlString(product!.thirdSection[index]['description']) ??
                    '',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void openBottomSheetFourth(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(context, product!.fourthSection[index]['title']),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w500,
                        color: ref.read(flavorProvider).primary),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                parseHtmlString(product!.fourthSection[index]['description']) ??
                    '',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
