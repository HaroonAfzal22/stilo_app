import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localization {
  Localization(this.locale);

  final Locale locale;

  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  late Map<String, dynamic> _sentences;

  Future<bool> load() async {
    String data = await rootBundle
        .loadString('assets/locale/localization_${locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    _sentences = {};
    _result.forEach((String key, dynamic value) {
      _sentences[key] = value.toString();
    });

    return true;
  }

  //TODO fix???
  String translate(String key) {
    return _sentences[key] ?? key;
  }
}
