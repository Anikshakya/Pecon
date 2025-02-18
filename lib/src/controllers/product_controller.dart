import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';

class ProductsController extends GetxController{
  // Get Controllers 
  final RxBool isLoading = true.obs;

  //category List
  List categoryList = [];
  String selectedCategory = "";
  List filteredSubcategories = [];
  String selectedSubCategory = "";


  // Slider/AdBanner API
  getSearchCategory({number, password}) async {
    try{
      isLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/categories', "", 'Get Search Category');
      if(response != null && response['code'] == 200) {
        if(response["data"] != null || response["data"] != []){
          categoryList = response["data"];
        }
      }
    }catch (e){
      isLoading(false); // Stop Loading
      log(e.toString());
    } finally{
      isLoading(false); // Stop Loading
    }
  }
}