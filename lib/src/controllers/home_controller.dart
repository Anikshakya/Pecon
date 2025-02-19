import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';
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
    try{
      isAdBannerLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/sliders', "", 'Sliders API');
      if(response != null && response['code'] == 200) {
        adSliderData = AdSlider.fromJson(response);
      }
    }catch (e){
      isAdBannerLoading(false); // Stop Loading
      log(e.toString());
    } finally{
      isAdBannerLoading(false); // Stop Loading
    }
  }

  // Redeemable prize Info API
  getRedeemInformation({number, password}) async {
    try{
      isRedeemInfoLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/redeem-information', "", 'RedeemInfo API');
      if(response != null && response['code'] == 200) {
        var allData = RedeemInformationModel.fromJson(response);
        headerImage = allData.data!.headerImage!;
        redeemInfoData = allData.data!.reedemInformation!;

      }
    }catch (e){
      log(e.toString());
    } finally{
      isRedeemInfoLoading(false); // Stop Loading
    }
  }

  // Get Top 5 Performers
  getTop5Performers({number, password}) async {
    try{
      isTop5PerformerLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/performers/report', "", 'Get Top 5 Performers');
      if(response != null && response['code'] == 200) {
        if(response["data"] != null && response["data"] != []){
          final data = TopPerformers.fromJson(response);
          topPerformer.assignAll(data.data);
        }
      }
    }catch (e){
      log(e.toString());
    } finally{
      isTop5PerformerLoading(false); // Stop Loading
    }
  }

}