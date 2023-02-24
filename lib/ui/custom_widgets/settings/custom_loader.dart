import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';

class CustomLoader extends ConsumerWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if(Platform.isIOS){
    //   changeStatusWhiteColor(ref.read(flavorProvider).primary);
    // }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.centerRight,
                colors: [
              ref.read(flavorProvider).primary,
              ref.read(flavorProvider).lightPrimary
            ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.scaffoldBackground),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(translate(context, "Loading"))
            ],
          ),
        ),
      ),
    );
  }
}
