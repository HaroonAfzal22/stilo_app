import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

//TODO aggiungere inkwell ontap - e title

class FirstOptionButton extends ConsumerWidget {
  const FirstOptionButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(color: ref.read(flavorProvider).lightPrimary),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              color: ref.read(flavorProvider).lightPrimary),
          child: Center(
            //TODO tradurre
            child: Text(
              ref.read(flavorProvider).isParapharmacy
                  ? 'Invia a Parafarmacia'
                  : 'Invia a Farmacia',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondOptionButton extends ConsumerWidget {
  const SecondOptionButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: ref.read(flavorProvider).lightPrimary,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              translate(context, 'add_to_cart'),
              style: const TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
