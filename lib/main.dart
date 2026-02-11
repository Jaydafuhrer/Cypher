import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ui/generator_screen.dart';

void main() {
  runApp(const CipherShieldApp());
}

class CipherShieldApp extends StatelessWidget {
  const CipherShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const GeneratorScreen(),
    );
  }
}
