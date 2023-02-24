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

class Covid19Services extends ConsumerStatefulWidget {
  const Covid19Services({Key? key}) : super(key: key);
  static const routeName = '/covid19-services';

  @override
  ConsumerState<Covid19Services> createState() => _Covid19ServicesState();
}

class _Covid19ServicesState extends ConsumerState<Covid19Services> {
  final ApisNew _apisNew = ApisNew();
  List<dynamic>? services;

  Future<void> getCovid19Services() async {
    final result = await _apisNew.getServicesByType({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'Covid-19 Tests and Vaccin',
      'sede_id': ref.read(siteProvider)!.id,
    });
    services = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCovid19Services();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ServiceAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ServiceHeader(
              title: translate(context, 'service_covid'),
              subtitle: translate(context, 'service_covid_des'),
              icon: Icons.coronavirus,
              color: const Color(0xFFEF7F5E),
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
                  itemBuilder: (context, index) =>
                      ServiceTile(service: services![index]))
            else
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  )),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
