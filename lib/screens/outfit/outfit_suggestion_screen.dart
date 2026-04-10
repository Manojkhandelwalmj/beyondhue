import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/clothing_item.dart';
import '../../providers/wardrobe_provider.dart';
import '../../services/outfit_engine.dart';

class OutfitSuggestionScreen extends StatelessWidget {

  final ClothingItem baseItem;

  const OutfitSuggestionScreen({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context) {

    final wardrobe = context.watch<WardrobeProvider>();
    final items = wardrobe.items;

    List<Map<String, dynamic>> matches = [];

    for (var item in items) {

  if (item.id == baseItem.id) continue;

  // ✅ STRICT TOP-BOTTOM MATCHING
  if (item.category == baseItem.category) continue;

  final result = OutfitEngine.evaluatePair(baseItem, item);

  if (result != "Not Recommended") {
    matches.add({
      "item": item,
      "score": result,
    });
  }
}

    return Scaffold(
      appBar: AppBar(
        title: const Text("Matching Outfits"),
      ),

      body: matches.isEmpty
          ? const Center(
              child: Text("No good matches found"),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {

                final ClothingItem item = matches[index]["item"];
                final String score = matches[index]["score"];

                return Card(
                  child: Column(
                    children: [

                      Expanded(
                        child: Image.file(
                          File(item.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(item.clothingType),

                      Text(
                        score,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
    );
  }
}