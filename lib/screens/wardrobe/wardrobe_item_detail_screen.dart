import 'dart:io';
import 'package:beyondhue/screens/outfit/outfit_suggestion_screen.dart';
import 'package:flutter/material.dart';
import '../../models/clothing_item.dart';

class WardrobeItemDetailScreen extends StatelessWidget {

  final ClothingItem item;

  const WardrobeItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clothing Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(item.imagePath),
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BASIC INFO
            Text(
              "Clothing Type",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.clothingType),

            const SizedBox(height: 12),

            Text(
              "Occasion",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.occasion),

            const SizedBox(height: 20),

            /// COLOUR INFO
            Text(
              "Colour Name",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.colourName),

            const SizedBox(height: 12),

            Text(
              "HEX Code",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.hexCode),

            const SizedBox(height: 12),

            Text(
              "Hue",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.hue.toStringAsFixed(2)),

            const SizedBox(height: 12),

            Text(
              "Saturation",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.saturation.toStringAsFixed(2)),

            const SizedBox(height: 12),

            Text(
              "Brightness",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.brightness.toStringAsFixed(2)),

            const SizedBox(height: 30),

Center(
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OutfitSuggestionScreen(
            baseItem: item,
          ),
        ),
      );
    },
    child: const Text("Find Matching Outfit"),
  ),
),
          ],
        ),
      ),
    );
  }
}
