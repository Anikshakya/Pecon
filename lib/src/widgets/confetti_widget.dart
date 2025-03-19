// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiDialog extends StatefulWidget {
  final ConfettiType type;

  const ConfettiDialog({super.key, required this.type});

  @override
  _ConfettiDialogState createState() => _ConfettiDialogState();
}

class _ConfettiDialogState extends State<ConfettiDialog> {
  late ConfettiController _controller;

@override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controller.play(); // Start confetti animation

    // Close the dialog automatically after 1 second (same as the confetti duration)
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pop(); // Automatically pop the dialog after 1 second
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🎨 Choose different confetti designs based on `widget.type`
  ConfettiWidget _buildConfettiEffect() {
    switch (widget.type) {
      case ConfettiType.burst:
        return ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive, // Blasts in all directions
          numberOfParticles: 50, // Higher count for a bigger burst
          gravity: 0.5, // Falls faster
        );
      case ConfettiType.rain:
        return ConfettiWidget(
          confettiController: _controller,
          blastDirection: pi / 2, // Falls from top to bottom
          maxBlastForce: 20, // Faster movement
          minBlastForce: 10,
          numberOfParticles: 30,
          gravity: 1, // Falls naturally
        );
      case ConfettiType.fireworks:
        return ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.01, // Continuous burst effect
          numberOfParticles: 300,
          gravity: 0.3,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Backgroundless
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildConfettiEffect(), // Show selected confetti effect
        ],
      ),
    );
  }
}

/// 🏷️ Enum for choosing different confetti effects
enum ConfettiType { burst, rain, fireworks }
