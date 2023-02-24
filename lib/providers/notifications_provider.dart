import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';

final notificationsProvider = ChangeNotifierProvider(
  (ref) => NotificationsProvider(),
);

class NotificationsProvider extends ChangeNotifier {
  List<PharmaNotification>? notifications;
  int count = 0;
  final ApisNew _apisNew = ApisNew();

  Future<void> getNotifications(Map<String, dynamic> data) async {
    notifications = await _apisNew.getNotifications(data);
    getUnreadMessages();
    notifyListeners();
  }

  Future<void> updateNotificationStatus(Map<String, dynamic> data) async {
    final result = await _apisNew.updateNotification(data);
  }

  int getUnreadMessages() {
    count = 0;
    if (notifications != null) {
      for (var element in notifications!) {
        if (element.read == "false" || element.read == null) {
          count++;
        }
      }
    }
    notifyListeners();
    return count;
  }
}
