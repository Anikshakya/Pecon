import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon/src/widgets/customer_service_dialog.dart';

//logo app bar
customAppbar(){
  return PreferredSize(
    preferredSize: Size(double.infinity, 62.0.h),
    child: Container(
      color: primary,
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.0.sp),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Row(
              
              children: [
                SizedBox(
                  height: 34.0.h,
                  child: Image.asset("assets/images/peacon_logo.png"),
                ),
                const Spacer(),
                InkWell(
                  onTap: (){
                    customerServiceDialog();
                  },
                  child: Image.asset("assets/images/customer_service.png", width:22.w, height:26.w, fit: BoxFit.cover,),
                ),
              ],
            ),
          ],
        ),
      ),
    )
  );
}

//normal appbar
appbar({String? title}){
  return PreferredSize(
    preferredSize: Size(double.infinity, 62.0.h),
    child: Container(
      color: primary,
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.0.sp),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back, color: black,)
                ),
                SizedBox(width: 24.w,),
                Text(title ?? "", style: poppinsSemiBold(size: 16.sp, color: black),),
                const Spacer(),
                InkWell(
                  onTap: (){
                    customerServiceDialog();
                  },
                  child: Image.asset("assets/images/customer_service.png", width:22.w, height:26.w, fit: BoxFit.cover,),
                ),
              ],
            ),
          ],
        ),
      ),
    )
  );
}

