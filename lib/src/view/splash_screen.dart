import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/widgets/partner_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Get Controllers
  final AuthController authCon = Get.put(AuthController());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      // Route Acc To Auth Status
      authCon.checkUserAuthStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Image.asset("assets/images/peacon_logo.png", height: 50.h),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 43.0.sp),
                child: partnerLogo()
              ),
            )
          ],
        ),
      ),
    );
  }
}