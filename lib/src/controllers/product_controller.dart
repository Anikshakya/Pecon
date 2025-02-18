import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/widgets/custom_toast.dart';

class ProductsController extends GetxController{
  // Get Controllers 
  final RxBool isLoading = true.obs;
  final RxBool isRedeemeLoading = false.obs;

  //category List
  List categoryList             = [];
  List filteredSubcategories    = [];
  String selectedCategory       = "";
  String selectedSubCategory    = "";


  // Slider/AdBanner API
  getSearchCategory({number, password}) async {
    try{
      isLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/categories', "", 'Get Search Category');
      if(response != null && response['code'] == 200) {
        if(response["data"] != null && response["data"] != []){
          categoryList = response["data"];
        }
      }
    }catch (e){
      log(e.toString());
    } finally{
      isLoading(false); // Stop Loading
    }
  }

  // redeeme points
  redeemePoints ({code}) async{
    var data = {
      "code" : code
    };

    try{
      isRedeemeLoading(true); // Start Loading
      var response = await ApiRepo.apiPost('api/product/redeem', data, 'Product Redeem');
      if(response != null && response['code'] == 200) {
        Get.back(); // Pop Dialogue
        showToast(
          isSuccess: true,
          message: response["message"] ?? "Product redeemed successfully"
        );
      }
    }catch (e){
      isRedeemeLoading(false); // Stop Loading
      log(e.toString());
    } finally{
      isRedeemeLoading(false); // Stop Loading
    }
  }
}