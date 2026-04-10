import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/clothing_item.dart';
import '../../providers/analyser_provider.dart';
import '../../providers/wardrobe_provider.dart';

class AddClothingScreen extends StatefulWidget {
  const AddClothingScreen({super.key});

  @override
  State<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends State<AddClothingScreen> {

  final clothingController = TextEditingController();

  String selectedCategory = "Top";
  String selectedOccasion = "Casual";

  final List<String> categories = ["Top", "Bottom"];
  final List<String> occasions = ["Formal", "Casual", "Traditional", "Active Wear"];

  final Color primaryColor = const Color(0xFF1E3A8A);
  final Color accentColor = const Color(0xFFF59E0B);
  final Color bgColor = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {

    final analyser = context.watch<AnalyserProvider>();
    final colour = analyser.detectedColour;
    final imagePath = analyser.lastImagePath;

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: const Text("Add Clothing"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: const Color(0xFF111827),
      ),

      body: colour == null || imagePath == null
          ? const Center(child: Text("Analyse clothing first"))
          : Stack(
              children: [

                /// 🔷 CONTENT
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.white,
                          child: Image.file(
                            File(imagePath),
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Clothing Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// 🔷 CATEGORY (ICON + TEXT → accessible)
                      Row(
                        children: categories.map((cat) {

                          final isSelected = selectedCategory == cat;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = cat;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: isSelected ? primaryColor : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected ? primaryColor : Colors.grey.shade300,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      cat == "Top" ? Icons.checkroom : Icons.hiking,
                                      color: isSelected ? Colors.white : Colors.grey,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cat,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.white : Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      /// TEXT FIELD
                      TextField(
                        controller: clothingController,
                        decoration: InputDecoration(
                          labelText: "Clothing Type",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.edit),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔷 OCCASION (ICON + CHIP)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: occasions.map((occ) {

                          final isSelected = selectedOccasion == occ;

                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: isSelected ? Colors.white : accentColor,
                                ),
                                const SizedBox(width: 6),
                                Text(occ),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedOccasion = occ;
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
                      ),
                    ],
                  ),
                ),

                /// 🔷 CTA BUTTON
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check,color: Colors.white,),
                      label: const Text("Save Clothing",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {

                        final item = ClothingItem(
                          id: const Uuid().v4(),
                          imagePath: imagePath,
                          clothingType: clothingController.text.trim(),
                          occasion: selectedOccasion,
                          category: selectedCategory,
                          colourName: colour.name,
                          hexCode: colour.hex,
                          hue: colour.hue,
                          saturation: colour.saturation,
                          brightness: colour.brightness,
                          temperature: colour.temperature,
                          tone: colour.tone,
                        );

                        context.read<WardrobeProvider>().addItem(item);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }
}