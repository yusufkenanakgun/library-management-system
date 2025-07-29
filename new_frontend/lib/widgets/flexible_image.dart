import 'package:flutter/material.dart';

Widget flexibleImage(
  String imageUrl, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
  BorderRadius borderRadius = BorderRadius.zero,
}) {
  final bool isAsset = imageUrl.startsWith('assets/');
  final bool isNetwork = imageUrl.startsWith('http');

  final imageWidget =
      isAsset
          ? Image.asset(
            imageUrl,
            height: height,
            width: width,
            fit: fit,
            errorBuilder:
                (context, error, stackTrace) =>
                    _fallbackImage(height, width, fit),
          )
          : isNetwork
          ? Image.network(
            imageUrl,
            height: height,
            width: width,
            fit: fit,
            errorBuilder:
                (context, error, stackTrace) =>
                    _fallbackImage(height, width, fit),
          )
          : _fallbackImage(height, width, fit);

  return ClipRRect(borderRadius: borderRadius, child: imageWidget);
}

Widget _fallbackImage(double? height, double? width, BoxFit fit) {
  return Image.network(
    'https://via.placeholder.com/140x200.png?text=No+Image',
    height: height,
    width: width,
    fit: fit,
  );
}
