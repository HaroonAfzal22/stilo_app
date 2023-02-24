import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/notifications_provider.dart';
import 'package:contacta_pharmacy/ui/screens/notifications/notification_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/no_data.dart';
import '../../custom_widgets/no_user.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  static const routeName = '/notifications-screen';

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      ref.read(notificationsProvider).getNotifications({
        'user_id': user.userId,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final notifications = ref.watch(notificationsProvider).notifications;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          translate(context, 'notification'),
        ),
      ),
      body: Column(
        children: [
          if (user == null)
            const NoUser()
          else if (notifications != null && notifications.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(
                      NotificationDetailScreen.routeName,
                      arguments: notifications[index],
                    )
                        .then((_) {
                      ref.read(notificationsProvider).getNotifications({
                        'user_id': ref.read(authProvider).user?.userId,
                      });
                    });
                  },
                  tileColor: notifications[index].read == 'true'
                      ? Colors.grey[100]
                      : Colors.lightBlueAccent.withOpacity(0.2),
                  title: Text(notifications[index].title),
                ),
              ),
            )
          else if (notifications != null && notifications.isEmpty)
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              child: NoData(
                text: translate(context, 'No_Notifications'),
              ),
            )
          else
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              child: Center(
                child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary),
              ),
            )
        ],
      ),
    );
  }
}
