
import 'package:flutter/material.dart';
import '../features/auth/register/register_page.dart';

void main() {
  runApp(const PreviewRegisterApp());
}

class PreviewRegisterApp extends StatelessWidget {
  const PreviewRegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IniClUniv Register Preview',
      home: RegisterPage(),
    );
  }
}
