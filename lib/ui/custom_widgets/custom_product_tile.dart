import 'dart:io';

import 'package:contacta_pharmacy/models/customProduct.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomProductTile extends ConsumerWidget {
  const CustomProductTile({
    Key? key,
    required this.customProduct,
  }) : super(key: key);
  final CustomProduct customProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        leading: Container(
            child: customProduct.uploadedPhoto != null
                ? Image.file(File(customProduct.uploadedPhoto![0].path))
                : Image.asset("assets/images/addphoto.png")),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 5),
              child: Text('Prodotto caricato da foto'),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            ref
                .read(cartProvider)
                .removeCustomProductFromCart(customProduct.id);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
