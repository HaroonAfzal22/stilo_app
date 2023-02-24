import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/prescriptions/pharma_header.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_category_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class ProductCategoriesScreen extends ConsumerStatefulWidget {
  const ProductCategoriesScreen({Key? key}) : super(key: key);
  static const routeName = '/product-categories-screen';

  @override
  ConsumerState<ProductCategoriesScreen> createState() =>
      _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState
    extends ConsumerState<ProductCategoriesScreen> {
  final TextEditingController _controller = TextEditingController();
  //List<ProductCategory>? categories;
  List<dynamic>? categories;
  final ApisNew _apis = ApisNew();

  Future<void> getCategories() async {
    final result = await _apis.fetchSubCategories();
    if (result.data != null) {
      //var prodCat = ProductCategoryResponse.fromJson(result.data[0]);
      //print(prodCat);
      setState(() {
        categories = result.data;
      });
    } else {
      categories = [];
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          translate(context, 'product_category'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PharmaHeader(
                    title: translate(context, 'choose_category'),
                    subtitle: translate(context, 'category_des'),
                    imgUrl: 'assets/images/Product_categoriesimg.png',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (categories == null)
                    Center(
                        child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ))
                  else
                    ...List.generate(
                      categories != null ? categories!.length : 0,
                      (index) => CategoryExpandableItem(
                        category: categories![index],
                        color: index % 2 == 0
                            ? AppColors.productBgColor
                            : AppColors.purple,
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryExpandableItem extends StatefulWidget {
  const CategoryExpandableItem(
      {Key? key, required this.category, required this.color})
      : super(key: key);

  final dynamic category;
  final Color color;

  @override
  State<CategoryExpandableItem> createState() => _CategoryExpandableItemState();
}

class _CategoryExpandableItemState extends State<CategoryExpandableItem> {
  Future<void> openDialog() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, StateSetter setState) {
        return Dialog(
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // TODO: Add img property on BE side
                      // CachedNetworkImage(
                      //   width: 24,
                      //   height: 24,
                      //   imageUrl: widget.category['img'],
                      // ),
                      const SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          widget.category['category_name_en'] ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //TODO add scropri tutti e funzione onTAP
                  ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.category['subcategories'] != null
                        ? widget.category['subcategories'].length
                        : 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                            ProductCategoryDetail.routeName,
                            arguments: {
                              'subcategory': widget.category['subcategories']
                                  [index],
                              'category': widget.category['id'],
                              'product_gmp_category':
                                  widget.category['subcategories'][index]
                                      ['productGmpCategory']
                              //  'product_gmp_category': "4AA2F99"
                            });
                      },
                      child: Text(
                        widget.category['subcategories'][index]['title'] ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TODO: Add img property on BE side
            // if (widget.category['img'] != null)
            //   CachedNetworkImage(
            //     imageUrl: widget.category['img'],
            //     errorWidget: (context, url, error) => const SizedBox(),
            //     width: 24,
            //     height: 24,
            //   ),
            Flexible(
              child: Text(
                widget.category['category_name_en'] ?? "",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
