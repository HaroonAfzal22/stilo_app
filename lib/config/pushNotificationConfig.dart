import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:contacta_pharmacy/ui/screens/orders/order_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/rentals/rental_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/reservation_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationConfig {
  final GlobalKey<NavigatorState> navigatorKey;

  PushNotificationConfig(this.navigatorKey);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  enableIOSNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  Future<void> setupInteractedMessage() async {
    ApisNew _apisNew = ApisNew();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("user_id");

    _firebaseMessaging.getToken().then((token) async {
      print('My Token');
      print(token);
      prefs.setString("fcm_token", token!);
      print('UserID');
      print(id);

      if (id?.isNotEmpty ?? false) {
        await _apisNew.updateFCMToken({
          'user_id': int.parse(id!),
          'notification_token': token,
        });
      }
    });
    //TODO
    //FirebaseMessaging.instance.onTokenRefresh.listen();

    //_firebaseMessaging.subscribeToTopic("");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.toMap());
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;
      if (notification != null && (android != null || apple != null)) {
        switch (message.data['type']) {
          case "order":
            Navigator.pushNamed(
                navigatorKey.currentContext!, OrderDetailScreen.routeName,
                arguments: message.data['item_id']);
            break;
          case "reservation":
            Navigator.pushNamed(
                navigatorKey.currentContext!, ReservationDetailScreen.routeName,
                arguments: message.data['item_id']);
            break;
          case "rental":
            Navigator.pushNamed(
                navigatorKey.currentContext!, RentalDetailScreen.routeName,
                arguments: message.data['item_id']);
            break;
          default:
            Navigator.pushNamed(
                navigatorKey.currentContext!, MainScreen.routeName);
        }
      }
    });
    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (message) async {
      // This function handles the click in the notification when the app is in foreground
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;
      if (notification != null && (android != null)) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                //icon: android.smallIcon,
                playSound: true,
              ),
              iOS: const DarwinNotificationDetails(
                  presentAlert: true, presentBadge: true, presentSound: true)),
        );
      }
    });
  }
}
