import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon/src/app_config/styles.dart';

partnerLogo(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("A PRODUCT OF", style: poppinsRegular(size: 12.sp, color: black)),
        Image.asset("assets/images/logo.png", height: 40.h),
      ],
    ),
  );
}