import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/view/dashboard.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Get Controllers 
  AppController appCon = Get.put(AppController());
  
  final RxBool isLoginLoading = false.obs;

  void startLoginLoading() {
    isLoginLoading.value = true;
  }

  void stopLoginLoading() {
    isLoginLoading.value = false;
  }

  Future<void> login() async {
    startLoginLoading();
    await Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(()=>const Dashboard());
      appCon.showAdDialog();
      stopLoginLoading();
    });
  }
}