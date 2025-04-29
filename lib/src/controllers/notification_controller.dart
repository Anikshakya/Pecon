import 'dart:developer';

import 'package:get/get.dart';
import 'package:pecon/src/api_config/api_repo.dart';

class NotificationController extends GetxController{
  //loadings
  final RxBool isLoading = false.obs;

  List notificationList = [];

  //get ad banner
  getNotificationList() async {
    try{
      isLoading(true); // Start Loading
      var response = await ApiRepo.apiGet('notifications', "", 'Notification List Api');
      if(response != null && response['code'] == 200) {
        notificationList = response["data"] ?? [];
      }
    }catch (e){
      log(e.toString());
    } finally{
      isLoading(false); // Stop Loading
    }
  }
}