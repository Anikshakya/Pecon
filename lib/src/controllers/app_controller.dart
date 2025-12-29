import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:permission_handler/permission_handler.dart';

class AppController extends GetxController {
  // ============================
  // Storage
  // ============================
  final GetStorage box = GetStorage();
  static const String _splashVideoUrlKey = 'splash_video_url';

  // ============================
  // Loaders
  // ============================
  final RxBool isLoading = false.obs;
  final RxBool isBannerLoading = false.obs;

  // ============================
  // General Settings
  // ============================
  String webUrl = "";
  String phoneLink = "";
  String fbLink = "";
  String termsCondition = "";
  String privacyPolicy = "";

  // ============================
  // Ad Banner
  // ============================
  String adBanner = "";

  // ============================
  // Splash Video
  // ============================
  String splashVideoUrl = "";
  String cachedSplashVideoPath = "";

  Timer? _pollingTimer;
  int _pollCount = 0;

  static const int maxPollAttempts = 6;
  static const Duration pollInterval = Duration(seconds: 5);

  // ============================
  // SETTINGS API
  // ============================
  Future<bool> getSettingApi() async {
    try {
      isLoading(true);

      final response =
          await ApiRepo.apiGet('api/settings', "", 'SettingApiAPI');

      if (response != null && response['code'] == 200) {
        webUrl = response["data"]["website_link"] ?? "";
        termsCondition = response["data"]["terms_and_condition"] ?? "";
        privacyPolicy = response["data"]["privacy_policy"] ?? "";
        phoneLink = response["data"]["phone"] ?? "";
        fbLink = response["data"]["facebook_link"] ?? "";

        final newSplashUrl = response["data"]["splash_video"] ?? "";

        if (newSplashUrl.isEmpty) return false;

        splashVideoUrl = newSplashUrl;
        return true;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
    return false;
  }

  // ============================
  // AD BANNER API
  // ============================
  Future<void> getAdBanner() async {
    try {
      isBannerLoading(true);

      final response =
          await ApiRepo.apiGet('api/ads_banner', "", 'SettingApiAPI');

      if (response != null && response['code'] == 200) {
        adBanner = response["data"]?["image"] ?? "";
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isBannerLoading(false);
    }
  }

  // ============================
  // AD DIALOG
  // ============================
  Future<void>? showAdDialog() async {
    await getAdBanner();

    if (adBanner.isEmpty) return null;

    return Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.sp, vertical: 12.sp),
                    child: SizedBox(
                      height: 500.h,
                      width: double.infinity,
                      child: isBannerLoading.value
                          ? Container(
                              decoration: BoxDecoration(
                                color: gray,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CustomNetworkImage(
                                imageUrl: adBanner,
                                borderRadius: 10,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 4,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const CircleAvatar(
                      backgroundColor: white,
                      radius: 16,
                      child: Icon(Icons.close, color: black, size: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ============================
  // SPLASH VIDEO CACHE
  // ============================
  Future<void> _cacheSplashVideo(String url) async {
    try {
      // Request storage permission (only for Android)
      if (Platform.isAndroid) {
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
      }

      // Get the appropriate directory for saving the file
      Directory directory = await _getSaveDirectory();

      // Ensure the directory exists
      
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        debugPrint("Directory created: ${directory.path}");
      }


      final storedUrl = box.read(_splashVideoUrlKey);
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/splash_video.mp4";
      final file = File(filePath);

      // Same URL & file exists → skip download
      if (storedUrl == url && file.existsSync()) {
        cachedSplashVideoPath = filePath;
        return;
      }

      // URL changed → clear old cache
      if (file.existsSync()) {
        file.deleteSync();
      }

      await Dio().download(url, filePath);

      cachedSplashVideoPath = filePath;
      box.write(_splashVideoUrlKey, url);
    } catch (e) {
      log("Splash video download failed: $e");
    }
  }

   /// Gets the appropriate directory for saving files based on the platform.
  Future<Directory> _getSaveDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      // For iOS, save to the application's documents directory
      return await getApplicationDocumentsDirectory();
    }
    // Throw an error for unsupported platforms
    throw UnsupportedError("Unsupported platform");
  }

  // ============================
  // SPLASH VIDEO POLLING
  // ============================
  void startSplashVideoPolling({
    required VoidCallback onResolved,
  }) {
    _pollingTimer?.cancel();
    _pollCount = 0;

    _pollingTimer = Timer.periodic(pollInterval, (timer) async {
      _pollCount++;

      final resolved = await getSettingApi();

      if (resolved) {
        await _cacheSplashVideo(splashVideoUrl);
        timer.cancel();
        onResolved();
        return;
      }

      if (_pollCount >= maxPollAttempts) {
        timer.cancel();
        onResolved();
      }
    });
  }

  // ============================
  // CLEANUP
  // ============================
  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }
}
