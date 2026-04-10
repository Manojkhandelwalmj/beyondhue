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

  // 🔷 DESIGN SYSTEM
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color accentColor = Color(0xFFF59E0B);
  static const Color bgColor = Color(0xFFF8FAFC);

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
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          height: 180,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_a_photo, color: primaryColor),
                ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),

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
      runSpacing: 10,
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
          selectedColor: primaryColor,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
          side: BorderSide(
            color: isSelected ? primaryColor : Colors.grey.shade300,
          ),
        );
      }).toList(),
    );
  }

  Widget buildResultCard() {
    if (score == null) return const SizedBox();

    final bg = isSafe!
        ? primaryColor.withOpacity(0.08)
        : Colors.red.withOpacity(0.08);

    final textColor = isSafe! ? primaryColor : Colors.red;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: bg,
      ),
      child: Column(
        children: [
          Text(
            isSafe! ? "SAFE TO WEAR" : "UNSAFE",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Score: $score",
            style: const TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        title: const Text("Outfit Matcher"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: const Color(0xFF111827),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
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
              height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.analytics, color: Colors.white),
                label: const Text(
                  "Analyse Outfit",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: analyseOutfit,
              ),
            ),

            buildResultCard(),
          ],
        ),
      ),
    );
  }
}