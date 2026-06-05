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
    try{
      if(cacheData == "") isRedeemInfoLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/redeem-information', "", 'RedeemInfo API');
      if(response != null && response['code'] == 200) {
        if(cacheData == ""){
          var allData = RedeemInformationModel.fromJson(response);
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
          write(AppConstants().homePrize, RedeemInformationModel.fromJson(response));
        } 
        if(cacheData != "" && jsonEncode(cacheData) != jsonEncode(response)){
          var allData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? RedeemInformationModel.fromJson(cacheData) : cacheData;
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
          write(AppConstants().homePrize, RedeemInformationModel.fromJson(response));
        }

        if(cacheData != "" && jsonEncode(cacheData) == jsonEncode(response)){
          var allData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? RedeemInformationModel.fromJson(cacheData) : cacheData;
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
        }

      } else {
        if(cacheData != ""){
          var allData = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? RedeemInformationModel.fromJson(cacheData) : cacheData;
          headerImage = allData.data!.headerImage!;
          redeemInfoData = allData.data!.reedemInformation!;
        }
      }
    }catch (e){
      log(e.toString());
    } finally{
      if(cacheData == "") isRedeemInfoLoading(false); // Stop Loading
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

    final cacheData = read(cacheKey);

    isTop5PerformerLoading(true);

    final response =
        await ApiRepo.apiGet(path, "", 'Get Top 5 Performers');

    /// ----------------------------
    /// ✅ CASE 1: API SUCCESS
    /// ----------------------------
    if (response != null &&
        response['success'] == true &&
        response['data'] != null &&
        response['data'] is List) {

      final TopPerformers apiData = TopPerformers.fromJson(response);

      topPerformer.clear();
      topPerformer.addAll(apiData.data);
      // topPerformer.refresh();

      // overwrite cache ALWAYS
      write(cacheKey, response); // store raw json only (safe)

      return;
    }

    /// ----------------------------
    /// ❌ CASE 2: API FAIL → USE CACHE
    /// ----------------------------
    if (cacheData != null && cacheData.toString().isNotEmpty) {
      final Map<String, dynamic> json =
          cacheData is Map<String, dynamic>
              ? cacheData
              : Map<String, dynamic>.from(cacheData);

      final TopPerformers data = TopPerformers.fromJson(json);

      topPerformer.clear();
      topPerformer.addAll(data.data);
      // topPerformer.refresh();
    }

  } catch (e) {
    log("getTop5Performers Error: $e");
  } finally {
    isTop5PerformerLoading(false);
  }
}

}