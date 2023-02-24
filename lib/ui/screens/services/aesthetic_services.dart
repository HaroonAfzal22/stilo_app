import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/services/service_app_bar.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/services/service_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/apisNew.dart';
import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/services/service_tile.dart';

class AestheticServices extends ConsumerStatefulWidget {
  const AestheticServices({Key? key}) : super(key: key);
  static const routeName = '/aesthetic-services';

  @override
  ConsumerState<AestheticServices> createState() => _AestheticServicesState();
}

class _AestheticServicesState extends ConsumerState<AestheticServices> {
  List<dynamic>? services;
  final ApisNew _apisNew = ApisNew();
  //TODO modificare endpoint senza utente
  Future<void> getAestheticServices() async {
    final result = await _apisNew.getServicesByType({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'Aesthetic Cabin',
      'sede_id': ref.read(siteProvider)!.id,
    });
    services = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAestheticServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ServiceAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ServiceHeaderSVG(
              title: translate(context, 'service_aesthetic'),
              subtitle: translate(
                  context,
                  ref.read(flavorProvider).isParapharmacy
                      ? 'service_aesthetic_des_parapharmacy'
                      : 'service_aesthetic_des_pharmacy'),
              image: 'assets/images/cabina_estetica.svg',
              color: const Color(0xFFF4B961),
            ),
            if (services != null && services!.isEmpty)
              NoData(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                text: translate(
                    context,
                    ref.read(flavorProvider).isParapharmacy
                        ? "No_Service_parapharmacy"
                        : "No_Service_pharmacy"),
              )
            else if (services != null)
              ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  itemCount: services!.length,
                  itemBuilder: (context, index) =>
                      ServiceTile(service: services![index]))
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
