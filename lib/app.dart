import 'package:beyondhue/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/analyser_provider.dart';
import 'providers/wardrobe_provider.dart';

class BeyondHueApp extends StatelessWidget {
  const BeyondHueApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AnalyserProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WardrobeProvider(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BeyondHue',
        theme: AppTheme.lightTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}