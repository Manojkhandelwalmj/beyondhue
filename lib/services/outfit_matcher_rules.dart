import 'package:beyondhue/models/colour_data.dart';

class OutfitMatcherResult {
  final int score;
  final bool isSafe;

  OutfitMatcherResult({required this.score, required this.isSafe});
}

class OutfitMatcherRules {

  static OutfitMatcherResult analyse({
    required ColourData top,
    required ColourData bottom,
    required String occasion,
  }) {

    double diff = (top.hue - bottom.hue).abs();
    if (diff > 180) diff = 360 - diff;

    int score = 0;

    // -------------------------
    // BASE SCORE (Hue logic)
    // -------------------------
    if (diff <= 15) {
      score = 90;
    } else if (diff <= 60) {
      score = 80;
    } else if (diff >= 150 && diff <= 210) {
      score = 85;
    } else {
      score = 40;
    }

    // -------------------------
    // NEUTRAL BONUS
    // -------------------------
    if (_isNeutral(top.name) || _isNeutral(bottom.name)) {
      score += 30;
    }

    // -------------------------
    // TONE MATCHING
    // -------------------------
    if (top.tone == bottom.tone) {
      score += 10;
    } else {
      score -= 10;
    }

    // -------------------------
    // OCCASION RULES
    // -------------------------
    score += _occasionAdjustment(top, bottom, occasion);

    // Clamp
    if (score > 100) score = 100;
    if (score < 0) score = 0;

    bool isSafe = score >= 65;

    return OutfitMatcherResult(score: score, isSafe: isSafe);
  }

  static bool _isNeutral(String name) {
    return name.contains("Black") ||
        name.contains("White") ||
        name.contains("Grey");
  }

  static int _occasionAdjustment(
      ColourData top, ColourData bottom, String occasion) {

    switch (occasion) {
      case "formal":
        if (_isNeutral(top.name) && _isNeutral(bottom.name)) return 15;
        if (top.saturation > 0.7 || bottom.saturation > 0.7) return -15;
        return 5;

      case "casual":
        return 5;

      case "traditional":
        if (top.temperature == "Warm" && bottom.temperature == "Warm") {
          return 15;
        }
        return 0;

      case "activewear":
        double diff = (top.hue - bottom.hue).abs();
        if (diff > 120) return 15;
        return 5;

      default:
        return 0;
    }
  }
}