import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/products/saved_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../models/product.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class CreateTherapyFirstScreen extends ConsumerStatefulWidget {
  const CreateTherapyFirstScreen({Key? key}) : super(key: key);
  static const routeName = '/create-therapy-first-screen';

  @override
  _CreateTherapyFirstScreenState createState() =>
      _CreateTherapyFirstScreenState();
}

class _CreateTherapyFirstScreenState
    extends ConsumerState<CreateTherapyFirstScreen> {
  @override
  void initState() {
    super.initState();
    searchItems();
  }

  Future<void> searchItems() async {
    final result = await _apisNew.searchAllProducts({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'normal',
      'search': _controller.text,
    });
    productList = result;
    setState(() {});
  }

  List<Product>? productList;
  final TextEditingController _controller = TextEditingController();
  final ApisNew _apisNew = ApisNew();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'Therapy_insertion'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "1/3"),
                  style: AppTheme.h6Style.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ref.read(flavorProvider).primary)),
              Text(translate(context, "Therapy_insertion"),
                  style:
                      AppTheme.h5Style.copyWith(fontWeight: FontWeight.w600)),
              Text(translate(context, "Therapy_insertion_des"),
                  style: AppTheme.bodyText
                      .copyWith(color: AppColors.lightGrey, fontSize: 10.0.sp)),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: _controller,
                  onChanged: (value) {
                    searchItems();
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.search),
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
              if (productList != null)
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/create-therapy-second-screen',
                              arguments: {
                                'product_name': productList![index].productName,
                                'product_id': productList![index].id,
                              });
                        },
                        child: SavedProductItemAsProduct(
                          product: productList![index],
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(top: 32),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
