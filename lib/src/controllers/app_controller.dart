import 'dart:developer';

import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';

class AppController extends GetxController{
  //loadings
  final RxBool isLoading = false.obs;
  final RxBool isBannerLoading = false.obs;
  //website link
  String webUrl = "";
  String phoneLink = "";
  String fbLink = "";
  //termsCondition
  String termsCondition = "";
  String privacyPolicy = "";
  String adBanner = "";


  // terms condition/splash screen link api
  getSettingApi() async {
    try{
      isLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/settings', "", 'SettingApiAPI');
      if(response != null && response['code'] == 200) {
        webUrl = response["data"]["website_link"] ?? "";
        termsCondition = response["data"]["terms_and_condition"] ?? "";
        privacyPolicy = response["data"]["privacy_policy"] ?? "";
        phoneLink = response["data"]["phone"] ?? "";
        fbLink = response["data"]["facebook_link"] ?? "";
      }
    }catch (e){
      log(e.toString());
    } finally{
      isLoading(false); // Stop Loading
    }
  }

  //get ad banner
  getAdBanner() async {
    try{
      isBannerLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/ads_banner', "", 'SettingApiAPI');
      if(response != null && response['code'] == 200) {
        // adBanner = response["data"];
      }
    }catch (e){
      log(e.toString());
    } finally{
      isBannerLoading(false); // Stop Loading
    }
  }

  // Single function to show the ad dialog
  showAdDialog() {
    return Get.dialog(
      // Transparent background, no title, no extra padding
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Obx(()=>
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
                    child: SizedBox(
                      height: 500.h,
                      width: double.infinity,
                      child: isBannerLoading.value == true 
                        ? Container(
                          decoration: BoxDecoration(
                            color: gray,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                        : adBanner == ""
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/images/ad.jpg", // Ad image
                            fit: BoxFit.cover,
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomNetworkImage(
                            imageUrl: adBanner, // Ad image
                            borderRadius: 10,
                            fit: BoxFit.cover,
                          ),
                        )
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