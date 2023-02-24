import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/send_med_prescription.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/send_vet_prescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

enum PrescriptionMode { med, vet }

extension PrescriptionType on PrescriptionMode {
  String get label {
    switch (this) {
      case PrescriptionMode.med:
        return "ricetta_medica";
      case PrescriptionMode.vet:
        return "ricetta_veterinaria";
    }
  }
}

class PrescriptionBottomSheet extends ConsumerWidget {
  final bool cart;
  final PrescriptionMode? mode;
  const PrescriptionBottomSheet({this.mode, this.cart = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                size: 32,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            translate(context, 'choose_reciet_type'),
            style: AppTheme.bodyText.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 17.0.sp,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            translate(context, 'select_reciet_type'),
            maxLines: 2,
            style: AppTheme.bodyText.copyWith(fontSize: 12.0.sp),
          ),
          const SizedBox(
            height: 32,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              //Navigator.of(context).pushNamed(SendMedPrescription.routeName );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SendMedPrescription(
                    layoutType: "med",
                    cartEnabled: cart,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset('assets/images/addrecipt.png'),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          translate(
                            context,
                            ref.read(flavorProvider).isParapharmacy
                                ? 'send_medical_recipe_parapharmacy'
                                : 'send_medical_recipe_pharmacy',
                          ),
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      const Expanded(
                        flex: 3,
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black54,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 24,
          ),
          if (ref.read(flavorProvider).hasVeterinary)
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SendVetPrescription(
                          layoutType: "vet",
                          cartEnabled: cart,
                        )));
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/addrecipt2.png'),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Text(
                            translate(
                                context,
                                ref.read(flavorProvider).isParapharmacy
                                    ? 'submit_veterinary_recipe_parapharmacy'
                                    : 'submit_veterinary_recipe_pharmacy'),
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                        const Spacer(),
                        const Expanded(
                          flex: 3,
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.black54,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
