import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/services/service_app_bar.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/services/service_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/apisNew.dart';
import '../../../models/flavor.dart';
import '../../../providers/site_provider.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/services/service_tile.dart';

class MedicalAnalystServices extends ConsumerStatefulWidget {
  const MedicalAnalystServices({Key? key}) : super(key: key);
  static const routeName = '/medical-analyst-services';

  @override
  ConsumerState<MedicalAnalystServices> createState() =>
      _MedicalAnalystServicesState();
}

class _MedicalAnalystServicesState
    extends ConsumerState<MedicalAnalystServices> {
  final ApisNew _apisNew = ApisNew();
  List<dynamic>? services;

  Future<void> getMedicalServices() async {
    final result = await _apisNew.getServicesByType({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'Medical analyzes and tess',
      'sede_id': ref.read(siteProvider)!.id,
    });
    services = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMedicalServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ServiceAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ServiceHeader(
              title: translate(context, 'service_medical_analyz'),
              subtitle: translate(context, 'service_medical_analyz_des'),
              icon: Icons.bloodtype,
              color: const Color(0xFF5384F6),
            ),
            if (services != null && services!.isEmpty)
              NoData(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  text: translate(
                      context,
                      ref.read(flavorProvider).isParapharmacy
                          ? "No_Service_parapharmacy"
                          : "No_Service_pharmacy"))
            else if (services != null)
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                itemCount: services!.length,
                itemBuilder: (context, index) => ServiceTile(
                  service: services![index],
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
              ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
