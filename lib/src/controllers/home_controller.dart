import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';

class HomeController extends GetxController{
  // Get Controllers 
  final RxBool isAdBannerLoading = false.obs;

  // Ad List Banner
  List adBannerList = [];

  // Slider/AdBanner API
  login({number, password}) async {
    try{
      isAdBannerLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/sliders', "", 'Sliders API');
      if(response != null && response['code'] == 200) {
        adBannerList = response['data'];
      }
    }catch (e){
      isAdBannerLoading(false); // Stop Loading
      log(e.toString());
    } finally{
      isAdBannerLoading(false); // Stop Loading
    }
  }
}