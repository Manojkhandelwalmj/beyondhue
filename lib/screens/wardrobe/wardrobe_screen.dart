import 'dart:io';
import 'package:beyondhue/screens/wardrobe/wardrobe_item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/wardrobe_provider.dart';
import '../../models/clothing_item.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();

    final List<ClothingItem> items = wardrobe.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wardrobe"),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text("No clothing added yet"),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WardrobeItemDetailScreen(item: item),
      ),
    );
  },

  child: Card(
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
          item.occasion,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          "${item.colourName} (${item.hexCode})",
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
      ],
    ),
  ),
);
              },
            ),
    );
  }
}
