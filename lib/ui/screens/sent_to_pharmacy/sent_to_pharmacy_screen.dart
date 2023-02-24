import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_galenic_tab.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_prescription_screen.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_product_from_photo_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class SentToPharmacyScreen extends ConsumerStatefulWidget {
  const SentToPharmacyScreen({Key? key}) : super(key: key);
  static const routeName = '/sent-to-pharmacy-screen';

  @override
  _SentToPharmacyScreenState createState() => _SentToPharmacyScreenState();
}

class _SentToPharmacyScreenState extends ConsumerState<SentToPharmacyScreen> {
  int getTabsNumber(Flavor flavor) {
    int i = 1;
    if (flavor.sendReceiptEnabled && !flavor.isParapharmacy) i++;
    if (flavor.hasGalenic) i++;

    return i;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final flavor = ref.read(flavorProvider);
    return DefaultTabController(
      length: getTabsNumber(flavor),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            translate(
                context,
                ref.read(flavorProvider).isParapharmacy
                    ? 'sent_to_parapharmacy'
                    : 'sent_to_pharmacy'),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelPadding: const EdgeInsets.symmetric(vertical: 8),
            labelColor: ref.read(flavorProvider).primary,
            unselectedLabelColor: AppColors.darkGrey,
            indicatorColor: ref.read(flavorProvider).primary,
            tabs: [
              if (flavor.hasGalenic)
                Text(translate(context, 'galenic_preparation_short')),
              if (flavor.sendReceiptEnabled && !flavor.isParapharmacy)
                Text(
                  translate(context, 'recipe'),
                ),
              Text(
                translate(context, 'product_by_photo'),
              ),
            ],
          ),
        ),
        body: user == null
            ? const NoUser()
            : TabBarView(
                children: [
                  if (flavor.hasGalenic) const SentGalenicTab(),
                  if (flavor.sendReceiptEnabled && !flavor.isParapharmacy)
                    const SentPrescriptionTab(),
                  const SentProductFromPhotoTab(),
                ],
              ),
      ),
    );
  }
}
