import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotificationsService {
  static LocalNotificationsService? _instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  late FlutterLocalNotificationsPlugin localNotifications;
  late BehaviorSubject<String?> onNotificationClick;

  LocalNotificationsService._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    localNotifications = FlutterLocalNotificationsPlugin();
    onNotificationClick = BehaviorSubject();
  }

  factory LocalNotificationsService() {
    if (_instance == null) {
      _instance = LocalNotificationsService._internal();
    }
    return _instance!;
  }

  static LocalNotificationsService get instance => LocalNotificationsService();

  Future<void> initializeLocalNotification() async {
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/background');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: initializationSettingsIOS);

    await localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final notificationDetails = await _notificationDetails();
    flutterLocalNotificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data));
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  Future<NotificationDetails> _notificationDetails() async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelID', 'channelName',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    if (details.payload != null && details.payload!.isNotEmpty) {
      onNotificationClick.add(details.payload);
    }
  }
}
