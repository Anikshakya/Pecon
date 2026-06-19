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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecon_app/src/api_config/api_repo.dart';
import 'package:pecon_app/src/app_config/constant.dart';
import 'package:pecon_app/src/app_config/read_write.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/user_controller.dart';
import 'package:pecon_app/src/widgets/custom_network_image.dart';
import 'package:version/version.dart';

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
  RxString version = ''.obs;

  final RxBool isBannerLoading = false.obs;
  var adBannerNepal = "";
  var adBannerIndia = "";

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
  String redeemImageNp = "";
  String redeemImageIn = "";

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
    // ignore: unrelated_type_equality_checks
    return result != ConnectivityResult.none;
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return version(packageInfo.version);
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
      // 1️⃣ CHECK UPDATE (NON-BLOCKING)
      try {
        final newVersion = NewVersionPlus(
          iOSId: iOSPackageName,
          iOSAppStoreCountry: 'JP',
          androidId: androidAppBundleId,
          androidPlayStoreCountry: 'JP',
        );

        final status = await newVersion.getVersionStatus();

        if (status != null) {
          installedFileName = status.localVersion;
          latestFileName = status.storeVersion;

          final updateAvailable = await _isUpdateAvailableCheck();
          if (updateAvailable) {
            _openStore();
            // _showUpdateDialog();
            return AppStartResult.blockedByUpdate;
            // DO NOT return here → allow app to continue
          }
        }
      } catch (e, s) {
        log("Update check failed, continuing app start: $e");
        log("$s");
      }

      // 2️⃣ SETTINGS + SPLASH (ALWAYS RUN)
      try {
        final ok = await getSettingApi();
        if (ok) {
          await cacheSplashMedia();
          return AppStartResult.playSplash;
        }
      } catch (e) {
        log("Settings/Splash error: $e");
      }
    }


    // ----------------------------
    // OFFLINE / FALLBACK
    // ----------------------------
    if (await _loadCachedSplash()) {
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
        redeemImageNp = response["data"]["redeem_information_image"] ?? "";
        redeemImageIn = response["data"]["redeem_information_image_in"] ?? "";

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


  Future<bool> _loadCachedSplash() async {
    final dir = await getTemporaryDirectory();

    final video = File("${dir.path}/splash_video.mp4");
    if (await video.exists()) {
      cachedSplashVideoPath = video.path;
      splashMediaType = SplashMediaType.video;
      return true;
    }

    final image = File("${dir.path}/splash_image.jpg");
    if (await image.exists()) {
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
          title: Text('There is a Latest Version Avialable for the App'.tr),
          content: Text('Please Install The Latest Version To Procees'.tr),
          actions: [
            CupertinoDialogAction(
              child: Text('Update App'.tr),
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
    final UserController userCon = Get.put(UserController());
    await getAdBanner();
    if (adBannerNepal.isEmpty) return;

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
                            imageUrl: userCon.isNepaliUser.value == true ? adBannerNepal: adBannerIndia,
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
        final List<dynamic> banners = response['data'] ?? [];

        adBannerNepal = banners
            .firstWhere(
              (e) => e['country'] == 'nepal',
              orElse: () => {},
            )['image'] ??
            '';

        adBannerIndia = banners
            .firstWhere(
              (e) => e['country'] == 'india',
              orElse: () => {},
            )['image'] ??
            '';
      }
    } catch (e) {
      log("Ad Banner Error: $e");
    } finally {
      isBannerLoading(false);
    }
  }

  // Send App Update to server
  Future<void> sendAppUpdate() async {
    try {

      var data = {
        "app_version": await getAppVersion(),
      };

      final response =  await ApiRepo.apiPost('api/profile/update_apps_version', data, 'UpdateAppVersionAPI');

      if (response != null && response['code'] == 201) {
      }
    } catch (e) {
      log("Ad Banner Error: $e");
    }
  }

  onlineApi(onlineValue) async{
    try{
      var data = {
        "is_online" : onlineValue
      };
      if(read("token") != "" && read("token") != null){
        var response = await ApiRepo.apiPost('api/is_online', data, 'ONLIN API');
        if(response != null && response['code'] == 200) {
        }
      }
    }catch (e){
      log(e.toString());
    }
  }
}
