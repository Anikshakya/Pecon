import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon_app/src/api_config/api_repo.dart';
import 'package:pecon_app/src/app_config/constant.dart';
import 'package:pecon_app/src/app_config/read_write.dart';
import 'package:pecon_app/src/controllers/user_controller.dart';
import 'package:pecon_app/src/model/ad_slider_model.dart';
import 'package:pecon_app/src/model/redeeme_item_model.dart';
import 'package:pecon_app/src/model/top_performer_model.dart';

class HomeController extends GetxController{
  // Get Controllers 
  final RxBool isAdBannerLoading = false.obs;
  final RxBool isRedeemInfoLoading = false.obs;
  final RxBool isTop5PerformerLoading = false.obs;

  // Ad List Banner
  dynamic adSliderData;

  //redeem List
  List redeemInfoData = [];

  // Top Performers
  List topPerformer = <Performers>[];

  //redeem header image
  String headerImage = "";

  // Slider/AdBanner API
  getAdBanner({number, password}) async {
    var cacheData = read(AppConstants().homeAd);
    try{
      if(cacheData == "") isAdBannerLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/sliders', "", 'Sliders API');
      if(response != null && response['code'] == 200) {
        if(cacheData == ""){
          adSliderData = AdSlider.fromJson(response);
          write(AppConstants().homeAd, AdSlider.fromJson(response));
        } 
        if(cacheData != "" && jsonEncode(cacheData) != jsonEncode(response)){
          adSliderData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? AdSlider.fromJson(cacheData) : cacheData;
          write(AppConstants().homeAd, AdSlider.fromJson(response));
        }
        if(cacheData != "" && jsonEncode(cacheData) == jsonEncode(response)){
          adSliderData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? AdSlider.fromJson(cacheData) : cacheData;
        }
      } else {
        if(cacheData != ""){
          adSliderData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? AdSlider.fromJson(cacheData) : cacheData;
        }
      }
    }catch (e){
      if(cacheData == "") isAdBannerLoading(false); // Stop Loading
      log(e.toString());
    } finally{
      if(cacheData == "") isAdBannerLoading(false); // Stop Loading
    }
  }

  // Redeemable prize Info API
  getRedeemInformation({number, password}) async {
    redeemInfoData = [];
    var cacheData = read(AppConstants().homePrize);
    
    try {
      final userCon = Get.find<UserController>();
      final bool isNepali = userCon.isNepaliUser.value;
      
      if (cacheData == "") isRedeemInfoLoading(true); // Start Loading
      
      var response = await ApiRepo.apiGet('api/redeem-information', "", 'RedeemInfo API');
      
      if (response != null && response['code'] == 200) {
        // 1. Extract the raw list from the API response safely
        var rawList = response['data']?['reedemInformation'] as List? ?? [];
        
        // 2. Filter the list based on your exact location rule
        List filteredList = rawList.where((item) {
          String country = item['country'].toString().toLowerCase();
          if (isNepali) {
            return country == "nepal";
          } else {
            return country != "nepal"; // Gets everything that is NOT Nepal (India, Dubai, etc.)
          }
        }).toList();

        // 3. Reconstruct a valid map matching what your Model expects
        Map<String, dynamic> filteredResponse = {
          "status": response['status'],
          "code": response['code'],
          "message": response['message'],
          "data": {
            "header_image": response['data']?['header_image'],
            "reedemInformation": filteredList
          }
        };

        // 4. Handle Cache Comparison and State Updates
        if (cacheData == "") {
          var allData = RedeemInformationModel.fromJson(filteredResponse);
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
          write(AppConstants().homePrize, filteredResponse); // Save the clean Map structure
        } 
        else if (jsonEncode(cacheData) != jsonEncode(filteredResponse)) {
          var allData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" 
              ? RedeemInformationModel.fromJson(cacheData) 
              : cacheData;
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
          write(AppConstants().homePrize, filteredResponse);
        }
        else {
          // Cache matches perfectly
          var allData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" 
              ? RedeemInformationModel.fromJson(cacheData) 
              : cacheData;
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
        }

      } else {
        // API call failed, fallback to cache if available
        if (cacheData != "") {
          var allData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" 
              ? RedeemInformationModel.fromJson(cacheData) 
              : cacheData;
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
        }
      }
    } catch (e) {
      log("Error fetching redeem info: ${e.toString()}");
    } finally {
      if (cacheData == "") isRedeemInfoLoading(false); // Stop Loading
    }
  }

  // Get Top 5 Performers
  Future<void> getTop5Performers() async {
    try {
      final userCon = Get.find<UserController>();
      final bool isNepali = userCon.isNepaliUser.value;

      final String cacheKey = isNepali
          ? AppConstants().homeTopFivePerformers
          : "${AppConstants().homeTopFivePerformers}_indian";

      final String path = isNepali
          ? 'api/performers/report'
          : 'api/indian_performers/report';

      isTop5PerformerLoading(true);

      final cacheData = read(cacheKey);

      final response = await ApiRepo.apiGet(path, "", 'Get Top 5 Performers');

      bool success = response != null && (response['status'] == true || response['success'] == true);

      /// ----------------------------
      /// CASE 1: API SUCCESS
      /// ----------------------------
      if (success) {
        final TopPerformers apiData = TopPerformers.fromJson(response);

        topPerformer
          ..clear()
          ..addAll(apiData.data);

        write(cacheKey, response);
        return;
      }

      /// ----------------------------
      /// CASE 2: API FAIL → CACHE
      /// ----------------------------
      if (cacheData != null) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(cacheData);

        final TopPerformers cachedData = TopPerformers.fromJson(json);

        topPerformer
          ..clear()
          ..addAll(cachedData.data);
      } else {
        topPerformer.clear();
      }

    } catch (e) {
      log("getTop5Performers Error: $e");
    } finally {
      isTop5PerformerLoading(false);
    }
  }

}