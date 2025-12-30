import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecon/src/widgets/view_full_screen_image.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double borderRadius;
  final Color placeholderColor;
  final String? isFrom;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 8.0,
    this.placeholderColor = const Color(0xFFECECEC),
    this.isFrom,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: GestureDetector(
          onTap: () {
            Get.to(() => FullScreenImagePage(imageUrl: imageUrl),);
          },
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: height,
            width: width,
            fit: fit,
            placeholder: (context, url) => isFrom == 'notification' ? notificationPlaceholder() : _buildPlaceholder(),
            errorWidget: (context, url, error) => isFrom == 'notification' ? notificationPlaceholder() : _buildErrorWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: placeholderColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          color: Colors.black.withOpacity(0.2),
          size: _calculateIconSize(),
        ),
      ),
    );
  }

  Widget notificationPlaceholder() {
    return Image.asset(
      'assets/images/notification_image.jpg',
      height: height,
      width: width,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        color: placeholderColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.black.withOpacity(0.2),
          size: _calculateIconSize(),
        ),
      ),
    );
  }

  double _calculateIconSize() {
    if (width != null && height != null) {
      return (width! < height! ? width! : height!) * 0.3;
    } else if (width != null) {
      return width! * 0.3;
    } else if (height != null) {
      return height! * 0.3;
    }
    return 40.0; // default size
  }
}