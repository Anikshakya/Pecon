import 'package:get/get.dart';
import 'package:pecon/src/app_config/read_write.dart';

class UserController extends GetxController {
  final RxBool isLoginLoading = false.obs;
  int userPoints = 5000;
  String userImage = "https://images.squarespace-cdn.com/content/v1/56c346b607eaa09d9189a870/1551408857522-4ZFG11B2M7UPFYBFBRO0/FLAUNT-MAGAZINE-JOJI-2.jpg";
  String userName = read("user")["name"] ?? "";
  String userId = read("user")["id"].toString();

  void startLoginLoading() {
    isLoginLoading.value = true;
  }

  void stopLoginLoading() {
    isLoginLoading.value = false;
  }
}