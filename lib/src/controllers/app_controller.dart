import 'package:pecon/src/app_config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppController extends GetxController{
  // Single function to show the ad dialog
  void showAdDialog() {
    Get.dialog(
      // Transparent background, no title, no extra padding
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
                  child: SizedBox(
                    height: 500.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/ad.jpg", // Ad image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 4,
                  child: GestureDetector(
                    onTap: () => Get.back(), // Close the dialog
                    child: const CircleAvatar(
                      backgroundColor: white,
                      radius: 16,
                      child: Icon(Icons.close, color: black, size: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }
}