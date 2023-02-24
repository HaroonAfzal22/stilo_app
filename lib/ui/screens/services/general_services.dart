import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/services/service_header.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/services/service_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../providers/site_provider.dart';
import '../../../translations/translate_string.dart';

class GeneralServices extends ConsumerStatefulWidget {
  const GeneralServices({Key? key}) : super(key: key);
  static const routeName = '/general-services';

  @override
  ConsumerState<GeneralServices> createState() => _GeneralServicesState();
}

class _GeneralServicesState extends ConsumerState<GeneralServices> {
  List<dynamic>? services;
  final ApisNew _apisNew = ApisNew();

  Future<void> getGeneralServices() async {
    final result = await _apisNew.getServicesByType({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'General Services',
      'sede_id': ref.read(siteProvider)!.id,
    });
    services = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGeneralServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          translate(context, 'services'),
          style: TextStyle(color: ref.read(flavorProvider).primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceHeader(
              title: translate(context, 'service_general'),
              subtitle: translate(context, 'service_general_des'),
              icon: Icons.format_list_bulleted,
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
