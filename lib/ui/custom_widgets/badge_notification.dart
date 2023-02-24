import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';
import '../../providers/notifications_provider.dart';

class BadgeNotifications extends ConsumerStatefulWidget {
  const BadgeNotifications({
    Key? key,
    this.badgeColor,
    this.iconColor,
  }) : super(key: key);
  final Color? badgeColor;
  final Color? iconColor;

  @override
  _BadgeNotificationsState createState() => _BadgeNotificationsState();
}

class _BadgeNotificationsState extends ConsumerState<BadgeNotifications> {
  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: -5),
      badgeColor: widget.badgeColor ?? ref.read(flavorProvider).lightPrimary,
      animationDuration: const Duration(milliseconds: 300),
      animationType: BadgeAnimationType.fade,
      badgeContent: Text(
        ref.watch(notificationsProvider).count.toString(),
        style: const TextStyle(color: Colors.white),
      ),
      child: Icon(
        Icons.notifications,
        color: widget.iconColor ?? Colors.grey[600],
      ),
    );
  }
}
