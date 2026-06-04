import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';
import 'package:pecon_app/src/services/activity_service.dart';
import 'package:pecon_app/src/services/notification_service.dart';
import 'package:pecon_app/src/view/splash_screen.dart';

// To Update Notification
Future<void> backgroundHandler(RemoteMessage message) async{
  // WidgetsFlutterBinding.ensureInitialized();
  // debugPrint(message.data.toString());
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await NotificationService.initNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler); // FirebaseMessaging used correctly after initialization.
  runApp(
    const MyApp()
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppController appCon = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    NotificationService.handlePushNotifications(context);
    /// Initialize activity service
    UserActivityService.instance.initialize();
  }

  void _onUserInteraction([PointerEvent? _]) {
    UserActivityService.instance.onUserInteraction();
  }

  @override
  void dispose() {
    UserActivityService.instance.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,

      /// Detect all touches
      onPointerDown: _onUserInteraction,
      onPointerMove: _onUserInteraction,
      onPointerUp: _onUserInteraction,
      child: ScreenUtilInit(
        designSize: const Size(375, 832),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            title: 'Pecon',
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 500),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: primary),
              useMaterial3: true,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: primary, 
                selectionColor: primary.withValues(alpha:.65), 
                selectionHandleColor: primary, 
              ),
            ),
            home: const SplashScreen(),
            builder: (context, child) {
              return SafeArea(
                top: false,
                bottom: Platform.isIOS ? false : true,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: child!,
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}