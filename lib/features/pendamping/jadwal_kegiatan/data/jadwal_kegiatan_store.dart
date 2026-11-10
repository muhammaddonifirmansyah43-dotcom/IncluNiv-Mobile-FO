import 'package:flutter/material.dart';

import 'jadwal_kegiatan_model.dart';

/// Penyimpanan sementara (in-memory) untuk jadwal kegiatan.
/// Nanti bisa diganti repository/API saat backend sudah siap.
class JadwalKegiatanStore {
  JadwalKegiatanStore._();

  static final JadwalKegiatanStore instance = JadwalKegiatanStore._();

  final ValueNotifier<List<JadwalKegiatan>> daftar =
      ValueNotifier<List<JadwalKegiatan>>(<JadwalKegiatan>[]);

  void tambah(JadwalKegiatan jadwal) {
    daftar.value = [...daftar.value, jadwal];
  }

  void hapus(String id) {
    daftar.value = daftar.value.where((j) => j.id != id).toList();
  }

  void kosongkan() => daftar.value = <JadwalKegiatan>[];

  /// Isi data contoh untuk uji tampilan (sesuai desain Figma).
  void muatContoh() {
    daftar.value = [
      JadwalKegiatan(
        id: 'contoh-1',
        mataKuliah: 'Pemrograman Mobile',
        hari: 'Senin',
        tanggal: DateTime(2025, 10, 13), // 13 Okt 2025 = hari Senin
        jamMulai: const TimeOfDay(hour: 7, minute: 0),
        jamSelesai: const TimeOfDay(hour: 10, minute: 20),
        gedung: 'Gedung Vokasi',
        ruangan: 'Ruang A403. Lt. 4',
      ),
    ];
  }
}