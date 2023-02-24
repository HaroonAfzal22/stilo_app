import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/screens/cart/cart_first_tab.dart';
import 'package:contacta_pharmacy/ui/screens/cart/cart_second_tab.dart';
import 'package:contacta_pharmacy/ui/screens/cart/cart_third_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../providers/cart_provider.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/cart/cart_bottom_sheet.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final ApisNew _apisNew = ApisNew();

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

  Future<Response> placeOder(CartProvider cart) async {
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
        "sub_total": ref.read(cartProvider).getTotalAmount().toStringAsFixed(2),
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
    return result;
  }

  Future<dynamic> getOrderById(String id) async {
    final result = await _apisNew.getOrderById({'order_id': id});
  }

  int step = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fromStep = ModalRoute.of(context)!.settings.arguments as int?;
      if (fromStep != null) {
        step = fromStep;
        setState(() {});
      }
    });
  }

  bool receiptEnabled(Flavor flavor) {
    return flavor.sendReceiptEnabled && !flavor.isParapharmacy;
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final flavor = ref.watch(flavorProvider);
    return Scaffold(
      persistentFooterButtons: step == 2
          ? null
          : [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ref.read(flavorProvider).lightPrimary),
                    ),
                    child: Text(
                      step == (receiptEnabled(flavor) ? 2 : 1)
                          ? translate(context, 'complate_order')
                          : translate(context, 'continue'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    onPressed: () async {
                      if (step == (receiptEnabled(flavor) ? 2 : 1)) {
                        if (ref.read(authProvider).user != null) {
                          if (cart.prescriptions.isEmpty &&
                              cart.customProducts.isEmpty &&
                              cart.cart.isEmpty) {
                            Navigator.pop(context);
                            showredToast('Il tuo carrello è vuoto', context);
                          } else {
                            final Response result = await placeOder(cart);
                            if (result.statusCode == 200) {
                              openSuccessModal(result.data['ordine_id'] ?? 0);
                              cart.emptyCart();
                            }
                          }
                        } else {
                          showredToast(
                              translate(context, 'login_required'), context);
                          setState(() {
                            step = -1;
                          });
                        }
                      }
                      setState(() {
                        step++;
                      });
                    }),
              )
            ],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          translate(context, 'cart'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            color: ref.read(flavorProvider).primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (step == 0)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: ref.read(flavorProvider).primary,
                        ),
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                const SizedBox(
                  width: 2,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (step != 0) step = 0;
                    });
                  },
                  child: Text(
                    translate(context, 'cart'),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            step == 0 ? FontWeight.w900 : FontWeight.normal),
                  ),
                ),
                if (receiptEnabled(flavor))
                  const SizedBox(
                    width: 8,
                  ),
                if (receiptEnabled(flavor))
                  const Icon(Icons.arrow_forward, color: Colors.white),
                if (receiptEnabled(flavor))
                  const SizedBox(
                    width: 8,
                  ),
                if (receiptEnabled(flavor))
                  if (step > 1)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    )
                  else
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: ref.read(flavorProvider).primary,
                          ),
                        ),
                      ),
                    ),
                if (receiptEnabled(flavor))
                  const SizedBox(
                    width: 2,
                  ),
                if (receiptEnabled(flavor))
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (step != 1) step = 1;
                      });
                    },
                    child: Text(
                      translate(context, 'recipe'),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              step == 1 ? FontWeight.w900 : FontWeight.normal),
                    ),
                  ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(Icons.arrow_forward, color: Colors.white),
                const SizedBox(
                  width: 8,
                ),
                //TODO logica???
                /*       if (step == 2)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  )
                else*/
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      receiptEnabled(flavor) ? '3' : '2',
                      style: TextStyle(
                        color: ref.read(flavorProvider).primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (receiptEnabled(flavor)) {
                        if (step != 2) step = 2;
                      } else {
                        if (step != 1) step = 1;
                      }
                    });
                  },
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            step == 2 ? FontWeight.w900 : FontWeight.normal),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: IndexedStack(
              index: step,
              children: [
                const CartFirstTab(),
                if (receiptEnabled(flavor)) const CartSecondTab(),
                const CartThirdTab(),
                //TODO bugFix for showModal
                const SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
