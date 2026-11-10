// Entry point MANDIRI untuk menguji halaman Jadwal Kegiatan.
// Tidak menyentuh main.dart, routing, atau theme global milik tim.
//
// Jalankan dari root project:
//   flutter run -t lib/features/pendamping/jadwal_kegiatan/jadwal_kegiatan_preview.dart
//
// File ini hanya untuk pengujian lokal; boleh dihapus sebelum commit jika
// tim tidak menginginkannya.

import 'package:flutter/material.dart';

import 'data/jadwal_kegiatan_store.dart';
import 'pages/jadwal_kegiatan_page.dart';
import 'widgets/jadwal_kegiatan_theme.dart';

/// Ubah ke true untuk langsung melihat tampilan kartu (gambar tengah).
const bool isiDataContoh = false;

void main() {
  if (isiDataContoh) {
    JadwalKegiatanStore.instance.muatContoh();
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: JkColors.blue),
      ),
      home: const JadwalKegiatanPage(),
    ),
  );
}