import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_markdown.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';

class PrivacyPolicy extends StatelessWidget {
  PrivacyPolicy({super.key});
  //GetController
  final AppController appCon = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title: "Privacy Policy"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
          child: CustomMarkdownWidget(
            data: appCon.privacyPolicy,
            imageBuilder: (uri, title, alt) {
              var imageList = [];
              imageList.add(uri.toString());
              return CustomNetworkImage(
                imageUrl: uri.toString(),
                height: 442.0.h,
                width: double.infinity,
              );
            },
          ),
        ),
      ),
    );
  }
}