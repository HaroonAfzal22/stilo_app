import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/screens/cart/stilo_webview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../models/flavor.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/site_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/cart/cart_bottom_sheet.dart';

class CartThirdTab extends ConsumerStatefulWidget {
  const CartThirdTab({Key? key}) : super(key: key);

  @override
  ConsumerState<CartThirdTab> createState() => _CartThirdTabState();
}

class _CartThirdTabState extends ConsumerState<CartThirdTab> {
  //TODO convert to enum
  String pickupType = 'home';
  final ApisNew _apisNew = ApisNew();

  // Future<void> placeOder(dynamic cart) async {
  //   final result = await _apisNew.placeOrder(
  //     {
  //       "user_device_id": "37e855a549b4f321",
  //       "pharmacy_id": ref.read(flavorProvider).pharmacyId,
  //       "coupon_id": "",
  //       "coupon_total": "0.0",
  //       "total": '',
  //       "tax": "2.0",
  //       "sub_total": "20.0",
  //       "promo_code": "",
  //       "address": "",
  //       "address_type": "",
  //       "type": "pharmacy",
  //       "notes": "",
  //       "transction_id": "",
  //       "status": "pending",
  //       "payment_type": "Pick at Pharmacy",
  //       "products": [
  //         {"product_id": 5, "quantity": 1, "price": 20.0}
  //       ],
  //       "recipe": [],
  //       "user_products": [],
  //       "card_no": ""
  //     },
  //   );
  // }

  Future<void> openSuccessModal(int orderId) async {
    await showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) => CartBottomSheet(
        orderId: orderId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   translate(context, "shipping_method"),
            //   style: AppTheme.h5Style.copyWith(fontWeight: FontWeight.w600),
            // ),
            // Text(translate(context, "shipping_method_des"),
            //     style: AppTheme.bodyText),
            // const SizedBox(
            //   height: 16,
            // ),
            //TODO estrarre
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {},
            //         child: Container(
            //           height: 6.0.h,
            //           decoration: BoxDecoration(
            //               color: ref.read(flavorProvider).primary,
            //               borderRadius: BorderRadius.circular(2),
            //               border: Border.all(
            //                   color: pickupType == "pharmacy"
            //                       ? ref.read(flavorProvider).primary
            //                       : AppColors.grey)),
            //           child: Center(
            //             child: Text(
            //               translate(
            //                   context,
            //                   ref.read(flavorProvider).isParapharmacy
            //                       ? "pick_parapharmacy"
            //                       : "pick_pharmacy"),
            //               style: AppTheme.bodyText.copyWith(
            //                   fontSize: 11.0.sp, color: AppColors.white),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     /*      Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           showModalBottomSheet(
            //             isDismissible: true,
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.only(
            //                 topRight: Radius.circular(20),
            //                 topLeft: Radius.circular(20),
            //               ),
            //             ),
            //             context: context,
            //             builder: (context) => const BottomSheetAddresses(),
            //           );
            //         },
            //         child: Container(
            //           height: 6.0.h,
            //           decoration: BoxDecoration(
            //             color: pickupType == "home"
            //                 ? ref.read(flavorProvider).primary
            //                 : Colors.white,
            //             border: Border.all(
            //               color: pickupType == "home"
            //                   ? ref.read(flavorProvider).primary
            //                   : AppColors.lightGrey,
            //             ),
            //             borderRadius: BorderRadius.circular(2),
            //           ),
            //           child: Center(
            //             child: Text(translate(context, "deliver_home"),
            //                 style: AppTheme.bodyText.copyWith(
            //                     color: pickupType == "home"
            //                         ? AppColors.white
            //                         : AppColors.lightGrey)),
            //           ),
            //         ),
            //       ),
            //     ),*/
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // const Divider(),
            const SizedBox(
              height: 16,
            ),
            Text(translate(context, 'add_notes')),
            const SizedBox(
              height: 4,
            ),
            TextField(
              decoration: Constant.borderTextFieldDecoration(
                      ref.read(flavorProvider).lightPrimary)
                  .copyWith(
                      hintText: translate(
                        context,
                        ref.read(flavorProvider).isParapharmacy
                            ? 'add_notes_des_parapharmacy'
                            : 'add_notes_des_pharmacy',
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8)),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              translate(
                context,
                'summary',
              ),
              style: AppTheme.h5Style.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       translate(context, 'cart_total'),
            //       style: AppTheme.bodyText,
            //     ),
            //     Text(
            //       NumberFormat.currency(locale: 'it_IT', symbol: '€')
            //           .format(ref.watch(cartProvider).getTotalAmount()),
            //       style:
            //           AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       translate(context, 'vat_gst'),
            //       style: AppTheme.bodyText,
            //     ),
            //     Text(
            //       '€ 0,00',
            //       style: AppTheme.bodyText,
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 8,
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, 'Total'),
                  style: AppTheme.bodyText.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  NumberFormat.currency(locale: 'it_IT', symbol: '€')
                      .format(ref.watch(cartProvider).getTotalAmount()),
                  style:
                      AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 64),

            ElevatedButton(
              onPressed: () async {
                if (cart.prescriptions.isEmpty &&
                    cart.customProducts.isEmpty &&
                    cart.cart.isEmpty) {
                  Navigator.pop(context);
                  showredToast('Il tuo carrello è vuoto', context);
                  return;
                }
                EasyLoading.show(status: 'Caricamento');
                EasyLoading.instance.userInteractions = false;

                final result = await _apisNew.createOrder(
                  {
                    "user_id": ref.read(authProvider).user!.userId.toString(),
                    "user_device_id": "37e855a549b4f321",
                    "pharmacy_id": ref.read(flavorProvider).pharmacyId,
                    "coupon_id": "",
                    "access_token":
                        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDE0NjgxMzYyNWNiZDQzZmZhMzdlYTE3YjZkMDU1ZGVkZjFmYTMxZjU2M2YyOTdmOTNmYTAyOTdmM2YzYjhlNDY0ZTY0NDE4NDYzYTU5NmQiLCJpYXQiOjE2NDk5Mjc2ODIsIm5iZiI6MTY0OTkyNzY4MiwiZXhwIjoxNjgxNDYzNjgyLCJzdWIiOiIxMzk0Iiwic2NvcGVzIjpbXX0.s4E8kA5jR-nmw3QIlcwXrAyCgUSKVGJr8OBO6qZS3i6S2gRPYsBcev6Xdem5CnEsAQ-7HsWldk_fE0Xost27EmZIckfJpNC2Nbd54PJ8qonztoM4bPp0kuEazDPDbLp5J590No-CCIjqwCM5PxyRcn2qRvs9bjkm2rBW1Fyl1a7VSLGD_ovzXt1q-BdakXLrq8o6GJusDpmtLd3RRnfKQOK5dAwa5X8jx62Bvw9eJCpv4SMxWtpYNnlvnUWWbS0ARmxjcv95Kh1yfk3vwdb1laBTAWuwoEpusxHJND4tpqhrdD9Myh-6JINt-YCyN4Ys0WWcxwmAHZalhwQ3z7kTZAOnmetlaOYzkAKhcIzXyuklNifOV_N57jPiTH-ngnSBrzWEyoObpF-F2qEw5b0cfu_XZv5U3N-JkvKdsT4yF6SZW_WpGupmkvv5Ke_AAIMmHTeyhHueJKqrzvYEj13n96mMIHR0U4hGDLAVjsUvHyYrZFS5AOgxMIQswkK7IFFBXPs5UpbjOtm_9rGQMIC6t6luZZL1MhnNpvC7JkfL6gJQ_OGwGNDeHOTD57vgceoTef2Ph5YUrbJs0bgQcImMgGNmDiGLD-gH4U6We3s0iRd5gc1hE8bi_IKpYOSArIBlyyh5ccZl81S73wCufVAC5rRE_IIjoxptH0WA2ubYixA",
                    "coupon_total": "0.0",
                    "total": '',
                    "tax": "0.0",
                    "sub_total": ref
                        .read(cartProvider)
                        .getTotalAmount()
                        .toStringAsFixed(2),
                    "promo_code": "",
                    "address": "",
                    "address_type": "",
                    "type": "pharmacy",
                    "notes": "",
                    "transction_id": "",
                    "status": "pending",
                    "payment_type": "Pick at Pharmacy",
                    "products": cart.convertListForOrder(),
                    "recipe": cart.convertPrescriptionsForOrder(),
                    "user_products": cart.convertCustomProductsForOrder(),
                    "card_no": "",
                    "sede_id": ref.read(siteProvider)!.id,
                  },
                );
                EasyLoading.dismiss();

                if (result.statusCode == 200) {
                  openSuccessModal(result.data['ordine_id'] ?? 0);
                  cart.emptyCart();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ref.read(flavorProvider).lightPrimary,
                padding: const EdgeInsets.all(12),
              ),
              child: const Text("Ritira in farmacia"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                EasyLoading.show(status: 'Caricamento');
                EasyLoading.instance.userInteractions = false;
                try {
                  for (var c in cart.cart) {
                    for (var i = 0; i < c.quantity; i++) {
                      final result = await _apisNew.addToCart({
                        'user_id': ref.read(authProvider).user!.wpId,
                        'product_id': c.item.id,
                      });
                    }
                  }

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const StiloWebView(),
                  ));
                } catch (e) {
                  showredToast(
                      "Uno o più prodotti non sono disponibili sull'e-commerce",
                      context);

                  for (var c in cart.cart) {
                    for (var i = 0; i < c.quantity; i++) {
                      final result = await _apisNew.removeToCart({
                        'user_id': ref.read(authProvider).user!.wpId,
                        'product_id': c.item.id,
                      });
                    }
                  }
                } finally {
                  EasyLoading.dismiss();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: ref.read(flavorProvider).lightPrimary,
                  padding: const EdgeInsets.all(12)),
              child: const Text("Acquista su e-commerce"),
            ),
          ],
        ),
      ),
    );
  }
}
