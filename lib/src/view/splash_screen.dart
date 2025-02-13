import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const LoginPage());
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("A PRODUCT OF", style: poppinsRegular(size: 12.sp, color: black)),
                    Image.asset("assets/images/logo.png", height: 40.h),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}