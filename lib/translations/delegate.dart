import 'package:flutter/material.dart';

import 'demo_localizations.dart';

class MyLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  final Locale? newLocale;
  const MyLocalizationsDelegate(this.newLocale);

  @override
  bool isSupported(Locale locale) => ['it', 'en'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) async {
    Localization localizations = Localization(newLocale ?? locale);
    await localizations.load();

    // print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => true;
}
