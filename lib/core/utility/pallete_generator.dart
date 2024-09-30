import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color?> getImagePalette(String image) async {
 final imageProvider =  NetworkImage(image);
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor?.color;
}
