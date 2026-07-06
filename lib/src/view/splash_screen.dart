import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';
import 'package:pecon_app/src/controllers/auth_controller.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final AppController appCon = Get.put(AppController());
  final AuthController authCon = Get.put(AuthController());

  VideoPlayerController? _videoController;

  bool _calledNext = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_videoController == null) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        if (_videoController!.value.isInitialized) {
          _videoController!.pause();
        }
        break;

      case AppLifecycleState.resumed:
        if (_videoController!.value.isInitialized &&
            !_videoController!.value.isPlaying &&
            !_calledNext) {
          _videoController!.play();
        }
        break;

      default:
        break;
    }
  }

  Future<void> _initialize() async {
    debugPrint("Splash -> initialize");

    appCon.getAppVersion();

    debugPrint("Splash -> startApp initiated with 5s timeout safeguard");

    AppStartResult result;
    try {
      // SAFEGUARD: If appCon.startApp() hangs indefinitely (e.g., stuck API call), 
      // this timeout forces it to break out after 5 seconds and route the user.
      result = await appCon.startApp().timeout(
        const Duration(seconds: 6),
        onTimeout: () {
          debugPrint("Splash -> startApp TIMEOUT hit inside controller call!");
          return AppStartResult.routeImmediately; 
        },
      );
    } catch (e) {
      debugPrint("Splash -> startApp encountered an unexpected error: $e");
      result = AppStartResult.routeImmediately;
    }

    debugPrint("Splash -> result : $result");

    switch (result) {
      // 1. UPDATE GUARDRAIL: If blocked by update, return immediately. 
      // No navigation or fallback timeout will ever be triggered.
      case AppStartResult.blockedByUpdate:
        return;

      case AppStartResult.playSplash:
      case AppStartResult.playCachedSplash:
        await _playSplashFromCacheOrRoute();
        break;

      case AppStartResult.routeImmediately:
        await _routeNext();
        break;
    }
  }

  Future<void> _playSplashFromCacheOrRoute() async {
    debugPrint("Splash -> media type : ${appCon.splashMediaType}");

    // 2. MEDIA TIMEOUT FALLBACK: If the media hangs or takes longer than 6 seconds,
    // force-route the user to the next screen.
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && !_calledNext) {
        debugPrint("Splash -> Media load timed out after 6 seconds. Routing fallback...");
        _routeNext();
      }
    });

    if (appCon.splashMediaType == SplashMediaType.image &&
        appCon.cachedSplashImagePath.isNotEmpty) {
      await _showImageAndNavigate();
      return;
    }

    if (appCon.splashMediaType == SplashMediaType.video &&
        appCon.cachedSplashVideoPath.isNotEmpty) {
      await _playCachedVideo();
      return;
    }

    await _routeNext();
  }

  Future<void> _showImageAndNavigate() async {
    if (_calledNext) return;

    // Image displays safely for 4 seconds (well within our 6-second total window)
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    await _routeNext();
  }

  Future<void> _playCachedVideo() async {
    if (_calledNext) return;

    final file = File(appCon.cachedSplashVideoPath);

    debugPrint("Video Path : ${file.path}");
    debugPrint("Video Exists : ${file.existsSync()}");

    if (!file.existsSync()) {
      debugPrint("Video not found");
      await _routeNext();
      return;
    }

    debugPrint("Video Size : ${await file.length()}");

    try {
      await _videoController?.dispose();

      _videoController = VideoPlayerController.file(file);

      debugPrint("Initializing video...");

      await _videoController!.initialize();

      debugPrint(
          "Video initialized : ${_videoController!.value.isInitialized}");

      if (!mounted) return;

      setState(() {});

      _videoController!
        ..setVolume(1)
        ..play()
        ..addListener(_videoListener);

      debugPrint("Video playing");
    } catch (e, s) {
      debugPrint("Video error : $e");
      debugPrint("$s");

      await _routeNext();
    }
  }

  void _videoListener() async {
    if (_calledNext || _videoController == null) return;

    final value = _videoController!.value;

    if (!value.isPlaying &&
        value.isInitialized &&
        value.duration != Duration.zero &&
        value.position >= value.duration) {
      await _routeNext();
    }
  }

  Future<void> _routeNext() async {
    if (_calledNext) return;

    _calledNext = true;

    debugPrint("Routing next");

    if (!mounted) return;

    await authCon.checkUserAuthStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        bottom: false,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (appCon.splashMediaType == SplashMediaType.image &&
        appCon.cachedSplashImagePath.isNotEmpty) {
      return Image.file(
        File(appCon.cachedSplashImagePath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (_videoController != null && _videoController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
      );
    }

    return const Center(
      child: SizedBox(),
    );
  }
}