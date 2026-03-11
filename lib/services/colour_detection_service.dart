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

    String colourName =
        _detectDetailedColour(hue, saturation, brightness);

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

  static String _detectDetailedColour(
      double hue, double saturation, double brightness) {

    // -----------------------------
    // NEUTRAL COLOURS
    // -----------------------------

    if (brightness < 0.12) {
      return "Black";
    }

    if (saturation < 0.08 && brightness > 0.92) {
      return "White";
    }

    if (saturation < 0.12) {
      if (brightness < 0.35) return "Dark Grey";
      if (brightness < 0.65) return "Grey";
      return "Light Grey";
    }

    // -----------------------------
    // RED FAMILY
    // -----------------------------

    if (hue < 8 || hue >= 352) {
      if (brightness < 0.28) return "Burgundy";
      if (brightness < 0.45) return "Dark Red";
      if (brightness > 0.75 && saturation < 0.55) return "Pink";
      if (brightness > 0.75 && saturation > 0.65) return "Bright Red";
      return "Red";
    }

    if (hue < 20) {
      if (brightness < 0.40) return "Rust";
      if (brightness > 0.80) return "Coral";
      return "Red Orange";
    }

    // -----------------------------
    // ORANGE
    // -----------------------------

    if (hue < 35) {
      if (brightness < 0.45) return "Burnt Orange";
      if (brightness > 0.80) return "Peach";
      return "Orange";
    }

    // -----------------------------
    // YELLOW
    // -----------------------------

    if (hue < 50) {
      if (brightness < 0.45) return "Mustard";
      if (brightness > 0.85) return "Light Yellow";
      return "Yellow";
    }

    // -----------------------------
    // LIME / YELLOW GREEN
    // -----------------------------

    if (hue < 70) {
      if (brightness < 0.45) return "Olive";
      if (brightness > 0.80) return "Lime";
      return "Yellow Green";
    }

    // -----------------------------
    // GREEN
    // -----------------------------

    if (hue < 140) {
      if (brightness < 0.35) return "Dark Green";
      if (brightness > 0.80) return "Light Green";
      if (saturation < 0.40) return "Sage";
      return "Green";
    }

    // -----------------------------
    // CYAN / TEAL
    // -----------------------------

    if (hue < 185) {
      if (brightness > 0.80) return "Aqua";
      if (brightness < 0.40) return "Deep Teal";
      return "Teal";
    }

    // -----------------------------
    // BLUE
    // -----------------------------

    if (hue < 240) {
      if (brightness < 0.30) return "Navy Blue";
      if (brightness > 0.80) return "Sky Blue";
      if (saturation < 0.45) return "Steel Blue";
      return "Blue";
    }

    // -----------------------------
    // INDIGO / PURPLE
    // -----------------------------

    if (hue < 270) {
      if (brightness < 0.35) return "Indigo";
      if (brightness > 0.80) return "Lavender";
      return "Purple";
    }

    // -----------------------------
    // MAGENTA / FUCHSIA
    // -----------------------------

    if (hue < 320) {
      if (saturation > 0.70) return "Fuchsia";
      if (brightness > 0.80) return "Light Pink";
      return "Pink";
    }

    // -----------------------------
    // CRIMSON
    // -----------------------------

    if (hue < 352) {
      if (brightness < 0.40) return "Dark Crimson";
      return "Crimson";
    }

    return "Unknown";
  }
}