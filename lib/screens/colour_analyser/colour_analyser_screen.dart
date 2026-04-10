import 'dart:io';

import 'package:beyondhue/screens/wardrobe/add_clothing_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/analyser_provider.dart';

class ColourAnalyserScreen extends StatefulWidget {
  const ColourAnalyserScreen({super.key});

  @override
  State<ColourAnalyserScreen> createState() =>
      _ColourAnalyserScreenState();
}

class _ColourAnalyserScreenState extends State<ColourAnalyserScreen> {

  File? image;

  // 🔷 DESIGN SYSTEM
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color accentColor = Color(0xFFF59E0B);
  static const Color bgColor = Color(0xFFF8FAFC);

  Future pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      image = File(picked.path);
    });

    await context.read<AnalyserProvider>().analyseImage(picked.path);
  }

  Widget buildSourceButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analyser = context.watch<AnalyserProvider>();

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        title: const Text("Colour Analyser"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: const Color(0xFF111827),
      ),

      body: Stack(
        children: [

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔷 IMAGE PREVIEW
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.white,
                    child: image == null
                        ? Center(
                            child: Text(
                              "No Image Selected",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          )
                        : Image.file(image!, fit: BoxFit.contain),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Select Source",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    buildSourceButton(
                      title: "Camera",
                      icon: Icons.camera_alt,
                      onTap: () => pickImage(ImageSource.camera),
                    ),
                    const SizedBox(width: 12),
                    buildSourceButton(
                      title: "Gallery",
                      icon: Icons.photo,
                      onTap: () => pickImage(ImageSource.gallery),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// 🔷 LOADING
                if (analyser.isLoading)
                  Column(
                    children: const [
                      SizedBox(height: 10),
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Analysing image..."),
                    ],
                  ),

                /// 🔷 RESULT
                if (analyser.detectedColour != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NAME
                        Text(
                          analyser.detectedColour!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// COLOR PREVIEW (CRITICAL FIX)
                        // Container(
                        //   height: 40,
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //     color: Color(
                        //       int.parse(
                        //         analyser.detectedColour!.hex
                        //             .replaceFirst('#', '0xff'),
                        //       ),
                        //     ),
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),

                        const SizedBox(height: 12),

                        Text("HEX: ${analyser.detectedColour!.hex}"),
                        const SizedBox(height: 6),
                        Text("Temperature: ${analyser.detectedColour!.temperature}"),
                        const SizedBox(height: 6),
                        Text("Tone: ${analyser.detectedColour!.tone}"),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          /// 🔷 CTA
          if (image != null && analyser.detectedColour != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    "Add to wardrobe",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddClothingScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}