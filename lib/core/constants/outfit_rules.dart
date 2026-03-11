class OutfitRules {

  static int hueDifference(double hue1, double hue2) {
    double diff = (hue1 - hue2).abs();

    if (diff > 180) {
      diff = 360 - diff;
    }

    return diff.round();
  }

  static String evaluateHarmony(double hue1, double hue2) {

    int diff = hueDifference(hue1, hue2);

    if (diff <= 15) {
      return "SAFE"; // monochromatic
    }

    if (diff >= 165 && diff <= 195) {
      return "SAFE"; // complementary
    }

    if (diff >= 90 && diff <= 120) {
      return "MODERATE"; // triadic style
    }

    if (diff >= 30 && diff <= 60) {
      return "MODERATE"; // analogous extension
    }

    return "NOT_SAFE";
  }

  static int compatibilityScore(double hue1, double hue2) {

    int diff = hueDifference(hue1, hue2);

    if (diff <= 15) return 95;
    if (diff >= 165 && diff <= 195) return 90;
    if (diff >= 90 && diff <= 120) return 75;
    if (diff >= 30 && diff <= 60) return 65;

    return 40;
  }
}