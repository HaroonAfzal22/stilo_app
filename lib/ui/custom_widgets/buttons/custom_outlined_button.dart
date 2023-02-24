import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';

class CustomOutlinedButton extends ConsumerWidget {
  const CustomOutlinedButton(
      {Key? key, required this.text, required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      color: ref.read(flavorProvider).primary,
      onPressed: onTap,
      elevation: 0,
      minWidth: 70.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: Colors.white,
        ),
      ),
      textColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 1.5),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
