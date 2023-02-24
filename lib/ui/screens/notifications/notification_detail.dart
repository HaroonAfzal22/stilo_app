import 'package:contacta_pharmacy/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/notification.dart';

//TODO add check logged???

class NotificationDetailScreen extends ConsumerStatefulWidget {
  const NotificationDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/notification-detail-screen';

  @override
  ConsumerState<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends ConsumerState<NotificationDetailScreen> {
  PharmaNotification? notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      notification =
          ModalRoute.of(context)!.settings.arguments as PharmaNotification;
      ref.read(notificationsProvider).updateNotificationStatus({
        'id': notification?.id,
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        //TODO modificare
        title: const Text(
          'Dettaglio',
        ),
      ),
      body: notification != null
          ? SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification?.title ?? '',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(notification?.body ?? ''),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: ref.read(flavorProvider).lightPrimary,
              ),
            ),
    );
  }
}
