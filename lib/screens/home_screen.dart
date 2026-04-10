import 'package:flutter/material.dart';
import 'colour_analyser/colour_analyser_screen.dart';
import 'wardrobe/wardrobe_screen.dart';
import 'wardrobe/add_clothing_screen.dart';
import 'package:beyondhue/screens/outfit/outfit_matcher_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 🔷 DESIGN SYSTEM (same as AddClothingScreen)
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color accentColor = Color(0xFFF59E0B);
  static const Color bgColor = Color(0xFFF8FAFC);

  Widget buildCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              /// ICON CONTAINER (better visual anchor)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 14),

              /// TITLE
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        title: const Text("BeyondHue"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: const Color(0xFF111827),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [

            buildCard(
              context,
              "Colour\nAnalyser",
              Icons.color_lens,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ColourAnalyserScreen(),
                  ),
                );
              },
            ),

            buildCard(
              context,
              "Wardrobe",
              Icons.checkroom,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WardrobeScreen(),
                  ),
                );
              },
            ),

            buildCard(
              context,
              "Outfit\nMatcher",
              Icons.style,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OutfitMatcherScreen(),
                  ),
                );
              },
            ),

            buildCard(
              context,
              "Add\nClothing",
              Icons.add_circle,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddClothingScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}