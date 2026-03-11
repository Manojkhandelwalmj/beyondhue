import 'package:flutter/material.dart';

import '../models/colour_data.dart';
import '../services/colour_detection_service.dart';

class AnalyserProvider extends ChangeNotifier {

  ColourData? detectedColour;

  bool isLoading = false;

  Future<void> analyseImage(String imagePath) async {

    isLoading = true;
    notifyListeners();

    detectedColour =
        await ColourDetectionService.analyseImage(imagePath);

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    detectedColour = null;
    notifyListeners();
  }
}