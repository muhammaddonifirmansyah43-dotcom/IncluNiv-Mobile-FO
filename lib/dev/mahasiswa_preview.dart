import 'package:flutter/material.dart';

import '../features/mahasiswa/data/jadwal_store.dart';
import '../features/mahasiswa/core/mhs_colors.dart';
import '../features/mahasiswa/pages/beranda_page.dart';

void main() => runApp(const MahasiswaPreviewApp());

class MahasiswaPreviewApp extends StatelessWidget {
  const MahasiswaPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preview Mahasiswa',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: MhsColors.navy),
        scaffoldBackgroundColor: MhsColors.white,
      ),
      home: const BerandaMahasiswaPage(),
      // Tombol bantu khusus uji: tidak ikut ke aplikasi sebenarnya.
      builder: (context, child) => Stack(
        children: [
          child!,
          Positioned(
            left: 8,
            bottom: 8,
            child: Material(
              color: const Color(0xCC000000),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: JadwalStore.instance.kosongkan,
                    child: const Text(
                      'Kosongkan',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  TextButton(
                    onPressed: JadwalStore.instance.isiDataContoh,
                    child: const Text(
                      'Data contoh',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
