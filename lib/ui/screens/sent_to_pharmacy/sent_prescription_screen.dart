import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescription_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../custom_widgets/no_data.dart';

class SentPrescriptionTab extends ConsumerStatefulWidget {
  const SentPrescriptionTab({Key? key}) : super(key: key);

  @override
  ConsumerState<SentPrescriptionTab> createState() =>
      _SentPrescriptionTabState();
}

class _SentPrescriptionTabState extends ConsumerState<SentPrescriptionTab> {
  List<dynamic>? prescriptions;
  final ApisNew _apisNew = ApisNew();

  Future<void> getAllPrescriptions() async {
    final result = await _apisNew.getAllPrescriptions({
      'user_id': ref.read(authProvider).user?.userId,
    });
    prescriptions = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider).user != null) {
      getAllPrescriptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          if (prescriptions != null && prescriptions!.isNotEmpty)
            ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              PrescriptionDetailScreen.routeName,
                              arguments: prescriptions![index]);
                        },
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        title: Text('Caricata il ' +
                            prescriptions![index]['created_date']
                                .substring(0, 10)),
                        leading: Image.asset('assets/images/noImage.png'),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: prescriptions!.length)
          else if (prescriptions != null && prescriptions!.isEmpty)
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              child: const NoData(),
            )
          else
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              child: Center(
                child: CircularProgressIndicator(
                  color: ref.read(flavorProvider).lightPrimary,
                ),
              ),
            ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
