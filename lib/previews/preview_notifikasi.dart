import 'package:flutter/material.dart';
import '../features/pendamping/notifikasi/notifikasi_page.dart';

void main() {
  runApp(const PreviewNotifikasiApp());
}

class PreviewNotifikasiApp extends StatelessWidget {
  const PreviewNotifikasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preview Notifikasi IniClUniv',
      home: NotifikasiPage(),
    );
  }
}