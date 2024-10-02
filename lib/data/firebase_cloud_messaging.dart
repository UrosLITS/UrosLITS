import 'dart:convert';

import 'package:book/core/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

class FCM {
  static FCM? _instance;
  late bool isFlutterLocalNotificationsInitialized;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  late ServiceAccountCredentials accountCredentials;

  FCM._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    isFlutterLocalNotificationsInitialized = false;
    channel = AndroidNotificationChannel(
      'id',
      'name',
      importance: Importance.max,
    );
    _initAccountCredentials();
  }

  factory FCM() {
    if (_instance == null) {
      _instance = FCM._internal();
    }
    return _instance!;
  }

  static FCM get instance => FCM();

  Future<bool> sendPushMessage(
      {String? token,
      String? topic,
      String? imageUrl,
      Map<String, dynamic>? additionalData,
      required String title,
      required String body,
      String? bookId}) async {
    final client = await clientViaServiceAccount(
      accountCredentials,
      ['https://www.googleapis.com/auth/cloud-platform'],
    ).timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    final notificationData = {
      'message': {
        'topic': topic,
        'data': additionalData,
        'notification': {
          'title': title,
          'body': body,
        }
      },
    };

    const String senderId = messagingSenderId;
    final response = await client
        .post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(notificationData),
    )
        .timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    client.close();
    if (response.statusCode == 200) {
      return true;
    }

    print('Notification Sending Error Response status: ${response.statusCode}');
    print('Notification Response body: ${response.body}');
    return false;
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    isFlutterLocalNotificationsInitialized = true;
  }

  showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
        ),
      );
    }
  }

  Future<void> _initAccountCredentials() async {
    final jsonCredentials =
        await rootBundle.loadString('assets/book-d21ec-c64560991d06.json');
    accountCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);
  }
}
