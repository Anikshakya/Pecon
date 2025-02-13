import 'dart:developer';

import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/app_config/read_write.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/view/dashboard.dart';
import 'package:get/get.dart';
import 'package:pecon/src/view/login.dart';

class AuthController extends GetxController {
  // Get Controllers 
  AppController appCon = Get.put(AppController());
  
  // Loading Helper
  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;
  final RxBool isLogOutLoading = false.obs;

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
        // Store Necesssary Data
        write("token", response['data']['token']);
        write("user", response['data']['user']);

        isLoginLoading(false); // Stop Loading
        Get.offAll(()=>const Dashboard());
        appCon.showAdDialog();
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
      if(response != null && response['code'] == 200) {
        isRegisterLoading(false); // Stop Loading
        Get.offAll(()=>const LoginPage());
      }
    }catch (e){
      log(e.toString());
    } finally{
      isRegisterLoading(false);
    }
  }

  // Register API
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