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
  final occasionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final analyser = context.watch<AnalyserProvider>();

    final colour = analyser.detectedColour;

    final imagePath = analyser.lastImagePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Clothing"),
      ),
      body: colour == null || imagePath == null
          ? const Center(child: Text("Analyse clothing first"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.file(
                    File(imagePath),
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: clothingController,
                    decoration: const InputDecoration(
                      labelText: "Clothing Type (shirt, pant, etc)",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: occasionController,
                    decoration: const InputDecoration(
                      labelText: "Occasion (casual, formal, party)",
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      final item = ClothingItem(
                        id: const Uuid().v4(),
                        imagePath: imagePath,
                        clothingType: clothingController.text,
                        occasion: occasionController.text,
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
                    child: const Text("Save Clothing"),
                  )
                ],
              ),
            ),
    );
  }
}
