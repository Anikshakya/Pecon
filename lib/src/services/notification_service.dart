import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer';
 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
 
class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
 
  /// Initialize Firebase & Local Notifications
  static Future<void> initNotification() async {
    await requestNotificationPermission();
    await getFcmToken();
    await initializeNotification();
  }
 
  /// Initialize Local Notification Plugin
  static Future<void> initializeNotification() async {
    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
 
    // iOS Settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
 
    // Combined Settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
 
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        if (details.payload != null && details.payload!.isNotEmpty) {
          // Handle notification tap
          debugPrint('Notification Payload: ${details.payload}');
        }
      },
    );
  }
 
  /// Request Notification Permissions
  static Future<void> requestNotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
 
  /// Get FCM Token
  static Future<String?> getFcmToken() async {
    String? fcmToken = await messaging.getToken();
    // log("FCM Token: $fcmToken");
    return fcmToken;
  }
 
  /// Notification Details (Supports Images)
  static NotificationDetails notificationDetails({String? imagePath}) {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'fujisawa_channel', // Channel ID
      'Fujisawa Notifications', // Channel Name
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: imagePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imagePath),
              largeIcon: FilePathAndroidBitmap(imagePath),
              hideExpandedLargeIcon: false,
            )
          : null,
    );
 
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      badgeNumber: 1,
    );
 
    return NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }
 
  /// Show Notification with Image Support
  static Future<void> showNotification({
    required RemoteMessage message,
  }) async {
    try {
      final int id = Random().nextInt(1000);
      String? imageUrl = message.notification?.android?.imageUrl ??
          message.data['image'] ??
          message.data['image_url'];
 
      String? downloadedImagePath;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        downloadedImagePath = await _downloadAndSaveImage(imageUrl, 'notif_$id');
      }
 
      await notificationsPlugin.show(
        id,
        message.notification?.title ?? "New Notification",
        message.notification?.body ?? "",
        notificationDetails(imagePath: downloadedImagePath),
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
 
  /// Download and Save Image for Notification
  static Future<String?> _downloadAndSaveImage(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final String filePath = '${directory.path}/$filename.jpg';
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
    }
    return null;
  }
 
  /// Schedule a Notification (Optional)
  static Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledTime,
    String? imagePath,
  }) async {
    tz.initializeTimeZones();
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails(imagePath: imagePath),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }
 
  /// Handle Incoming Push Notifications
  static void handlePushNotifications(BuildContext context) {
    // When app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('Terminated Notification: ${message.data}');
        // Handle navigation
      }
    });
 
    // When app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Background Notification: ${message.data}');
      // Handle navigation
    });
 
    // When app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Foreground Notification: ${message.data}');
      await showNotification(message: message);
    });
  }
}