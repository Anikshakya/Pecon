import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/model/ad_slider_model.dart';

class HomeController extends GetxController{
  // Get Controllers 
  final RxBool isAdBannerLoading = false.obs;

  // Ad List Banner
  dynamic adSliderData;

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
}