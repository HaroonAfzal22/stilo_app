import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/glutenFreeCategory.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/dialogs/custom_dialog.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/search_bar.dart';
import 'package:contacta_pharmacy/ui/screens/products/all_gluten_free_products.dart';
import 'package:contacta_pharmacy/ui/screens/products/search_gluten_free.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class GlutenFreeProductsScreen extends ConsumerStatefulWidget {
  const GlutenFreeProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/gluten-free-products-screen';

  @override
  _GlutenFreeProductsScreenState createState() =>
      _GlutenFreeProductsScreenState();
}

class _GlutenFreeProductsScreenState
    extends ConsumerState<GlutenFreeProductsScreen> {
  List<GlutenFreeCategory>? categories;
  final ApisNew _apisNew = ApisNew();

  final Map<String, dynamic> _controllers = {
    'budget': TextEditingController(),
    'search': TextEditingController(),
  };

  Future<void> getCategories() async {
    final result = await _apisNew.getGlutenFreeCategories(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );
    categories = [];
    for (var itemGlutenfree in result.data) {
      categories!.add(GlutenFreeCategory.fromJson(itemGlutenfree));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await getCategories());
  }

  Future<void> openEditModal() async {
    await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Seleziona Budget',
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 23),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 13),
                          SizedBox(
                            width: 120,
                            height: 30,
                            child: TextFormField(
                              autofocus: true,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              controller: _controllers['budget'],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 10, 10, 5),
                                hintText: '0',
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 13),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 4.0.h,
                                width: 20.0.w,
                                decoration: BoxDecoration(
                                  color: ref.read(flavorProvider).primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                    child: Text(
                                  translate(context, "select"),
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.white,
                                    fontSize: 10.0.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                                height: 4.0.h,
                                width: 20.0.w,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color:
                                            ref.read(flavorProvider).primary)),
                                child: Center(
                                    child: Text(
                                  translate(context, "cancel"),
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppColors.black,
                                    fontSize: 10.0.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ))),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translate(context, 'gluten_free_products'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ref.read(flavorProvider).primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  SearchBar(controller: _controllers['search']),
//TODO fix
/*
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              translate(context, "budget_total"),
                              style: AppTheme.h3Style.copyWith(
                                  fontSize: 8.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: Text(
                                _controllers['budget'].text.isEmpty
                                    ? "0.00"
                                    : _controllers['budget'].text,
                                style: AppTheme.h3Style.copyWith(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await openEditModal();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  size: 2.0.h,
                                  color: AppColors.white,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              translate(context, "in_cart"),
                              style: AppTheme.h3Style.copyWith(
                                  fontSize: 8.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                            ),
                            //todo fix
                            Text(
                              ' 0,00',
                              style: AppTheme.h3Style.copyWith(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
*/
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (categories != null)
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 2,
                  ),
                  itemCount: categories!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            SearchGlutenFree.routeName,
                            arguments: categories![index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 2, right: 2, top: 2, bottom: 2),
                        alignment: Alignment.center,
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ref
                                    .read(flavorProvider)
                                    .lightPrimary
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                //TODO le immagini sono rotte
                                /*  image: DecorationImage(
                                  image: NetworkImage(
                                      "${categories![index]['image']}"),
                                  fit: BoxFit.fill,
                                ),*/
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                // color: Colors.amber,
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 10, right: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${categories![index].title}",
                                      style: const TextStyle(
                                          color: AppColors.white),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: AppColors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  })
            else
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).primary,
                  ),
                ),
              ),
            if (categories != null)
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AllGlutenFreeProductsScreen.routeName);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ref.read(flavorProvider).primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Center(
                    child: Text(
                      'Mostra tutti',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 64,
            ),
          ],
        ),
      ),
    );
  }
}
