import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:contacta_pharmacy/ui/screens/orders/order_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';

class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({
    Key? key,
    required this.orderId,
  }) : super(key: key);
  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.85,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 20.0.h,
              width: 50.0.w,
              child: Image.asset(ic_successorder),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              translate(context, "thankyou"),
              textAlign: TextAlign.center,
              style: AppTheme.titleStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '',
                  style: AppTheme.bodyText.copyWith(
                      fontSize: 10.0.sp, color: AppColors.orderTextColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: translate(context, "success_des"),
                      style: AppTheme.bodyText.copyWith(
                          fontSize: 10.0.sp, color: AppColors.orderTextColor),
                    ),
                    TextSpan(
                      text: "${translate(context, "order_no")} $orderId ",
                      style: AppTheme.bodyText.copyWith(
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orderTextColor),
                    ),
                    TextSpan(
                      text: translate(context, "success_des2"),
                      style: AppTheme.bodyText.copyWith(
                          fontSize: 10.0.sp, color: AppColors.orderTextColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ProductCategoriesScreen.routeName);
              },
              child: Container(
                height: 6.0.h,
                width: 70.0.w,
                decoration: BoxDecoration(
                  color: ref.read(flavorProvider).primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(translate(context, "return_product_page"),
                      style: AppTheme.h6Style
                          .copyWith(color: AppColors.white, fontSize: 12.0.sp)),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(OrderDetailScreen.routeName, arguments: orderId);
              },
              child: Container(
                height: 6.0.h,
                width: 70.0.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ref.read(flavorProvider).primary,
                  ),
                  //
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(translate(context, "go_to_order_detail"),
                      textAlign: TextAlign.center,
                      style: AppTheme.h6Style.copyWith(
                          color: ref.read(flavorProvider).primary,
                          fontSize: 12.0.sp)),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MainScreen.routeName, (route) => false);
              },
              child: Text(
                translate(context, "go_to_home"),
                textAlign: TextAlign.center,
                style: AppTheme.h6Style.copyWith(color: AppColors.lightGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
