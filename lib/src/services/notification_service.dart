import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

enum NotificationState {
  foreground,
  background,
  terminated
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final messaging = FirebaseMessaging.instance;
  

  static initNotification() async {
    //Request Notification permission
    requestNotificationPermission();
    //Get the fcm Token
    getFcmToken();
    //Initialize notification settings
    initializeNotification();
  }

  //Initialize Local Notification
  static initializeNotification() async{
    //For Android Settings
    var initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher');

    //For Ios Settings
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:(int id, String? title, String? body, String? payload) async {
      //   if(payload != null){
      //     //Show a dialog, Do smthng
      //   }
      // }
    );

    //Initialize Notification settings
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:(NotificationResponse details) async {
        if(details.payload !=null && details.payload != ""){
        }
      }
    );
  }

  //Ask for notification permission
  static requestNotificationPermission() async {
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

  //Get Fcm Token
  static getFcmToken() async{
    String? fcm = await messaging.getToken();
    log("FCM Token: $fcm");    
    return fcm;
  }

  //Notification Details
  static notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'fujisawa', //Channel Id
        'fujisawa', //Channel name
        importance: Importance.high
      ),
      iOS: DarwinNotificationDetails(
        badgeNumber: 0,
      )
    );
  }

  //Show Notification
  static showNotification({message}) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      await notificationsPlugin.show(
        id,
        message.notification!.title ?? "", 
        message.notification!.body ?? "", 
        notificationDetails(),
        payload: jsonEncode(message.data)
      );
      //Initialize Settings, required to detect on tap on ios
      initializeNotification();

    } catch (e){
      debugPrint(e.toString());
    }
  }

  //Detect and Get Push Notification
  static getPushedNotification(context){
    //On App Terminated
    messaging.getInitialMessage().then((message){
      if(message != null ){
        //Route on App Terminated
      }
    });

    //On Foreground Message
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(message.data["payload"].toString());
      showNotification(
        message: message
      );
    });
  }

  //Shedule Notification
  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime
      }
  ) {
    tz.initializeTimeZones();
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      // scheduledNotificationDateTime as tz.TZDateTime,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      notificationDetails(),
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }
}

