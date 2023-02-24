import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../config/MyApplication.dart';
import '../../../config/permissionConfig.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';
import '../../../utils/pharma32.dart';
import '../../screens/products/product_search_from_barcode.dart';

class BottomSheetInstructionScanner extends ConsumerStatefulWidget {
  const BottomSheetInstructionScanner({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomSheetInstructionScanner> createState() =>
      _BottomSheetInstructionScannerState();
}

class _BottomSheetInstructionScannerState
    extends ConsumerState<BottomSheetInstructionScanner> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 0, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        ic_cancel,
                        height: 20,
                        width: 20,
                        color: AppColors.darkGrey,
                      )),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate(context, "barcode_info_title"),
                    style: AppTheme.titleStyle.copyWith(
                        fontSize: 16.0.sp, fontWeight: FontWeight.bold)),
                Text(translate(context, "barcode_info_des"),
                    style: AppTheme.h3Style.copyWith(
                        color: AppColors.darkGrey.withOpacity(.7),
                        fontSize: 10.0.sp))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(("Step 1"),
                    style:
                        AppTheme.h1Style(ref.read(flavorProvider).lightPrimary)
                            .copyWith(fontSize: 12.0.sp)),
                const SizedBox(
                  height: 5,
                ),
                Text(translate(context, "barcode_step_one_info"),
                    style: AppTheme.h6Style)
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black54)),
              child: Image.asset('assets/images/barcode_info.jpeg'),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(("Step 2"),
                    style:
                        AppTheme.h1Style(ref.read(flavorProvider).lightPrimary)
                            .copyWith(fontSize: 12.0.sp)),
                const SizedBox(
                  height: 5,
                ),
                Text(translate(context, "barcode_step_two_info"),
                    style: AppTheme.h6Style)
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
              ),
              child: Image.asset('assets/images/barcode_info_cover.jpeg'),
            ),
            const SizedBox(height: 20),
            StandardButton(
                onTap: () async {
                  var code = await scanBarcode();
                  if (code == null) {
                    showredToast(
                        translate(context, "permission_denied"), context);
                  } else if (code != "-1" && code != "01") {
                    Navigator.of(context).pushNamed(
                        ProductsSearchFromBarcode.routeName,
                        arguments: code);
                  }
                },
                text: "Ok, ho capito"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<String?> scanBarcode() async {
    String? barcodeScanRes;
    var isAuthorized = await PermissionConfig.getPermission();
    if (isAuthorized) {
      String initialRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      barcodeScanRes = pharma32Convert(initialRes);
      if (!mounted) return null;
    }
    return barcodeScanRes;
  }
}
