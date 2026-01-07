import 'package:faded/faded.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/services/notification_service.dart';
import 'package:pecon/src/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

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
    Faded(
      dueDate: DateTime(2025, 12, 24),
      daysDeadline: 60,
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    NotificationService.handlePushNotifications(context);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
              selectionColor: primary.withOpacity(.65), 
              selectionHandleColor: primary, 
            ),
          ),
          home: const SplashScreen(),
        );
      }
    );
  }
}