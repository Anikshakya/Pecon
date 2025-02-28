import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/app_config/read_write.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/model/product_list_model.dart';
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
  getProductList() async {
    try{
      isProductListLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/product/display-products', "", 'Get Product List');
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
  redeemePoints ({code}) async{
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
      }
    }catch (e){
      isRedeemeLoading(false); // Stop Loading
      log(e.toString());
    } finally{
      isRedeemeLoading(false); // Stop Loading
    }
  }

  //return a product
  returnProduct({productId}) async{
    var data = {
      "product_id": productId,
      "user_id": read("user")["id"],
    };
    try{
      isProductReturnLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/product/return', data, 'Return Product');
      if(response != null && response['code'] == 201) {
        Get.back();
        showToast(isSuccess: true, message: "Updated");
      }
    }catch (e){
      log(e.toString());
    } finally{
      isProductReturnLoading(false);
    }
  }
}