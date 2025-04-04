import 'package:flutter/material.dart';

Widget flexibleImage(
  String imageUrl, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
  BorderRadius borderRadius = BorderRadius.zero,
}) {
  final imageWidget =
      imageUrl.startsWith('http')
          ? Image.network(imageUrl, height: height, width: width, fit: fit)
          : Image.asset(imageUrl, height: height, width: width, fit: fit);

  return ClipRRect(borderRadius: borderRadius, child: imageWidget);
}
