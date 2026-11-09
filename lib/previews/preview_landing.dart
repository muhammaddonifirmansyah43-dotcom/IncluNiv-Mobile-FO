
import 'package:flutter/material.dart';
import '../features/auth/landing/landing_page.dart';

void main() {
  runApp(const PreviewLandingApp());
}

class PreviewLandingApp extends StatelessWidget {
  const PreviewLandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IniClUniv Landing Preview',
      home: LandingPage(),
    );
  }
}
