import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../models/colour_data.dart';
import '../core/utils/colour_utils.dart';

class ColourDetectionService {

  static Future<ColourData?> analyseImage(String imagePath) async {

    final imageFile = File(imagePath);

    if (!imageFile.existsSync()) {
      return null;
    }

    final imageProvider = FileImage(imageFile);

    final PaletteGenerator palette =
        await PaletteGenerator.fromImageProvider(
      imageProvider,
      size: const Size(200, 200),
      maximumColorCount: 8,
    );

    final dominant = palette.dominantColor;

    if (dominant == null) {
      return null;
    }

    Color color = dominant.color;

    final hsv = ColourUtils.rgbToHsv(color);

    double hue = hsv["hue"]!;
    double saturation = hsv["saturation"]!;
    double brightness = hsv["brightness"]!;

    String colourName = ColourUtils.getColourName(hue);
    String temperature = ColourUtils.getTemperature(hue);
    String tone = ColourUtils.getTone(saturation, brightness);
    String hex = ColourUtils.rgbToHex(color);

    return ColourData(
      name: colourName,
      hex: hex,
      hue: hue,
      saturation: saturation,
      brightness: brightness,
      temperature: temperature,
      tone: tone,
    );
  }
}