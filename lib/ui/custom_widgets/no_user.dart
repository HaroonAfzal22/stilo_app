import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';

class NoUser extends ConsumerWidget {
  const NoUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 32,
          ),
          Icon(
            Icons.lock_outline_rounded,
            size: 150,
            color: ref.read(flavorProvider).lightPrimary,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 270,
            ),
            child: Text(
              translate(context, 'login_to_view'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ref.read(flavorProvider).primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 130,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  PreLoginScreen.routeName, (route) => false);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 64),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: ref.read(flavorProvider).lightPrimary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  translate(context, 'go_to_login'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
