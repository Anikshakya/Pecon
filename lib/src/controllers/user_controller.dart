import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:pecon_app/src/api_config/api_repo.dart';
import 'package:pecon_app/src/app_config/constant.dart';
import 'package:pecon_app/src/app_config/read_write.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';
import 'package:pecon_app/src/model/return_product_model.dart';
import 'package:pecon_app/src/model/user_profile_model.dart';
import 'package:pecon_app/src/model/withdrawal_request_model.dart';
import 'package:pecon_app/src/widgets/custom_toast.dart';

class UserController extends GetxController {
  final AppController appCon = Get.put(AppController());
  final RxBool isLoginLoading = false.obs;
  final RxBool isProfileBtnLoading = false.obs;
  final RxBool isBankBtnLoading = false.obs;
  final RxBool isProfileLoading = false.obs;
  final RxBool isDistrictLoading = false.obs;
  final RxBool isCityLoading = false.obs;
  final RxBool isChecoutLoading = false.obs;
  final RxBool isEarningLoading = false.obs;
  final RxBool isWithdrawalLoading = false.obs;
  final RxBool isshopkeeperLoading  = false.obs;
  final RxBool isTechLoading    = false.obs;

  // Logged In User Data
  var user = UserModel().obs;

  //Lists
  dynamic districtList = [];
  dynamic districtCityList = [];
  dynamic cityList = [];
  dynamic earningList = [];
  dynamic withdrawalList = [];

  //shopkeeper id
  // List of text controllers for ID fields
  RxList<TextEditingController> shopkeeperIdControllers = <TextEditingController>[].obs;
  
  // List to store matched names
  RxList<String> shopkeeperNames = <String>[].obs;
  
  // List to control visibility of name displays
  RxList<bool> showNameDisplays = <bool>[].obs;
  
  // Shopkeeper ID to Name mapping
  RxMap<String, String> shopkeeperIdNameMap = <String, String>{}.obs;
  
  // Loading state
  var isshopkeeperIdLoading = false.obs;

  // Get Logged In User Profile
  getUserData([refresh]) async{
    var cacheData = read(AppConstants().userData);
    try{
      if(cacheData == "" || refresh == true) isProfileLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/profile', "", 'User Profile API');
      if(response != null && response['code'] == 200) {
        if(refresh == true){
          user.value = UserModel.fromJson(response);
          write(AppConstants().userData, UserModel.fromJson(response));
          isProfileLoading(false);
          return;
        }

        if(cacheData == ""){
          user.value = UserModel.fromJson(response);
          write(AppConstants().userData, UserModel.fromJson(response));
        }

        if(cacheData != "" && jsonEncode(cacheData) != jsonEncode(response)){
          user.value = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? UserModel.fromJson(cacheData) : cacheData;
          write(AppConstants().userData, UserModel.fromJson(response));
        }

        if(cacheData != "" && jsonEncode(cacheData) == jsonEncode(response)){
          user.value = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? UserModel.fromJson(cacheData) : cacheData;
        }

      } else {
        if(cacheData != ""){
          user.value = cacheData.runtimeType.toString() == "_Map<String, dynamic>" ? UserModel.fromJson(cacheData) : cacheData;
        }
      }
    }catch (e){
      if(cacheData == "") isProfileLoading(false); // Stop Loading
    } finally{
      if(cacheData == "") isProfileLoading(false); // Stop Loading
    }
  }

  //update profile
  updateProfile({name, number, email, gender, dob, city, district, address, image, shopName, panNum, ownerName, shopkeeperId, displayPrice}) async{
    dynamic finaldata;
    if(image == null){
      finaldata = {
        "name": name,
        "phone": number,
        "number": number,
        "alternate_number": number,
        "email": email,
        "district_id" : district,
        "address" : address,
        "city_id" : city,
        "gender": gender,
        "dob" : dob,
        "app_version" : appCon.version.value,
      };
    }
    else{
      finaldata = {
        "name": name,
        "phone": number,
        "alternate_number": number,
        "email": email,
        "district_id" : district,
        "address" : address,
        "city_id" : city,
        "gender": gender,
        "dob" : dob,
        "app_version" : appCon.version.value,
        "profile" : await MultipartFile.fromFile(image.path, filename: image.path.split('/').last)
      };
    }
    var data = FormData.fromMap(finaldata);
    var shopkeeperData = {
      "shop_name": shopName,
      "pan_number": panNum,
      "owner_name": ownerName,
      "display_price": displayPrice
    };
    var technicianData = {
      "vendor_id": shopkeeperId,
    };
    try{
      isProfileBtnLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/profile/update', data, 'Update Profile');
      if(response != null && response['code'] == 201) {
        //shopkeeper update
        if(user.value.data.role.toLowerCase() == "shopkeeper"){
          var response = await ApiRepo.apiPost('api/profile/shopkeeper/update', shopkeeperData, 'Update shopkeeper');
          if(response != null && response['code'] == 201) {
            await getUserData(true);
            Get.back();
            showToast(isSuccess: true, message: "Profile Details Updated");
          }else{
            showToast(isSuccess: false, message: "Failed to update shopkeeper details");
          }
        }
        //technician update
        else if(user.value.data.role == "technician"){
          var response = await ApiRepo.apiPost('api/profile/technician/update', technicianData, 'Update technician');
          if(response != null && response['status'] == 200) {
            await getUserData(true);
            Get.back();
            showToast(isSuccess: true, message: "Profile Details Updated");
          }else{
            showToast(isSuccess: false, message: "Failed to update technician details");
          }
        }
        else{
          await getUserData(true);
          Get.back();
          showToast(isSuccess: true, message: "Profile Details Updated");
        }
      }
    }catch (e){
      log(e.toString());
    } finally{
      isProfileBtnLoading(false);
    }
  }

  //update bank
  updateBank({accName, accNum, bankName, branchName, esewaNum, khaltiNum}) async{
    var data = {
      "account_holder_name": accName,
      "account_number": accNum,
      "bank_name": bankName,
      "branch" : branchName,
      "esewa": esewaNum,
      "khalti" : khaltiNum
    };
    try{
      isBankBtnLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/profile/update-bank-details', data, 'Update Bank Details');
      if(response != null && response['code'] == 201) {
        await getUserData(true);
        Get.back();
        showToast(isSuccess: true, message: "Bank Details Updated");
      }
    }catch (e){
      log(e.toString());
    } finally{
      isBankBtnLoading(false);
    }
  }

  //cehckout prize
  checkOutPrize(redeemId, type) async {
    try{
      isChecoutLoading(true); // Start Loading
      var data = {
        "redeem_information_id" : redeemId,
        "customer_payment_option": type.toString().toLowerCase()
      };
      var response = await ApiRepo.apiPost('api/redeem-checkout-request', data, 'check out');
      if(response != null && response['code'] == 200) {
        await getUserData(true); // to update points without refreshing the page
        Get.back();
        showToast(isSuccess: true, message: response["message"]);
      }
    }catch (e){
      log(e.toString());
    } finally{
      isChecoutLoading(false);
    }
  }

  // Get Earning History
  getEarningHistory({startDate, endDate}) async{
    isEarningLoading(true);
    try{
      dynamic data = "";

      if(startDate != null && endDate!=null){
        data = {
          "start_date" : startDate,
          "end_date": endDate
        };
      }
      
      var response = await ApiRepo.apiGet('api/user/redeem-information', data, 'Get Earning History');
      if(response != null && response['code'] == 200) {
        var allData = ReturnProductModel.fromJson(response);
        earningList = allData.data;
      }
    }catch (e){
      log(e.toString());
    }
    finally{
      isEarningLoading(false);
    }
  }

  // Withdrawl Request
  getWithDrawlRequest({startDate, endDate}) async{
    isWithdrawalLoading(true);
    try{
      dynamic data = "";

      if(startDate != null && endDate!=null){
        data = {
          "start_date" : startDate,
          "end_date": endDate
        };
      }
      
      var response = await ApiRepo.apiGet('api/user/redeem-checkout-request-history', data, 'WithDrawl Request');
      if(response != null && response['code'] == 200) {
        var allData = WithdrawalRequestModel.fromJson(response);
        withdrawalList = allData.data;
      }
    }catch (e){
      log(e.toString());
    }
    finally{
      isWithdrawalLoading(false);
    }
  }


  //update shopkeeper
  updateshopkeeper({required shopName,required panNum,required ownerName,}) async{
    var data = {
      "shop_name": shopName,
      "pan_number": panNum,
      "owner_name": ownerName,
    };
    try{
      isshopkeeperLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/profile/shopkeeper/update', data, 'Update shopkeeper');
      if(response != null && response['code'] == 201) {
        showToast(isSuccess: true, message: "Updated");
      }
    }catch (e){
      log(e.toString());
    } finally{
      isshopkeeperLoading(false);
    }
  }

  //update technician
  updateTechnician(shopkeeperId) async{
    var data = {
      "shopkeeper_id": shopkeeperId,
    };
    try{
      isTechLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/technician/update', data, 'Update technician');
      if(response != null && response['code'] == 201) {
        Get.back();
        showToast(isSuccess: true, message: "Updated");
      }
    }catch (e){
      log(e.toString());
    } finally{
      isTechLoading(false);
    }
  }

 // Fetch shopkeeper list from API
  Future<void> getShopkeeperList() async {
    try {
      isshopkeeperIdLoading(true);
      shopkeeperIdNameMap.clear();
      
      var response = await ApiRepo.apiGet(
        'api/profile/vendors/records', 
        "", 
        'Get Vendor List'
      );
      
      if (response != null && response['code'] == 200) {
        if (response['data'] != null && response['data'] is List) {
          for (var allData in response["data"]) {
            String id = allData["user_id"]?.toString() ?? "";
            String name = allData["shop_name"]?.toString() ?? "";
            if (id.isNotEmpty) {
              shopkeeperIdNameMap[id] = name;
            }
          }
          log("Loaded ${shopkeeperIdNameMap.length} shopkeepers");
        }
      }
    } catch (e) {
      log("Error fetching shopkeepers: ${e.toString()}");
    } finally {
      isshopkeeperIdLoading(false);
    }
  }

  void addShopkeeperField() {
    shopkeeperIdControllers.add(TextEditingController());
    shopkeeperNames.add('');
    showNameDisplays.add(false);
    log("Added field, total: ${shopkeeperIdControllers.length}");
  }

  void removeShopkeeperField(int index) {
    if (index < shopkeeperIdControllers.length) {
      shopkeeperIdControllers[index].dispose();
      shopkeeperIdControllers.removeAt(index);
      shopkeeperNames.removeAt(index);
      showNameDisplays.removeAt(index);
    }
  }
  
  void filterShopkeepersById(String id, int index) {
    final trimmedId = id.trim();
    
    if (trimmedId.isEmpty) {
      shopkeeperNames[index] = '';
      showNameDisplays[index] = false;
      return;
    }

    if (shopkeeperIdNameMap.containsKey(trimmedId)) {
      shopkeeperNames[index] = shopkeeperIdNameMap[trimmedId]!;
      showNameDisplays[index] = true;
    } else {
      shopkeeperNames[index] = 'No shopkeeper found with this ID';
      showNameDisplays[index] = true;
    }
    
    log("Filtered ID $trimmedId: ${shopkeeperNames[index]}");
  }

  // Get CountryWise District Data
  Future<void> getDistrictData({required bool isNepal}) async {
    try {
      isDistrictLoading(true);
      districtList.clear();

      final response = await ApiRepo.apiGet(
        isNepal ? 'api/nepal' : 'api/india',
        "",
        'Get Districts List',
      );

      if (response != null && response['code'] == 200) {
        final data = response['data'];

        if (data is List && data.isNotEmpty) {
          final districts = data[0]['districts'];
          if (districts is List) {
            districtList = districts;
          }
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isDistrictLoading(false);
    }
  }
}