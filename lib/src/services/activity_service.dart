import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';

class UserActivityService with WidgetsBindingObserver {
  UserActivityService._();

  static final UserActivityService instance = UserActivityService._();

  Timer? _inactiveTimer;

  final AppController appCon = Get.find<AppController>();

  bool _isCurrentlyActive = true;

  bool _initialized = false;

  void initialize() {
    if (_initialized) return;

    _initialized = true;

    WidgetsBinding.instance.addObserver(this);

    /// Initial active state
    _sendStatusToApi(true);

    _startInactivityTimer();
  }

  void onUserInteraction() {
    /// If previously inactive -> become active
    if (!_isCurrentlyActive) {
      _isCurrentlyActive = true;
      _sendStatusToApi(true);
    }

    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    _inactiveTimer?.cancel();

    _inactiveTimer = Timer(
      const Duration(seconds: 15),
      () {
        if (_isCurrentlyActive) {
          _isCurrentlyActive = false;
          _sendStatusToApi(false);
        }
      },
    );
  }

  Future<void> _sendStatusToApi(bool isActive) async {
    try {
      log(
        "USER STATUS => ${isActive ? "ACTIVE" : "INACTIVE"}",
      );

      await appCon.onlineApi(
        isActive ? 1 : 0,
      );
    } catch (e) {
      log("STATUS API ERROR: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    /// App in foreground
    if (state == AppLifecycleState.resumed) {
      _isCurrentlyActive = true;

      _sendStatusToApi(true);

      _startInactivityTimer();
    }

    /// App in background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _inactiveTimer?.cancel();

      if (_isCurrentlyActive) {
        _isCurrentlyActive = false;

        _sendStatusToApi(false);
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _inactiveTimer?.cancel();
  }
}