import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/utils/app_utils.dart';
import 'package:pecon/src/app_config/styles.dart';

final AppController appCon = Get.put(AppController());

customerServiceDialog() {
  return Get.defaultDialog(
    backgroundColor: boxCol,
    title: '',
    titlePadding: EdgeInsets.symmetric(horizontal: 20.0.w),
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w),
    content: StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Contact Options",
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                SizedBox(height: 15.h,),
                //call
                InkWell(
                  onTap: ()=> AppUtils().openLinkWithUrl("tel:${appCon.phoneLink}"),
                  borderRadius: BorderRadius.circular(30.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Image.asset("assets/images/phone.png", width: 30.w, height: 30.w, fit: BoxFit.cover,), // Replace with your phone icon
                        SizedBox(width: 20.w),
                        Text("Call", style: TextStyle(fontSize: 13.sp, color: black, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h,),
                //whatsapp
                InkWell(
                  onTap: ()=> AppUtils().openLinkWithUrl("https://wa.me/${appCon.phoneLink}"),
                  borderRadius: BorderRadius.circular(30.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Image.asset("assets/images/whatsapp.png", width: 30.w, height: 30.w, fit: BoxFit.cover), // Replace with your WhatsApp icon
                        SizedBox(width: 20.w),
                        Text("WhatsApp",style: TextStyle(fontSize: 13.sp, color: black, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h,),
                //facebook
                InkWell(
                  onTap: ()=> AppUtils().openLinkWithUrl(Platform.isIOS ? "fb://profile/${appCon.fbLink}" : "fb://page/${appCon.fbLink}"),
                  borderRadius: BorderRadius.circular(30.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Image.asset("assets/images/facebook.png", width: 30.w, height: 30.w, fit: BoxFit.cover), // Replace with your WhatsApp icon
                        SizedBox(width: 20.w),
                        Text("Facebook",style: TextStyle(fontSize: 13.sp, color: black, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
              ],
            ),
          ),
        );
      },
    ),
  );
}