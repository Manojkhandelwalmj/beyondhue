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
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Gallery"),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
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

  Widget buildUploadCard({
    required String title,
    required File? image,
    required ColourData? colour,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image, height: 90),
                )
              else
                const Icon(Icons.add_a_photo, size: 40),

              const SizedBox(height: 10),

              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

              if (colour != null)
                Text(
                  colour.name,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOccasionSelector() {
    final options = ["formal", "casual", "traditional", "activewear"];

    return Wrap(
      spacing: 10,
      children: options.map((e) {
        final isSelected = selectedOccasion == e;

        return ChoiceChip(
          label: Text(e.toUpperCase()),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              selectedOccasion = e;
            });
          },
        );
      }).toList(),
    );
  }

  Widget buildResultCard() {
    if (score == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSafe! ? Colors.green.shade50 : Colors.red.shade50,
      ),
      child: Column(
        children: [
          Text(
            isSafe! ? "SAFE TO WEAR ✅" : "UNSAFE ❌",
            style: TextStyle(
              fontSize: 18,
              color: isSafe! ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Outfit Matcher"),
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              buildOccasionSelector(),

              const SizedBox(height: 20),

              Row(
                children: [
                  buildUploadCard(
                    title: "Top",
                    image: topImage,
                    colour: topColour,
                    onTap: () => pickImage(true),
                  ),
                  buildUploadCard(
                    title: "Bottom",
                    image: bottomImage,
                    colour: bottomColour,
                    onTap: () => pickImage(false),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: analyseOutfit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Analyse Outfit",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              buildResultCard(),

            ],
          ),
        ),
      ),
    );
  }
}