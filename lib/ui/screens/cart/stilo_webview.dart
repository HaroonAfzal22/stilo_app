import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../models/flavor.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/site_provider.dart';
import '../../custom_widgets/cart/cart_bottom_sheet.dart';

class StiloWebView extends ConsumerWidget {
  const StiloWebView({Key? key}) : super(key: key);

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        print('page body: $pageBody');
      },
    );
  }

  Future<void> openSuccessModal(BuildContext context, int orderId) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    WebViewController? _controller;

    return Scaffold(
      appBar: AppBar(title: const Text("Acquisto")),
      body: WebView(
        initialUrl:
            "https://stagapp.contactapharmacy.it/api/wp_auto_login/${ref.watch(authProvider).user!.wpId}/1",
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>{
          _extractDataJSChannel(context),
        },
        onPageStarted: (String url) async {
          print('Page started loading: $url');

          ApisNew _apisNew = ApisNew();

          if (url.contains("checkout/order-received")) {
            final cart = ref.watch(cartProvider);

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
                "sub_total":
                    ref.read(cartProvider).getTotalAmount().toStringAsFixed(2),
                "promo_code": "",
                "address": "",
                "address_type": "",
                "type": "pharmacy",
                "notes": "",
                "transction_id": "",
                "status": "completed",
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
              openSuccessModal(context, result.data['ordine_id'] ?? 0);
              cart.emptyCart();
            }
          }
        },
        onPageFinished: (url) {
          _controller?.runJavascript(
              "(function(){Flutter.postMessage(window.document.body.outerHTML)})();");
        },
      ),
    );
  }
}
