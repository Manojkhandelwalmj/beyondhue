import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/analyser_provider.dart';

class ColourAnalyserScreen extends StatefulWidget {
  const ColourAnalyserScreen({super.key});

  @override
  State<ColourAnalyserScreen> createState() => _ColourAnalyserScreenState();
}

class _ColourAnalyserScreenState extends State<ColourAnalyserScreen> {
  File? image;

  Future pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return;

    setState(() {
      image = File(picked.path);
    });

    await context.read<AnalyserProvider>().analyseImage(picked.path);
  }

  @override
  Widget build(BuildContext context) {
    final analyser = context.watch<AnalyserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Colour Analyser"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Select Clothing Image"),
            ),
            const SizedBox(height: 20),
            if (image != null)
              Image.file(
                image!,
                height: 200,
              ),
            const SizedBox(height: 20),
            if (analyser.isLoading) const CircularProgressIndicator(),
            if (analyser.detectedColour != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        analyser.detectedColour!.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("HEX: ${analyser.detectedColour!.hex}"),
                      const SizedBox(height: 8),
                      Text(
                          "Hue: ${analyser.detectedColour!.hue.toStringAsFixed(2)}"),
                      const SizedBox(height: 8),
                      Text(
                          "Saturation: ${analyser.detectedColour!.saturation.toStringAsFixed(2)}"),
                      const SizedBox(height: 8),
                      Text(
                          "Brightness: ${analyser.detectedColour!.brightness.toStringAsFixed(2)}"),
                      const SizedBox(height: 8),
                      Text(
                          "Temperature: ${analyser.detectedColour!.temperature}"),
                      const SizedBox(height: 8),
                      Text("Tone: ${analyser.detectedColour!.tone}"),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
