import 'dart:io';

import 'package:contacta_pharmacy/models/galenicPreparation.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalenicPreparationTile extends ConsumerWidget {
  const GalenicPreparationTile({Key? key, required this.galenicPreparation})
      : super(key: key);

  final GalenicPreparation galenicPreparation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: ListTile(
        leading: SizedBox(
          child: galenicPreparation.uploadedPhoto != null
              ? Image.file(File(galenicPreparation.uploadedPhoto!.path))
              : Image.asset("assets/images/ic_galenic_preparation.png"),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text("Preparazione Galenica"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(translate(context, "uploaded_image")),
            )
          ],
        ),
        trailing: IconButton(
          onPressed: () {
/*            ref
                .read(cartProvider)
                .removeGalenicPreparationFromCart(galenicPreparation.id);*/
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

// assets/images/ic_galenic_preparation.png
