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
  final AppController appCon = Get.put(AppController());
  final AuthController authCon = Get.put(AuthController());

  VideoPlayerController? _videoController;
  Timer? _imageTimer;

  bool _calledNext = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // ============================
  // APP START FLOW
  // ============================
  Future<void> _initialize() async {
    final result = await appCon.startApp();

    switch (result) {
      case AppStartResult.blockedByUpdate:
        // Update dialog already shown
        await _routeNext();
        return;

      case AppStartResult.playSplash:
      case AppStartResult.playCachedSplash:
        await _playSplashFromCacheOrRoute();
        return;

      case AppStartResult.routeImmediately:
        await _routeNext();
        return;
    }
  }

  // ============================
  // SPLASH DECISION
  // ============================
  Future<void> _playSplashFromCacheOrRoute() async {
    if (appCon.splashMediaType == SplashMediaType.image &&
        appCon.cachedSplashImagePath.isNotEmpty) {
      _showImageAndNavigate();
      return;
    }

    if (appCon.splashMediaType == SplashMediaType.video &&
        appCon.cachedSplashVideoPath.isNotEmpty) {
      await _playCachedVideo();
      return;
    }

    await _routeNext();
  }

  // ============================
  // IMAGE FLOW
  // ============================
  void _showImageAndNavigate() {
    if (_calledNext) return;
    _calledNext = true;

    _imageTimer = Timer(const Duration(seconds: 3), () async {
      await _routeNext();
    });

    setState(() {});
  }

  // ============================
  // VIDEO FLOW
  // ============================
  Future<void> _playCachedVideo() async {
    if (_calledNext) return;

    final file = File(appCon.cachedSplashVideoPath);
    if (!file.existsSync()) {
      await _routeNext();
      return;
    }

    try {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file);

      await _videoController!.initialize();
      if (!mounted) return;

      setState(() {});

      _videoController!
        ..setVolume(1.0)
        ..play()
        ..addListener(_videoListener);
    } catch (_) {
      await _routeNext();
    }
  }

  void _videoListener() async {
    if (_calledNext || _videoController == null) return;

    final value = _videoController!.value;
    if (value.isInitialized && value.position >= value.duration) {
      _calledNext = true;
      await _routeNext();
    }
  }

  // ============================
  // ROUTING
  // ============================
  Future<void> _routeNext() async {
    if (_calledNext) return;
    _calledNext = true;
    await authCon.checkUserAuthStatus();
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
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    // IMAGE SPLASH
    if (appCon.splashMediaType == SplashMediaType.image &&
        appCon.cachedSplashImagePath.isNotEmpty) {
      return Image.file(
        File(appCon.cachedSplashImagePath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // VIDEO SPLASH
    if (_videoController != null && _videoController!.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    }

    // FALLBACK
    return const SizedBox();
  }
}
