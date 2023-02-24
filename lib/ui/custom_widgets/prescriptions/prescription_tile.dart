import 'dart:io';

import 'package:contacta_pharmacy/models/prescription.dart';
import 'package:contacta_pharmacy/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionTile extends ConsumerWidget {
  const PrescriptionTile({Key? key, required this.prescription})
      : super(key: key);

  final Prescription prescription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: ListTile(
        leading: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: prescription.uploadedPhoto != null
              ? Image.file(File(prescription.uploadedPhoto!.path))
              : Image.asset("assets/images/recipeicon.png"),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: prescription.uploadedPhoto != null
                  ? const Text("Ricetta da foto")
                  : const Text("Ricetta elettronica"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(prescription.cadicoTax ?? ''),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            ref.read(cartProvider).removePrescriptionFromCart(prescription.id);
          },
        ),
      ),
    );
  }
}
