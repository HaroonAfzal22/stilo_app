import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class ProductFromPhotoDetailScreen extends StatefulWidget {
  const ProductFromPhotoDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-from-photo-detail-screen';

  @override
  State<ProductFromPhotoDetailScreen> createState() =>
      _ProductFromPhotoDetailScreenState();
}

class _ProductFromPhotoDetailScreenState
    extends State<ProductFromPhotoDetailScreen> {
  dynamic product;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      product = ModalRoute.of(context)!.settings.arguments as dynamic;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio'),
      ),
      body: product != null
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: product['images'] == null
                          ? Image.asset(
                              'assets/images/noImage.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              product['images'],
                              fit: BoxFit.cover,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14, left: 0, right: 10, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: AppColors.blueColor.withOpacity(0.85),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 40),
                          child: Text(
                            translate(context, "Prod. da foto"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (product['created_date'] != null)
                      Text(
                        'Caricata il : ${DateFormat("dd MMMM yyyy HH:mm:ss", 'it').format(DateFormat(
                          "yyyy-MM-dd HH:mm:ss",
                        ).parse(product!['created_date']))}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 52, 52, 52),
                            fontWeight: FontWeight.w400,
                            fontSize: 17),
                      ),
                    if (product['notes'] != null)
                      Text('Note: ${product['notes']}'),
                    if (product['client_notes'] != null)
                      Text('Note: ${product['client_notes']}')
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
