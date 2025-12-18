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

  late VideoPlayerController _videoController;
  bool _calledNext = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
      'assets/video/splash_video.mp4',
    )..initialize().then((_) {
        setState(() {});
        _videoController
          ..setVolume(1.0)
          ..play();
      });

    _videoController.addListener(_videoListener);
  }

  void _videoListener() async {
    if (_videoController.value.position >=
            _videoController.value.duration &&
        !_calledNext) {
      _calledNext = true;

      await appCon.getSettingApi();
      await authCon.checkUserAuthStatus();
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          Center(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
