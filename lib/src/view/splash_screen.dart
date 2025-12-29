import 'dart:async';
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
  Timer? _imageTimer;

  bool _calledNext = false;
  bool _usingAssetVideo = true;

  @override
  void initState() {
    super.initState();

    // Always start with asset video (safe fallback)
    _loadAssetVideo();

    // Poll backend
    appCon.startSplashVideoPolling(
      onResolved: () async {
        if (!mounted) return;

        if (appCon.splashMediaType == SplashMediaType.image &&
            appCon.cachedSplashImagePath.isNotEmpty) {
          _showImageAndNavigate();
        } else if (appCon.splashMediaType == SplashMediaType.video &&
            appCon.cachedSplashVideoPath.isNotEmpty) {
          await _switchToCachedVideo();
        }
      },
    );
  }

  // ============================
  // ASSET VIDEO (FALLBACK)
  // ============================
  void _loadAssetVideo() {
    _videoController?.dispose();

    _videoController =
        VideoPlayerController.asset('assets/video/splash_video.mp4')
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() {});
            _videoController!
              ..setVolume(1.0)
              ..play();
          });

    _videoController!.addListener(_videoListener);
  }

  // ============================
  // SWITCH TO CACHED VIDEO
  // ============================
  Future<void> _switchToCachedVideo() async {
    if (!_usingAssetVideo) return;

    final file = File(appCon.cachedSplashVideoPath);
    if (!file.existsSync()) return;

    try {
      _videoController?.removeListener(_videoListener);
      await _videoController?.dispose();

      _videoController = VideoPlayerController.file(file);
      await _videoController!.initialize();

      if (!mounted) return;

      _usingAssetVideo = false;

      setState(() {});
      _videoController!
        ..setVolume(1.0)
        ..play();

      _videoController!.addListener(_videoListener);
    } catch (_) {
      // fallback to asset already playing
    }
  }

  // ============================
  // IMAGE FLOW
  // ============================
  void _showImageAndNavigate() {
    if (_calledNext) return;

    _calledNext = true;

    _videoController?.removeListener(_videoListener);
    _videoController?.pause();

    _imageTimer = Timer(const Duration(seconds: 3), () async {
      await authCon.checkUserAuthStatus();
    });

    setState(() {});
  }

  // ============================
  // VIDEO END LISTENER
  // ============================
  void _videoListener() async {
    if (_videoController == null || _calledNext) return;

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
    _imageTimer?.cancel();
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
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    // IMAGE SPLASH
    if (appCon.splashMediaType == SplashMediaType.image &&
        appCon.cachedSplashImagePath.isNotEmpty) {
      return Image.file(
        File(appCon.cachedSplashImagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // VIDEO SPLASH
    if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }

    return const SizedBox();
  }
}
