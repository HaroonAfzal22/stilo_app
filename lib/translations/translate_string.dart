import 'demo_localizations.dart';

String translate(context, text) {
  return Localization.of(context)!.translate(text);
}
