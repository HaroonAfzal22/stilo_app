import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_galenic_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../custom_widgets/no_data.dart';

class SentGalenicTab extends ConsumerStatefulWidget {
  const SentGalenicTab({Key? key}) : super(key: key);

  @override
  ConsumerState<SentGalenicTab> createState() => _SentGalenicTabState();
}

class _SentGalenicTabState extends ConsumerState<SentGalenicTab> {
  List<dynamic>? galenicPreparations;
  final ApisNew _apisNew = ApisNew();

  Future<void> getAllGalenicPreparations() async {
    final result = await _apisNew.getAllGalenicPreparations({
      'user_id': ref.read(authProvider).user?.userId,
    });

    galenicPreparations = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider).user != null) {
      getAllGalenicPreparations();
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
          if (galenicPreparations != null && galenicPreparations!.isNotEmpty)
            ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              GalenicDetailScreen.routeName,
                              arguments: galenicPreparations![index]);
                        },
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        title: Text('Caricata il ' +
                            galenicPreparations![index]['created_date']
                                .substring(0, 10)),
                        leading: Image.asset('assets/images/noImage.png'),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: galenicPreparations!.length)
          else if (galenicPreparations != null && galenicPreparations!.isEmpty)
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
