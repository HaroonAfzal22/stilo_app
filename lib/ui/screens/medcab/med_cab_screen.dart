import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/medcab_item.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/screens/medcab/insert_product_medcab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/flavor.dart';
import '../../../providers/med_cab_provider.dart';
import '../../../theme/app_colors.dart';
import '../../custom_widgets/no_user.dart';

//TODO handle emptyList

class MedCabScreen extends ConsumerStatefulWidget {
  const MedCabScreen({Key? key}) : super(key: key);
  static const routeName = '/med-cab-screen';

  @override
  _MedCabScreenState createState() => _MedCabScreenState();
}

class _MedCabScreenState extends ConsumerState<MedCabScreen> {
  bool isExpired(String expirationDate) {
    if (expirationDate.isEmpty) {
      return false;
    }
    var parsedDate = DateFormat('d/M/y').parse(expirationDate);
    var today = DateTime.now();
    var startDate =
        DateTime(parsedDate.year, parsedDate.month - 1, parsedDate.day);
    return today.isAfter(startDate) && today.isBefore(parsedDate);
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider).user != null) {
      ref
          .read(medCabProvider)
          .getMedCabItems({'user_id': ref.read(authProvider).user?.userId});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final list = ref.watch(medCabProvider).items;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        backgroundColor: ref.read(flavorProvider).lightPrimary,
        onPressed: () {
          if (user != null) {
            Navigator.of(context).pushNamed(InsertProductMedCab.routeName);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Med cab',
          style: TextStyle(color: ref.read(flavorProvider).primary),
        ),
      ),
      body: ref.read(authProvider).user != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  if (list != null && list.isNotEmpty && user != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              MedCabItemListTile(medCabItem: list[index]),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 16,
                              ),
                          itemCount: list.length),
                    )
                  else if (list != null && list.isEmpty)
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2 - 100),
                      child: const NoData(),
                    ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )
          : const NoUser(),
    );
  }
}
