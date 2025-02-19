
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';

class SettingsController extends GetxController{
  //loadings
  final RxBool isLoading = false.obs;
  //List
  List offersList = [];

  //get offers and promotion
  getOfferPromotion() async {
    try{
      isLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/offers', "", 'Offers and Promotions');
      if(response != null && response['code'] == 200) {
        if(response["data"] != null && response["data"] != []){
          offersList = response["data"];
        }
      }
    }catch (e){
      log(e.toString());
    } finally{
      isLoading(false); // Stop Loading
    }
  }

}