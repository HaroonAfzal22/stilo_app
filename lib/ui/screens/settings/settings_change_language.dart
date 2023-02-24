import 'package:contacta_pharmacy/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';
//TODO finire a vedere nuova UI

class SettingsChangeLanguage extends ConsumerStatefulWidget {
  const SettingsChangeLanguage({Key? key}) : super(key: key);
  static const routeName = '/settings-change-language';

  @override
  _SettingsChangeLanguageState createState() => _SettingsChangeLanguageState();
}

class _SettingsChangeLanguageState
    extends ConsumerState<SettingsChangeLanguage> {
  String localization = "it";
  Map<String, bool> active = {"it": false, "en": false};

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final provider = ref.read(appProvider);
      if (provider.locale == null) {
        var lang = await provider.getLocale();
        active[lang == null ? "it" : lang.languageCode] = true;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(appProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'change_language'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO add Translations
          ListTile(
            onTap: () async {
              provider.setLocale(const Locale("it"));
              setState(() {
                active["it"] = true;
                active["en"] = false;
              });
            },
            tileColor: active["it"]!
                ? ref.read(flavorProvider).lightPrimary
                : Colors.white,
            title: Text('Italiano',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: active["it"]! ? Colors.white : Colors.black)),
          ),
          ListTile(
            onTap: () async {
              provider.setLocale(const Locale("en"));
              setState(() {
                active["it"] = false;
                active["en"] = true;
              });
            },
            tileColor: active["en"]!
                ? ref.read(flavorProvider).lightPrimary
                : Colors.white,
            title: Text('Inglese',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: active["en"]! ? Colors.white : Colors.black)),
          ),
        ],
      ),
    );
  }
}
