import 'dart:developer';

import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/app_config/read_write.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/services/notification_service.dart';
import 'package:pecon/src/view/dashboard.dart';
import 'package:get/get.dart';
import 'package:pecon/src/view/login.dart';
import 'package:pecon/src/view/otp_page.dart';
import 'package:pecon/src/view/reset_password_page.dart';
import 'package:pecon/src/widgets/custom_toast.dart';

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
    } else {
      Get.offAll(()=> const LoginPage());
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
        Get.offAll(()=>const Dashboard());
      }
    }catch (e){
      log(e.toString());
    } finally{
      isLoginLoading(false);
    }
  }

  // Register API
  register({name, number, password, role}) async {
    var data = {
      "name": name,
      "number": number,
      "password": password,
      "role": role.toString().toLowerCase()
    };
    try{
      isRegisterLoading(true); // Start Loading
      var response = await ApiRepo.apiPost('api/register', data, 'Register');
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
}