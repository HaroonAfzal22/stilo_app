import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/medcab_item.dart';

class MedCabExpiringTab extends ConsumerStatefulWidget {
  const MedCabExpiringTab({Key? key}) : super(key: key);

  @override
  _MedCabExpiringTabState createState() => _MedCabExpiringTabState();
}

class _MedCabExpiringTabState extends ConsumerState<MedCabExpiringTab> {
  List<MedCabItem>? list;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (list != null && list!.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(top: 16),
                child: const Center(
                  child:
                      //TODO translate
                      Text('Non hai ancora aggiunto prodotti nel tuo MEDCAB'),
                ),
              )
            else if (user == null)
              const NoUser()
          ],
        ),
      ),
    );
  }
}
