import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:pecon_app/src/api_config/api_repo.dart';
import 'package:pecon_app/src/app_config/read_write.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';
import 'package:pecon_app/src/services/notification_service.dart';
import 'package:pecon_app/src/view/dashboard.dart';
import 'package:pecon_app/src/view/login.dart';
import 'package:pecon_app/src/view/otp_page.dart';
import 'package:pecon_app/src/view/reset_password_page.dart';
import 'package:pecon_app/src/view/role_selection_page.dart';
import 'package:pecon_app/src/widgets/custom_toast.dart';

class AuthController extends GetxController {
  // Get Controllers 
  AppController appCon = Get.put(AppController());
  
  // Loading Helper
  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;
  final RxBool isLogOutLoading = false.obs;
  final RxBool isChangePasswordLoading = false.obs;
  final RxBool isForgotPassLoading = false.obs;
  final RxBool isOPTLoading = false.obs;
  final RxBool isResetPassLoading = false.obs;

  // Check User Authentication Status
  checkUserAuthStatus() async{
    var token = await read("token");
    if(token != null && token != ""){
      Get.offAll(()=> const Dashboard());
    } else if (read('hasLoggedOut') == true){
      Get.offAll(() => const RoleSelectionPage());
    } else {
      Get.offAll(()=> const RoleSelectionPage());
    }
  }

  // Login API
  login({number, password}) async {
    var data = {
      "number": number,
      "password": password
    };
    try{
      isLoginLoading(true); // Start Loading
      var response = await ApiRepo.apiPost('api/login', data, 'Login');
      if(response != null && response['code'] == 200) {
        write("token", response['data']['token']);
        // Store FCM
        var fcm = await NotificationService.getFcmToken();
        await storeFcm(fcm);

        // Store Necesssary Data
        write("user", response['data']['user']);

        isLoginLoading(false); // Stop Loading
        if(response['data']['user']['role'].toLowerCase() == "shopkeeper" && response['data']['user']['status'] == 0){
          invaliduserDialog();
        } else {
          Get.offAll(()=> const Dashboard());
        }
      }
    }catch (e){
      log(e.toString());
    } finally{
      isLoginLoading(false);
    }
  }

  // Register API
  register({name, number, password, role, district, city, shopName, shopPan,required profile}) async {
    var data = {
      "name": name,
      "number": number,
      "password": password,
      "role": role.toString().toLowerCase(),
      "district_id" : district,
      "city_id": city,
      "profile" : await MultipartFile.fromFile(profile.path, filename: profile.path.split('/').last),
      if(shopName != "")"shop_name": shopName,
      if (shopPan != "") "pan_number": shopPan,
    };

    var finalData = FormData.fromMap(data);
    try{
      isRegisterLoading(true); // Start Loading
      var response = await ApiRepo.apiPost('api/register', profile == null ? data : finalData, 'Register');
      if(response != null && response['code'] == 201) {
        isRegisterLoading(false); // Stop Loading
        Get.offAll(()=>const LoginPage());
      }
    }catch (e){
      log(e.toString());
    } finally{
      isRegisterLoading(false);
    }
  }

  // Change password
  changePassword({currentPass, newPass, newPassConfirm}) async{
     var data = {
      "current_password": currentPass,
      "new_password": newPass,
      "new_password_confirmation": newPassConfirm
    };
    try{
      isChangePasswordLoading (true);// Start Loading
      var response = await ApiRepo.apiPost('api/change-password', data, 'Change Password');
      if(response != null && response['code'] == 201) {
        Get.offAll(const LoginPage());
        showToast(message: response['message'], isSuccess: true);
      }
    }catch (e){
      log(e.toString());
    } finally{
      isChangePasswordLoading(false);
    }
  }

  // Forgot password
  forgotPassword({mobileNo}) async{
     var data = {
      "number": mobileNo,
    };
    try{
      isForgotPassLoading (true);// Start Loading
      var response = await ApiRepo.apiPost('api/send-otp', data, 'Send OTP');
      if(response != null && response['code'] == 201) {
        Get.to(()=> OTPPage(
          number: mobileNo,
        ));
        showToast(message: response['message'], isSuccess: true);
      }
    }catch (e){
      log(e.toString());
    } finally{
      isForgotPassLoading(false);
    }
  }

  // OTP
  verifyOTP({otp, number}) async{
     var data = {
      "otp_token": otp,
      "number" : number
    };
    try{
      isOPTLoading (true);// Start Loading
      var response = await ApiRepo.apiPost('api/verify-otp', data, 'Verify OTP');
      if(response != null && response['code'] == 201) {
        Get.to(()=> ResetPassword(
          number: number,
        ));
        showToast(message: response['message'], isSuccess: true);
      }
    }catch (e){
      log(e.toString());
    } finally{
      isOPTLoading(false);
    }
  }

  // Reset Password
  resetPassword({number, confirmPass}) async{
     var data = {
      "number": number,
      "confirm_password": confirmPass,
    };
    try{
      isResetPassLoading (true);// Start Loading
      var response = await ApiRepo.apiPost('api/reset-password', data, 'Reset Password');
      if(response != null && response['code'] == 201) {
        Get.offAll(const LoginPage());
        showToast(message: response['message'], isSuccess: true);
      }
    }catch (e){
      log(e.toString());
    } finally{
      isResetPassLoading(false);
    }
  }

  // Store Fcm API
  storeFcm(fcm) async{
    var data = {
      "fcm_token": fcm ?? ""
    };
    try{
      var response = await ApiRepo.apiPost('api/profile/update-fcm-token', data, 'Store FCM');
      if(response != null && response['code'] == 200) {
        showToast(message: response['message'], isSuccess: true);
      }
    }catch (e){
      log(e.toString());
    }
  }

  // Logout API
  logout() async {
    try{
      isLogOutLoading(true); // Start Loading
      var response = await ApiRepo.apiPost('api/logout', "", 'Logout');
      if(response != null && response['code'] == 200) {
        isLogOutLoading(false); // Stop Loading
        write('hasLoggedOut', true);
        // Remove All stored 
        clearAllData();
        Get.offAll(()=>const LoginPage());
      }
    }catch (e){
      log(e.toString());
    } finally{
      isLogOutLoading(false);
    }
  }

// Invalid User Alert Dialog Box
  invaliduserDialog() {
    Get.dialog(
      barrierDismissible: false, // Correct placement to prevent closing on outside tap
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Stack(
            children: [
              // Top Right Close Button
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => Get.back(), // Closes the GetX dialog
                  child: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
              
              // Dialog Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16), // Spacer for the close icon row
                  Icon(
                    Icons.shield_outlined, 
                    color: Colors.red.shade500, 
                    size: 48
                  ),
                  const SizedBox(height: 16),
                  
                  // English Text
                  const Text(
                    "QR scan only. Your account is not verified yet. After verification, you can access all app features.\nContact this number for account verification: +977-XXXXXXXXXX",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87, 
                      fontSize: 14, 
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  // Divider
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Divider(color: Colors.black12, height: 1),
                  ),
                  
                  // Nepali Text
                  const Text(
                    "QR स्क्यान मात्र अनुमति छ। तपाईंको खाता अझै प्रमाणित भएको छैन। प्रमाणित भएपछि एपका सबै सुविधा प्रयोग गर्न सक्नुहुन्छ।\nप्रमाणिकरणका लागि यस नम्बरमा सम्पर्क गर्नुहोस्: +977-XXXXXXXXXX",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87, 
                      fontSize: 14, 
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}