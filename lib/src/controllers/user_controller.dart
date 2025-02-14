import 'package:get/get.dart';
import 'package:pecon/src/app_config/read_write.dart';

class UserController extends GetxController {
  final RxBool isLoginLoading = false.obs;
  int userPoints = read("user") != "" ? read("user")["earned_points"] ?? 0 : 0;
  String userImage = read("user") != ""? read("user")["profile_url"] ?? "https://images.squarespace-cdn.com/content/v1/56c346b607eaa09d9189a870/1551408857522-4ZFG11B2M7UPFYBFBRO0/FLAUNT-MAGAZINE-JOJI-2.jpg" : "https://images.squarespace-cdn.com/content/v1/56c346b607eaa09d9189a870/1551408857522-4ZFG11B2M7UPFYBFBRO0/FLAUNT-MAGAZINE-JOJI-2.jpg";
  String userName = read("user") != "" ? read("user")["name"] ?? "N/A" : "N/A";
  String userId =  read("user") != "" ? read("user")["id"].toString() != "null" ? read("user")["id"].toString() : "N/A" : "N/A";
  String userNumber = read("user") != "" ? read("user")["number"].toString() != "null" ? read("user")["number"].toString() : "N/A" : "N/A";

  void startLoginLoading() {
    isLoginLoading.value = true;
  }

  void stopLoginLoading() {
    isLoginLoading.value = false;
  }
}