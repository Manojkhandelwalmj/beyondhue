import 'package:flutter/material.dart';
import 'colour_analyser/colour_analyser_screen.dart';
import 'wardrobe/wardrobe_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget buildCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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

      appBar: AppBar(
        title: const Text("BeyondHue"),
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
              "Colour Analyser",
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
              "Outfit Matcher",
              Icons.style,
              () {},
            ),

            buildCard(
              context,
              "Add Clothing",
              Icons.add_circle,
              () {},
            ),

          ],
        ),
      ),
    );
  }
}