import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/model/user_profile_model.dart';
import 'package:pecon/src/widgets/custom_toast.dart';

class UserController extends GetxController {
  final RxBool isLoginLoading = false.obs;
  final RxBool isProfileBtnLoading = false.obs;
  final RxBool isBankBtnLoading = false.obs;
  final RxBool isProfileLoading = false.obs;
  final RxBool isAddressLoading = false.obs;

  // Logged In User Data
  var user = UserModel().obs;

  //Lists
  dynamic districtList = [];
  dynamic cityList = [];

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
  updateProfile({name, number, email, gender, dob, city, district, address}) async{
    var data = {
      "name": name,
      "phone": number,
      "alternate_number": number,
      "email": email,
      "district_id" : district,
      "address" : address,
      "city_id" : city,
      "gender": gender,
      "dob" : dob
    };
    try{
      isProfileBtnLoading(true);// Start Loading
      var response = await ApiRepo.apiPost('api/profile/update', data, 'Update Profile');
      if(response != null && response['code'] == 201) {
        await getUserData();
        Get.back();
        showToast(isSuccess: true, message: "Profile Details Updated");
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
            cityList.add({"name" : allData["name"] ?? "", "id" : allData["id"]});
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
}