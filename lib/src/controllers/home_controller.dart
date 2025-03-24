import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/app_config/constant.dart';
import 'package:pecon/src/app_config/read_write.dart';
import 'package:pecon/src/model/ad_slider_model.dart';
import 'package:pecon/src/model/redeeme_item_model.dart';
import 'package:pecon/src/model/top_performer_model.dart';

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
  getTop5Performers({number, password}) async {
    var cacheData = read(AppConstants().homeTopFivePerformers);
    try{
      if(cacheData == "") isTop5PerformerLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/performers/report', "", 'Get Top 5 Performers');
      if(response != null && response['code'] == 200) {
        if(response["data"] != null && response["data"] != []){
          if(cacheData == ""){
            final data = TopPerformers.fromJson(response);
            topPerformer.assignAll(data.data);
            write(AppConstants().homeTopFivePerformers, TopPerformers.fromJson(response));
          }

          if(cacheData != "" && jsonEncode(cacheData) != jsonEncode(response)){
            var data = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? TopPerformers.fromJson(cacheData) : cacheData;
            topPerformer.assignAll(data.data);
            write(AppConstants().homeTopFivePerformers, TopPerformers.fromJson(response));
          }

          if(cacheData != "" && jsonEncode(cacheData) == jsonEncode(response)){
            var data = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? TopPerformers.fromJson(cacheData) : cacheData;
            topPerformer.assignAll(data.data);
          }
        }
      } else {
        if(cacheData != ""){
          var data = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? TopPerformers.fromJson(cacheData) : cacheData;
          topPerformer.assignAll(data.data);
        }
      }
    }catch (e){
      log(e.toString());
    } finally{
      if(cacheData == "") isTop5PerformerLoading(false); // Stop Loading
    }
  }

}