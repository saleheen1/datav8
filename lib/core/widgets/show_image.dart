import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({
    super.key,
    this.height,
    this.width,
    required this.imgLocation,
    this.radius,
    this.fit,
    required this.isAssetImg,
    this.imageAlignment,
  });

  final double? height;
  final double? width;
  final String imgLocation;
  final BorderRadius? radius;
  final BoxFit? fit;
  final bool isAssetImg;
  final Alignment? imageAlignment;

  @override
  Widget build(BuildContext context) {
    return isAssetImg
        ? ClipRRect(
            borderRadius: radius ?? BorderRadius.circular(0),
            child: Container(
              height: height ?? 60,
              width: width ?? 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: imageAlignment ?? Alignment.center,
                  image: AssetImage(imgLocation),
                  fit: fit ?? BoxFit.cover,
                ),
              ),
            ),
          )
        : ClipRRect(
            borderRadius: radius ?? BorderRadius.circular(0),
            child: CachedNetworkImage(
              height: height,
              width: width ?? double.infinity,
              imageUrl: imgLocation,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: fit ?? (height == null ? BoxFit.fitWidth : BoxFit.cover),
              memCacheWidth: kIsWeb ? 800 : null,
              memCacheHeight: kIsWeb ? 600 : null,
              placeholder: (context, url) => const SizedBox(
                height: 30,
                width: 30,
                child: Icon(Icons.image, size: 30, color: Colors.grey),
              ),
            ),
          );
  }
}
