
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';

class SettingsController extends GetxController{
  //loadings
  final RxBool isLoading = false.obs;
  final RxBool isCatalogLoading = false.obs;
  //List
  List offersList = [];
  List catalogueList = [
    {
      "name": "Catalog 1",
      "url": "https://ncert.nic.in/textbook/pdf/kebo104.pdf",
    },
    {
      "name": "Catalog 2",
      "url": "https://ncert.nic.in/textbook/pdf/kebo104.pdf",
    },
  ];

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

  //get catalogue
  getCatalogue() async {
    try{
      isCatalogLoading(true); // Start Loading
      Future.delayed(const Duration(seconds: 2), () {},);
      // var response = await ApiRepo.apiGet('api/catalog', "", 'Get Catalogue');
      // if(response != null && response['code'] == 200) {
      //   // if(response["data"] != null && response["data"] != []){
      //   //   catalogueList = response["data"];
      //   // }
      // }
    }catch (e){
      log(e.toString());
    } finally{
      isCatalogLoading(false); // Stop Loading
    }
  }

}