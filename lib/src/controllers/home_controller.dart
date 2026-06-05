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
    
    // Helper function to update state variables from a parsed model
    void updateUIState(dynamic dataOrigin) {
      var allData = dataOrigin is Map<String, dynamic> 
          ? RedeemInformationModel.fromJson(dataOrigin) 
          : dataOrigin;
          
      if (allData.data != null) {
        headerImage = allData.data!.headerImage ?? '';
        redeemInfoData = allData.data!.reedemInformation ?? [];
      }
    }

    try {
      final userCon = Get.find<UserController>();
      final bool isNepali = userCon.isNepaliUser.value;
      
      // --- STEP 1: CACHE-FIRST APPROACH ---
      // If cache exists, decode it and show it instantly so the UI isn't empty
      if (cacheData != null && cacheData != "") {
        try {
          updateUIState(cacheData);
        } catch (cacheError) {
          log("Error reading initial cache: $cacheError");
        }
      } else {
        isRedeemInfoLoading(true); // Only show loader if there is no cache
      }
      
      // --- STEP 2: FETCH FRESH DATA ---
      var response = await ApiRepo.apiGet('api/redeem-information', "", 'RedeemInfo API');
      
      if (response != null && response['code'] == 200) {
        var rawList = response['data']?['reedemInformation'] as List? ?? [];
        
        // --- STEP 3: CLEAN AND FILTER BY COUNTRY ---
        List filteredList = rawList.where((item) {
          String country = (item['country'] ?? "").toString().toLowerCase().trim();
          if (isNepali) {
            return country == "nepal";
          } else {
            return country != "nepal"; // India, Dubai, etc.
          }
        }).toList();

        // --- STEP 4: RECONSTRUCT VALID MAP PAYLOAD ---
        Map<String, dynamic> filteredResponse = {
          "status": response['status'],
          "code": response['code'],
          "message": response['message'],
          "data": {
            "header_image": response['data']?['header_image'] ?? response['data']?['header_image'], 
            "reedemInformation": filteredList
          }
        };

        // --- STEP 5: EVALUATE & UPDATE CACHE/UI ---
        String newCacheString = jsonEncode(filteredResponse);
        String oldCacheString = cacheData != "" ? jsonEncode(cacheData) : "";

        // If the cache is empty, or the data (or country selection) changed, update state and cache
        if (cacheData == "" || oldCacheString != newCacheString) {
          updateUIState(filteredResponse);
          write(AppConstants().homePrize, filteredResponse);
        }
        
      } else {
        // API failed, fallback handled gracefully because Step 1 already loaded the cache
        log("API response error or code not 200");
      }
    } catch (e) {
      log("Error fetching redeem info: ${e.toString()}");
    } finally {
      isRedeemInfoLoading(false); // Always turn off loader at the end
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