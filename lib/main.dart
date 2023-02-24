import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/pushNotificationConfig.dart';
import '../../my_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final navigatorKey = GlobalKey<NavigatorState>();

  final flavor = Flavor(
    pharmacyId: 163,
    pharmacyName: "Farmacie Stilo",
    primary: const Color(0xff1a3922),
    lightPrimary: const Color(0xff216e37),
  );

  await PushNotificationConfig(navigatorKey).setupInteractedMessage();
  runApp(
    ProviderScope(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}
