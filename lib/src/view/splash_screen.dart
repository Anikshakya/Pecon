import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authCon = Get.put(AuthController());
  final AppController appCon = Get.put(AppController());

  VideoPlayerController? _videoController;

  bool _calledNext = false;
  bool _isSwitchingVideo = false;
  bool _usingAsset = true;

  @override
  void initState() {
    super.initState();

    _loadAssetVideo();

    appCon.startSplashVideoPolling(
      onResolved: () async {
        if (!mounted) return;

        if (appCon.cachedSplashVideoPath.isNotEmpty) {
          await _trySwitchToCachedVideo();
        }
      },
    );
  }

  // ============================
  // LOAD ASSET (ALWAYS SAFE)
  // ============================
  void _loadAssetVideo() {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/video/splash_video.mp4',
      )..initialize().then((_) {
          if (!mounted) return;

          setState(() {});
          _videoController!
            ..setVolume(1.0)
            ..play();
        });

      _videoController!.addListener(_videoListener);
    } catch (_) {
      // Asset failure is unrecoverable — allow app to continue
    }
  }

  // ============================
  // TRY SWITCH TO CACHED VIDEO
  // ============================
  Future<void> _trySwitchToCachedVideo() async {
    if (_isSwitchingVideo || !_usingAsset) return;

    final file = File(appCon.cachedSplashVideoPath);

    if (!file.existsSync()) return;

    _isSwitchingVideo = true;

    try {
      _videoController?.removeListener(_videoListener);
      await _videoController?.dispose();

      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      if (!mounted) return;

      _videoController = controller;
      _usingAsset = false;

      setState(() {});
      _videoController!
        ..setVolume(1.0)
        ..play();

      _videoController!.addListener(_videoListener);
    } catch (e) {
      // Any failure → revert to asset
      _isSwitchingVideo = false;
      _usingAsset = true;
      _loadAssetVideo();
    }
  }

  // ============================
  // VIDEO END LISTENER
  // ============================
  void _videoListener() async {
    if (_videoController == null) return;

    final value = _videoController!.value;

    if (value.isInitialized &&
        value.position >= value.duration &&
        !_calledNext) {
      _calledNext = true;

      await authCon.checkUserAuthStatus();
    }
  }

  // ============================
  // CLEANUP
  // ============================
  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: _videoController != null && _videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : const SizedBox(),
      ),
    );
  }
}
