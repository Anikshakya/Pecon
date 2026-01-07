import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:open_store/open_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:version/version.dart';

import 'package:pecon/src/api_config/api_repo.dart';
import 'package:pecon/src/app_config/constant.dart';

/// ============================
/// Splash Media Type
/// ============================
enum SplashMediaType { image, video, unknown }

/// ============================
/// App Start Result
/// ============================
enum AppStartResult {
  blockedByUpdate,
  playSplash,
  playCachedSplash,
  routeImmediately,
}

class AppController extends GetxController {
  // ============================
  // UPDATE STATE
  // ============================
  RxBool isUpdateAvailable = false.obs;
  Version? installedVersion;
  Version? latestVersion;
  String? installedFileName;
  String? latestFileName;

  final RxBool isBannerLoading = false.obs;
  var adBanner = "";

  // ============================
  // STORAGE
  // ============================
  final GetStorage box = GetStorage();
  static const String _splashUrlKey = 'splash_url';
  static const String _splashTypeKey = 'splash_type';

  // ============================
  // LOADERS
  // ============================
  final RxBool isLoading = false.obs;

  // ============================
  // SETTINGS
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
  // SPLASH MEDIA
  // ============================
  String splashUrl = "";
  SplashMediaType splashMediaType = SplashMediaType.unknown;

  String cachedSplashVideoPath = "";
  String cachedSplashImagePath = "";

  // ============================
  // INTERNET CHECK
  // ============================
  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // ============================
  // APP START FLOW (MASTER)
  // ============================
  Future<AppStartResult> startApp() async {
    final hasNet = await hasInternet();

    // ----------------------------
    // ONLINE FLOW
    // ----------------------------
    if (hasNet) {
      try {
        // // 1️⃣ CHECK UPDATE
        // final newVersion = NewVersionPlus(
        //   iOSId: iOSPackageName,
        //   iOSAppStoreCountry: 'JP',
        //   androidId: androidAppBundleId,
        //   androidPlayStoreCountry: 'JP',
        // );

        // final status = await newVersion.getVersionStatus();

        // if (status != null) {
        //   installedFileName = status.localVersion;
        //   latestFileName = status.storeVersion;

        //   final updateAvailable = await _isUpdateAvailableCheck();
        //   if (updateAvailable) {
        //     _showUpdateDialog();
        //     return AppStartResult.blockedByUpdate;
        //   }
        // }

        // 2️⃣ SETTINGS + SPLASH
        final ok = await getSettingApi();
        if (ok) {
          await cacheSplashMedia();
          return AppStartResult.playSplash;
        }
      } catch (e) {
        log("StartApp error: $e");
      }
    }

    // ----------------------------
    // OFFLINE / FALLBACK
    // ----------------------------
    if (_loadCachedSplash()) {
      return AppStartResult.playCachedSplash;
    }

    return AppStartResult.routeImmediately;
  }

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
      log("Settings API Error: $e");
    } finally {
      isLoading(false);
    }
    return false;
  }

  // ============================
  // SPLASH CACHE
  // ============================
  Future<void> cacheSplashMedia() async {
    final storedUrl = box.read(_splashUrlKey);
    final storedType = box.read(_splashTypeKey);

    final dir = await getTemporaryDirectory();

    final videoFile = File("${dir.path}/splash_video.mp4");
    final imageFile = File("${dir.path}/splash_image.jpg");

    /// ✅ Use existing cache if same media
    if (storedUrl == splashUrl && storedType == splashMediaType.name) {
      if (splashMediaType == SplashMediaType.video &&
          await videoFile.exists()) {
        cachedSplashVideoPath = videoFile.path;
        return;
      }

      if (splashMediaType == SplashMediaType.image &&
          await imageFile.exists()) {
        cachedSplashImagePath = imageFile.path;
        return;
      }
    }

    /// 🧹 Clear old cache safely
    await _clearOldSplashCache(videoFile, imageFile);

    /// ⬇️ Cache new media
    if (splashMediaType == SplashMediaType.video) {
      await _cacheSplashVideo(splashUrl, videoFile);
      cachedSplashVideoPath = videoFile.path;
    } else if (splashMediaType == SplashMediaType.image) {
      await _cacheSplashImage(splashUrl, imageFile);
      cachedSplashImagePath = imageFile.path;
    }

    /// 💾 Save cache metadata
    box.write(_splashUrlKey, splashUrl);
    box.write(_splashTypeKey, splashMediaType.name);
  }


    Future<void> _cacheSplashVideo(String url, File file) async { 
    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    await file.writeAsBytes(response.data!);
  }


  Future<void> _cacheSplashImage(String url, File file) async {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    await file.writeAsBytes(response.data!);
  }


    Future<void> _clearOldSplashCache(
    File videoFile,
    File imageFile,
  ) async {
    if (await videoFile.exists()) {
      await videoFile.delete();
    }

    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }


  bool _loadCachedSplash() {
    final dir = Directory.systemTemp;

    final video = File("${dir.path}/splash_video.mp4");
    if (video.existsSync()) {
      cachedSplashVideoPath = video.path;
      splashMediaType = SplashMediaType.video;
      return true;
    }

    final image = File("${dir.path}/splash_image");
    if (image.existsSync()) {
      cachedSplashImagePath = image.path;
      splashMediaType = SplashMediaType.image;
      return true;
    }

    return false;
  }

  // ============================
  // UPDATE CHECK
  // ============================
  Future<bool> _isUpdateAvailableCheck() async {
    installedVersion = Version.parse(installedFileName!);
    latestVersion = Version.parse(latestFileName!);

    if (latestVersion! > installedVersion!) {
      isUpdateAvailable(true);
      return true;
    }

    isUpdateAvailable(false);
    return false;
  }

  void _showUpdateDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: CupertinoAlertDialog(
          title: Text('updateAvailable'.tr),
          content: Text('installLatest'.tr),
          actions: [
            CupertinoDialogAction(
              child: Text('はい'.tr),
              onPressed: () => _openStore(),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _openStore() {
    OpenStore.instance.open(
      appStoreId: appStoreId,
      androidAppBundleId: androidAppBundleId,
    );
  }

  // ============================
  // MEDIA TYPE DETECTION
  // ============================
  SplashMediaType _detectSplashMediaType(String url) {
    final lower = url.toLowerCase();

    if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm')) {
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
}
