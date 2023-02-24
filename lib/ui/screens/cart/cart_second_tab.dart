import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/pharma_header.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/prescription_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/cart_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/bottom_sheets/bottom_sheet_prescription.dart';

class CartSecondTab extends ConsumerStatefulWidget {
  const CartSecondTab({Key? key}) : super(key: key);

  @override
  ConsumerState<CartSecondTab> createState() => _CartSecondTabState();
}

class _CartSecondTabState extends ConsumerState<CartSecondTab> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            PharmaHeader(
                title: translate(context, 'the_recipe'),
                subtitle: translate(context, 'the_recipe_des'),
                imgUrl: 'assets/images/addrecipt.png'),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  translate(context, 'the_recipe_loaded'),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(' (' + cart.prescriptions.length.toString() + ') '),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    PrescriptionTile(prescription: cart.prescriptions[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: cart.prescriptions.length),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) =>
                        const PrescriptionBottomSheet(cart: true),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: AppColors.purple,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/addrecipt.png', width: 64),
                      Text(
                        translate(context, 'insert_recipe'),
                        style: AppTheme.h6Style.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0.sp),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
