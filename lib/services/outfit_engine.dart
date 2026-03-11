import '../models/clothing_item.dart';

class OutfitEngine {

  static double hueDifference(double h1, double h2) {
    double diff = (h1 - h2).abs();
    return diff > 180 ? 360 - diff : diff;
  }

  static bool isAnalogous(double diff) {
    return diff <= 30;
  }

  static bool isComplementary(double diff) {
    return (diff >= 160 && diff <= 200);
  }

  static bool isTriadic(double diff) {
    return (diff >= 110 && diff <= 130);
  }

  static bool isClashing(double diff) {
    return (diff >= 70 && diff <= 110);
  }

  static String evaluatePair(
      ClothingItem a,
      ClothingItem b,
      ) {

    double diff = hueDifference(a.hue, b.hue);

    if (isClashing(diff)) {
      return "Not Recommended";
    }

    if (isComplementary(diff) || isTriadic(diff)) {
      return "Excellent Match";
    }

    if (isAnalogous(diff)) {
      return "Safe Match";
    }

    return "Moderate Match";
  }

}