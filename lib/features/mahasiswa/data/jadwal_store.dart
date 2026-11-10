import 'package:flutter/material.dart';

import '../core/format_waktu.dart';
import 'jadwal_model.dart';

/// Penyimpan jadwal sementara (dummy, hanya di memori).
/// Mulai dalam keadaan kosong, sesuai alur "sebelum upload jadwal".
class JadwalStore extends ChangeNotifier {
  JadwalStore._();

  static final JadwalStore instance = JadwalStore._();

  final List<Jadwal> _items = [];

  bool get kosong => _items.isEmpty;

  List<Jadwal> daftar(JadwalStatus status) {
    final now = DateTime.now();

    final hasil = _items.where((j) => j.statusPada(now) == status).toList()
      ..sort((a, b) => a.mulai.compareTo(b.mulai));

    return status == JadwalStatus.selesai ? hasil.reversed.toList() : hasil;
  }

  int jumlah(JadwalStatus status) => daftar(status).length;

  void tambah(Jadwal jadwal) {
    _items.add(jadwal);
    notifyListeners();
  }

  void kosongkan() {
    _items.clear();
    notifyListeners();
  }

  /// Data contoh: 1 berlangsung, 4 akan datang, 18 selesai.
  void isiDataContoh() {
    final now = DateTime.now();
    _items.clear();

    _items.add(
      _contoh(
        'Pancasila',
        now.subtract(const Duration(minutes: 30)),
        const Duration(hours: 2),
      ),
    );

    const akan = [
      'Interaksi Manusia & Komputer',
      'Desain UI UX',
      'Pemrograman Web',
      'Agama Islam',
    ];

    for (var i = 0; i < akan.length; i++) {
      _items.add(
        _contoh(
          akan[i],
          now.add(Duration(days: i + 1)),
          const Duration(hours: 2),
        ),
      );
    }

    const selesai = [
      'Basis Data',
      'Algoritma',
      'Statistika',
      'Kalkulus',
      'Jaringan Komputer',
      'Sistem Operasi',
      'Struktur Data',
      'Bahasa Inggris',
      'Kewarganegaraan',
    ];

    for (var i = 0; i < 18; i++) {
      _items.add(
        _contoh(
          selesai[i % selesai.length],
          now.subtract(Duration(days: i + 1)),
          const Duration(hours: 2),
        ),
      );
    }

    notifyListeners();
  }

  Jadwal _contoh(String mk, DateTime start, Duration durasi) {
    final end = start.add(durasi);

    return Jadwal(
      id: '${mk.hashCode}-${start.microsecondsSinceEpoch}',
      mataKuliah: mk,
      hari: namaHari(start),
      tanggalMulai: DateTime(start.year, start.month, start.day),
      jamMulai: TimeOfDay(hour: start.hour, minute: start.minute),
      jamSelesai: TimeOfDay(hour: end.hour, minute: end.minute),
      gedung: 'Gedung F FILKOM',
      ruangan: 'Ruang 3.2',
      dosen: 'Dr. Eng. Herman Tolle, S.T., M.T.',
      pendamping: Pendamping.contoh,
    );
  }
}
