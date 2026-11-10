import 'dart:io';
import 'package:flutter/material.dart';

/// Shows the dish photo, or a placeholder icon when there is no photo.
class SpotImage extends StatelessWidget {
  final String? imagePath;
  final double height;

  const SpotImage({super.key, required this.imagePath, required this.height});

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.orange.shade100,
        child: const Icon(Icons.restaurant, size: 64, color: Colors.deepOrange),
      );
    }
    return Image.file(
      File(imagePath!),
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
