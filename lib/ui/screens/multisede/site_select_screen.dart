import 'package:contacta_pharmacy/models/sede.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/top_bar_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';
import '../main_screen.dart';

class SiteSelectScreen extends ConsumerStatefulWidget {
  const SiteSelectScreen({Key? key}) : super(key: key);
  static const routeName = '/multisede-choose-screen';

  @override
  MultisedeChooseState createState() => MultisedeChooseState();
}

class MultisedeChooseState extends ConsumerState<SiteSelectScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future saveSite(int siteId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('site_id', siteId);
  }

  @override
  Widget build(BuildContext context) {
    final sites = ref.watch(sitesProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopBarLogo(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    '${translate(context, 'welcome')}${ref.read(flavorProvider).pharmacyName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 64,
          //     vertical: 32,
          //   ),
          //   child: Container(
          //     constraints: const BoxConstraints(maxHeight: 150),
          //     child: Image.asset(
          //       "assets/flavor/logo.png",
          //     ),
          //   ),
          // ),
          Text(
              '${ref.read(flavorProvider).pharmacyName} ha più sedi. Si prega di sceglierne una',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1),
          // const SizedBox(height: 32),
          // const Divider(height: 0),
          Expanded(
            child: ListView.separated(
              //physics: const NeverScrollableScrollPhysics(),

              itemCount: sites.length,
              separatorBuilder: (context, index) => const Divider(
                height: 0,
                color: Colors.black54,
              ),
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  ref.read(siteProvider.notifier).state = sites[index];

                  saveSite(sites[index].id);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainScreen.routeName, (route) => false);
                },
                isThreeLine: sites[index].city?.isNotEmpty ?? false,
                title: Text(sites[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sites[index].address),
                    if (sites[index].city?.isNotEmpty ?? false)
                      Row(
                        children: [
                          Text(sites[index].cap ?? ""),
                          if (sites[index].cap?.isNotEmpty ?? false)
                            const SizedBox(width: 8),
                          Text(sites[index].city ?? ""),
                          const SizedBox(width: 8),
                          Text(sites[index].province ?? ""),
                        ],
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          )
        ],
      ),
    );
  }
}
