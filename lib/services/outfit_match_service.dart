import '../models/clothing_item.dart';
import '../core/constants/outfit_rules.dart';

class OutfitMatchResult {
  final String result;
  final int score;
  final int hueDifference;

  OutfitMatchResult({
    required this.result,
    required this.score,
    required this.hueDifference,
  });
}

class OutfitMatchService {

  static OutfitMatchResult evaluate(
      ClothingItem top,
      ClothingItem bottom,
      ) {

    int diff = OutfitRules.hueDifference(top.hue, bottom.hue);

    String harmony =
        OutfitRules.evaluateHarmony(top.hue, bottom.hue);

    int score =
        OutfitRules.compatibilityScore(top.hue, bottom.hue);

    return OutfitMatchResult(
      result: harmony,
      score: score,
      hueDifference: diff,
    );
  }
}