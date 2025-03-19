import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/model/product_list_model.dart';
import 'package:pecon/src/widgets/confetti_widget.dart';
import 'package:pecon/src/widgets/custom_toast.dart';

class ProductsController extends GetxController{
  final UserController userCon = Get.put(UserController());
  // Get Controllers 
  final RxBool isLoading               = true.obs;
  final RxBool isRedeemeLoading        = false.obs;
  final RxBool isProductListLoading    = false.obs;
  final RxBool isProductReturnLoading  = false.obs;

  //category List
  List categoryList             = [];
  List filteredSubcategories    = [];
  String selectedCategory       = "";
  String selectedSubCategory    = "";

  //ProductList
  List productList = [];

  //Get product List
  getProductList([keyword,categoryId,subcategoryId]) async {
    var data = {
      "category_id": categoryId,
      "subcategory_id": subcategoryId,
      "query": keyword == "" ? null : keyword
    };
    try{
      isProductListLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/product/display-products', data, 'Get Product List');
      if(response != null && response['code'] == 200) {
        var allData = ProductListModel.fromJson(response);
        productList = allData.data;
      }
    }catch (e){
      log(e.toString());
    } finally{
      isProductListLoading(false); // Stop Loading
    }
  }

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
  redeemePoints ({code, context}) async{
    var data = {
      "code" : code
    };
    try{
      isRedeemeLoading(true); // Start Loading
      var response = await ApiRepo.apiPost('api/product/redeem', data, 'Product Redeem');
      if(response != null && response['code'] == 200) {
        await userCon.getUserData(); // to update points without refreshing the page
        Get.back(); // Pop Dialogue
        showToast(
          isSuccess: true,
          message: response["message"] ?? "Product redeemed successfully"
        );
        showDialog(
          context: context,
          barrierColor: Colors.transparent, // No background
          builder: (context) => const ConfettiDialog(type: ConfettiType.fireworks),
        );
      }
    }catch (e){
      isRedeemeLoading(false); // Stop Loading
      log(e.toString());
    } finally{
      isRedeemeLoading(false); // Stop Loading
    }
  }

   // Replace a product
  returnProduct({previousCode, remarks}) async{
    var data = {
      "code": previousCode,
      "remarks": remarks,
    };
    try{
      isProductReturnLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/product/return-product', data, 'Replace Product');
      if(response != null && response['code'] == 201) {
        Get.back();
        showToast(isSuccess: true, message: "Product Returned Sucessfully");
      }
    }catch (e){
      log(e.toString());
    } finally{
      isProductReturnLoading(false);
    }
  }

  // Replace a product
  replaceProduct({previousCode, currentCode}) async{
    var data = {
      "previous_code": previousCode,
      "current_code": currentCode,
    };
    try{
      isProductReturnLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/product/replace-product', data, 'Return Product');
      if(response != null && response['code'] == 201) {
        Get.back();
        showToast(isSuccess: true, message: "Product Returned Successfully");
      }
    }catch (e){
      log(e.toString());
    } finally{
      isProductReturnLoading(false);
    }
  }
}