import 'dart:math';
import 'dart:ui';

import '../constants/colour_database.dart';

class ColourUtils {

  static Map<String, double> rgbToHsv(Color color) {

    double r = color.red / 255;
    double g = color.green / 255;
    double b = color.blue / 255;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double delta = maxVal - minVal;

    double hue = 0;

    if (delta == 0) {
      hue = 0;
    } else if (maxVal == r) {
      hue = 60 * (((g - b) / delta) % 6);
    } else if (maxVal == g) {
      hue = 60 * (((b - r) / delta) + 2);
    } else {
      hue = 60 * (((r - g) / delta) + 4);
    }

    if (hue < 0) {
      hue += 360;
    }

    double saturation = maxVal == 0 ? 0 : delta / maxVal;
    double brightness = maxVal;

    return {
      "hue": hue,
      "saturation": saturation,
      "brightness": brightness,
    };
  }

  static String getColourName(double hue) {

    for (var colour in ColourDatabase.colours) {
      if (hue >= colour.hueStart && hue < colour.hueEnd) {
        return colour.name;
      }
    }

    return "Unknown";
  }

  static String getTemperature(double hue) {

    if (hue <= 90 || hue >= 300) {
      return "warm";
    }

    if (hue > 90 && hue < 210) {
      return "cool";
    }

    return "neutral";
  }

  static String getTone(double saturation, double brightness) {

    if (saturation < 0.3) {
      return "muted";
    }

    if (brightness > 0.7 && saturation < 0.5) {
      return "soft";
    }

    return "vibrant";
  }

  static String rgbToHex(Color color) {

    return "#${color.red.toRadixString(16).padLeft(2, '0')}"
           "${color.green.toRadixString(16).padLeft(2, '0')}"
           "${color.blue.toRadixString(16).padLeft(2, '0')}";
  }
}