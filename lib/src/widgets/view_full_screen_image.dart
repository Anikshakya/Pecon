import 'package:flutter/material.dart';
import 'package:pecon/src/app_config/styles.dart';

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  final TransformationController _controller = TransformationController();
  final double _maxScale = 8.0;
  final double _doubleTapScale = 3;
  double _currentScale = 1.0;
  Offset _doubleTapPosition = Offset.zero;

  void _onDoubleTap(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      if (_currentScale == 1.0) {
        _doubleTapPosition = localPosition;
        _currentScale = _doubleTapScale;

        // Calculate new transformation matrix to zoom at the tapped point
        final Matrix4 newMatrix = Matrix4.identity()
          ..translate(-_doubleTapPosition.dx * (_doubleTapScale - 1), 
                      -_doubleTapPosition.dy * (_doubleTapScale - 1))
          ..scale(_doubleTapScale);

        _controller.value = newMatrix;
      } else {
        // Reset to normal scale
        _currentScale = 1.0;
        _controller.value = Matrix4.identity();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onDoubleTapDown: _onDoubleTap,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: _maxScale,
                transformationController: _controller,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                        color: black,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 50, color: black),
                    );
                  },
                ),
              ),
            ),
          ),

          // Close Button (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
