import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoreImageNetwork extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CoreImageNetwork({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      errorWidget: (context, url, error) => errorWidget ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: Icon(Icons.music_note),
            ),
          ),
    );

    final borderRadius = this.borderRadius;
    if (borderRadius == null) return image;

    return ClipRRect(
      borderRadius: borderRadius,
      child: image,
    );
  }
}
