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

/// ============================
/// Splash Media Type
/// ============================
enum SplashMediaType { image, video, unknown }

class AppController extends GetxController {
  // ============================
  // Storage
  // ============================
  final GetStorage box = GetStorage();
  static const String _splashUrlKey = 'splash_url';
  static const String _splashTypeKey = 'splash_type';

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
  String tiktok = "";
  String instagram = "";
  String youtube = "";

  // ============================
  // Ad Banner
  // ============================
  String adBanner = "";

  // ============================
  // Splash Media
  // ============================
  String splashUrl = "";
  SplashMediaType splashMediaType = SplashMediaType.unknown;

  String cachedSplashVideoPath = "";
  String cachedSplashImagePath = "";

  // ============================
  // Polling
  // ============================
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
        tiktok = response["data"]["tiktok_link"] ?? "";
        instagram = response["data"]["instagram_link"] ?? "";
        youtube = response["data"]["youtube_link"] ?? "";

        final launcher = response["data"]["lunch_screen_image"] ?? "";
        if (launcher.isEmpty) return false;

        splashUrl = launcher;
        splashMediaType = _detectSplashMediaType(launcher);

        return splashMediaType != SplashMediaType.unknown;
      }
    } catch (e) {
      log("Setting API Error: $e");
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
      log("Ad Banner Error: $e");
    } finally {
      isBannerLoading(false);
    }
  }

  // ============================
  // AD DIALOG
  // ============================
  Future<void>? showAdDialog() async {
    await getAdBanner();
    if (adBanner.isEmpty) return;

    return Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Obx(
              () => Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
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
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ============================
  // SPLASH MEDIA CACHE
  // ============================
  Future<void> cacheSplashMedia() async {
    final storedUrl = box.read(_splashUrlKey);
    final storedType = box.read(_splashTypeKey);

    // SAME URL + SAME TYPE → reuse cache
    if (storedUrl == splashUrl &&
        storedType == splashMediaType.name) {
      final dir = await getTemporaryDirectory();

      if (splashMediaType == SplashMediaType.video) {
        final file = File("${dir.path}/splash_video.mp4");
        if (file.existsSync()) {
          cachedSplashVideoPath = file.path;
          return;
        }
      }

      if (splashMediaType == SplashMediaType.image) {
        final file = File("${dir.path}/splash_image");
        if (file.existsSync()) {
          cachedSplashImagePath = file.path;
          return;
        }
      }
    }

    // DIFFERENT URL OR TYPE → clear old & cache new
    await _clearOldSplashCache();

    if (splashMediaType == SplashMediaType.video) {
      await _cacheSplashVideo(splashUrl);
    } else if (splashMediaType == SplashMediaType.image) {
      await _cacheSplashImage(splashUrl);
    }

    box.write(_splashUrlKey, splashUrl);
    box.write(_splashTypeKey, splashMediaType.name);
  }

  Future<void> _cacheSplashVideo(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/splash_video.mp4";
      final file = File(filePath);

      if (file.existsSync()) file.deleteSync();

      await Dio().download(url, filePath);
      cachedSplashVideoPath = filePath;
    } catch (e) {
      log("Splash video cache failed: $e");
    }
  }

  Future<void> _cacheSplashImage(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/splash_image";

      final file = File(filePath);
      if (file.existsSync()) file.deleteSync();

      await Dio().download(url, filePath);
      cachedSplashImagePath = filePath;
    } catch (e) {
      log("Splash image cache failed: $e");
    }
  }

  Future<void> _clearOldSplashCache() async {
    final dir = await getTemporaryDirectory();

    final video = File("${dir.path}/splash_video.mp4");
    final image = File("${dir.path}/splash_image");

    if (video.existsSync()) video.deleteSync();
    if (image.existsSync()) image.deleteSync();
  }

  // ============================
  // SPLASH POLLING
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
        await cacheSplashMedia();
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
  // MEDIA TYPE DETECTION
  // ============================
  SplashMediaType _detectSplashMediaType(String url) {
    final lower = url.toLowerCase();

    if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mkv')) {
      return SplashMediaType.video;
    }

    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp')) {
      return SplashMediaType.image;
    }

    return SplashMediaType.unknown;
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
