import 'dart:io';
import 'package:beyondhue/services/outfit_matcher_rules.dart';
import 'package:beyondhue/models/colour_data.dart';
import 'package:beyondhue/services/colour_detection_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class OutfitMatcherScreen extends StatefulWidget {
  const OutfitMatcherScreen({super.key});

  @override
  State<OutfitMatcherScreen> createState() => _OutfitMatcherScreenState();
}

class _OutfitMatcherScreenState extends State<OutfitMatcherScreen> {

  File? topImage;
  File? bottomImage;

  ColourData? topColour;
  ColourData? bottomColour;

  String selectedOccasion = "casual";

  int? score;
  bool? isSafe;

  final picker = ImagePicker();

  Future pickImage(bool isTop) async {

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Gallery"),
          ),
        ],
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    final file = File(picked.path);
    final colour = await ColourDetectionService.analyseImage(picked.path);

    setState(() {
      if (isTop) {
        topImage = file;
        topColour = colour;
      } else {
        bottomImage = file;
        bottomColour = colour;
      }
    });
  }

  void analyseOutfit() {

    if (topColour == null || bottomColour == null) return;

    final result = OutfitMatcherRules.analyse(
      top: topColour!,
      bottom: bottomColour!,
      occasion: selectedOccasion,
    );

    setState(() {
      score = result.score;
      isSafe = result.isSafe;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Outfit Matcher")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            DropdownButton<String>(
              value: selectedOccasion,
              items: const [
                DropdownMenuItem(value: "formal", child: Text("Formal")),
                DropdownMenuItem(value: "casual", child: Text("Casual")),
                DropdownMenuItem(value: "traditional", child: Text("Traditional")),
                DropdownMenuItem(value: "activewear", child: Text("Activewear")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedOccasion = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => pickImage(true),
                      child: const Text("Upload Top"),
                    ),
                    if (topImage != null)
                      Image.file(topImage!, height: 100),
                    if (topColour != null)
                      Text(topColour!.name),
                  ],
                ),

                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => pickImage(false),
                      child: const Text("Upload Bottom"),
                    ),
                    if (bottomImage != null)
                      Image.file(bottomImage!, height: 100),
                    if (bottomColour != null)
                      Text(bottomColour!.name),
                  ],
                ),

              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: analyseOutfit,
              child: const Text("Analyse Outfit"),
            ),

            const SizedBox(height: 20),

            if (score != null)
              Column(
                children: [
                  Text("Score: $score%"),
                  Text(
                    isSafe! ? "SAFE TO WEAR ✅" : "UNSAFE ❌",
                    style: TextStyle(
                      color: isSafe! ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}