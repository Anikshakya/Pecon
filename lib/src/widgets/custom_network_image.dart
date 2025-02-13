import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/widgets/view_full_screen_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final double borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 8.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: GestureDetector(
        onTap: (){
          Get.to(()=> FullScreenImagePage(
            imageUrl: imageUrl,
          ));
        },
        child: Image.network(
          imageUrl,
          height: height,
          width: width,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            // if (loadingProgress == null) return child;
            
            // double? progress;
            // if (loadingProgress.expectedTotalBytes != null) {
            //   progress = loadingProgress.cumulativeBytesLoaded / 
            //             (loadingProgress.expectedTotalBytes ?? 1);
            // }
        
            // return Center(
            //   child: Container(
            //     padding: const EdgeInsets.all(4),
            //     height: height - (height * 55/100),
            //     width: width - (width * 55/100),
            //     child: CircularProgressIndicator(
            //       value: progress,
            //       color: black,
            //       strokeWidth: 1.5,
            //     ),
            //   ),
            // );
            if (loadingProgress == null) return child;
            return _buildPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 236, 236),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        Icons.camera,
        color: black.withOpacity(0.1),
        size: width * 0.45,
      ),
    );
  }
}
