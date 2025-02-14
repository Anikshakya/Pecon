import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/utils/app_utils.dart';

AppController _appCon = Get.put(AppController());

partnerLogo(){
  return Center(
    child: GestureDetector(
      onTap: _appCon.webUrl != ""
      ? (){
        AppUtils().openLinkWithUrl(_appCon.webUrl);
      }
      : (){},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("A PRODUCT OF", style: poppinsRegular(size: 12.sp, color: black)),
          Image.asset("assets/images/logo.png", height: 40.h),
        ],
      ),
    ),
  );
}