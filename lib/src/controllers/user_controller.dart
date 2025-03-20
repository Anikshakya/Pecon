import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/model/return_product_model.dart';
import 'package:pecon/src/model/user_profile_model.dart';
import 'package:pecon/src/widgets/custom_toast.dart';

class UserController extends GetxController {
  final RxBool isLoginLoading = false.obs;
  final RxBool isProfileBtnLoading = false.obs;
  final RxBool isBankBtnLoading = false.obs;
  final RxBool isProfileLoading = false.obs;
  final RxBool isAddressLoading = false.obs;
  final RxBool isChecoutLoading = false.obs;
  final RxBool isEarningLoading = false.obs;
  final RxBool isshopkeeperLoading  = false.obs;
  final RxBool isTechLoading    = false.obs;

  // Logged In User Data
  var user = UserModel().obs;

  //Lists
  dynamic districtList = [];
  dynamic cityList = [];
  dynamic earningList = [];

  // Get Logged In User Profile
  getUserData() async{
    try{
      isProfileLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('api/profile', "", 'User Profile API');
      if(response != null && response['code'] == 200) {
        user.value = UserModel.fromJson(response);
        return user;
      }
    }catch (e){
      isProfileLoading(false); // Stop Loading
    } finally{
      isProfileLoading(false); // Stop Loading
    }
  }

  //update profile
  updateProfile({name, number, email, gender, dob, city, district, address, image, shopName, panNum, ownerName, shopkeeperId, displayPrice}) async{
    dynamic finaldata;
    if(image == null){
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
            await getUserData();
            Get.back();
            showToast(isSuccess: true, message: "Profile Details Updated");
          }else{
            showToast(isSuccess: false, message: "Failed to update shopkeeper details");
          }
        }
        //technician update
        else if(user.value.data.role == "technician"){
          var response = await ApiRepo.apiPost('api/profile/technician/update', technicianData, 'Update technician');
          if(response != null && response['code'] == 201) {
            await getUserData();
            Get.back();
            showToast(isSuccess: true, message: "Profile Details Updated");
          }else{
            showToast(isSuccess: false, message: "Failed to update technician details");
          }
        }
        else{
          await getUserData();
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
        await getUserData();
        Get.back();
        showToast(isSuccess: true, message: "Bank Details Updated");
      }
    }catch (e){
      log(e.toString());
    } finally{
      isBankBtnLoading(false);
    }
  }

  // Get District List
  getDistrictData() async{
    try{
      isAddressLoading(true);
      districtList.clear();
      var response = await ApiRepo.apiGet('api/districts', "", 'Get Districts List');
      if(response != null && response['code'] == 200) {
        if(response["data"] != null && response["data"] != []){
          for(var allData in response["data"]){
            districtList.add({"name" : allData["name"] ?? "", "id" : allData["id"]});
          }
        }
      }
    }catch (e){
      log(e.toString());
    }
  }

  // Get city List
  getcityData() async{
    try{
      cityList.clear();
      var response = await ApiRepo.apiGet('api/city', "", 'Get city List');
      if(response != null && response['code'] == 200) {
        if(response["data"] != null && response["data"] != []){
          for(var allData in response["data"]){
            cityList.add({"name" : allData["name"] ?? "", "id" : allData["district_id"]});
          }
        }
      }
    }catch (e){
      log(e.toString());
    }
    finally{
      isAddressLoading(false);
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
        await getUserData(); // to update points without refreshing the page
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
      var response = await ApiRepo.apiGet('api/user/redeem-information', "", 'Get Earning History');
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
}