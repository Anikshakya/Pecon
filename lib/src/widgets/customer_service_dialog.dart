
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:url_launcher/url_launcher.dart';

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
                InkWell(
                  onTap: makePhoneCall,
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
                InkWell(
                  onTap: openWhatsApp,
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
                SizedBox(height: 10.h,),
              ],
            ),
          ),
        );
      },
    ),
  );
}

//phone
makePhoneCall() async {
  final Uri callUri = Uri.parse("tel:1234567890");
  debugPrint("Attempting to launch: $callUri");
  if (await canLaunchUrl(callUri)) {
    await launchUrl(callUri);
  } else {
    debugPrint("Could not launch $callUri");
  }
}

//whatsapp
openWhatsApp() async {
  final Uri whatsappUri = Uri.parse("https://wa.me/1234567890");
  debugPrint("Attempting to launch: $whatsappUri");
  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri);
  } else {
    debugPrint("Could not launch $whatsappUri");
  }
}