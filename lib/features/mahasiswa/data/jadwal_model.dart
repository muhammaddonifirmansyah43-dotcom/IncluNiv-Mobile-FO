import 'package:flutter/material.dart';

import '../core/format_waktu.dart';

enum JadwalStatus { akanDatang, berlangsung, selesai }

class Pendamping {
  const Pendamping({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.whatsapp,
  });

  final String nama;
  final String nim;
  final String prodi;
  final String whatsapp;

  String get inisial {
    final p = nama.trim().split(RegExp(r'\s+'));

    if (p.length == 1) return p.first[0].toUpperCase();

    return (p.first[0] + p[1][0]).toUpperCase();
  }

  /// Dummy. Nanti diganti hasil pencocokan dari backend.
  static const Pendamping contoh = Pendamping(
    nama: 'Dimas Arya Pratama',
    nim: '225150201111045',
    prodi: "FILKOM • S1 Teknik Informatika '22",
    whatsapp: '0812-980-7654',
  );
}

class Jadwal {
  const Jadwal({
    required this.id,
    required this.mataKuliah,
    required this.hari,
    required this.tanggalMulai,
    required this.jamMulai,
    required this.jamSelesai,
    required this.gedung,
    required this.ruangan,
    required this.pendamping,
    this.dosen,
  });

  final String id;
  final String mataKuliah;
  final String hari;
  final DateTime tanggalMulai;
  final TimeOfDay jamMulai;
  final TimeOfDay jamSelesai;
  final String gedung;
  final String ruangan;
  final String? dosen;
  final Pendamping pendamping;

  String get lokasi => ruangan.isEmpty ? gedung : '$gedung, $ruangan';

  String get rentangJam =>
      '${formatJam(jamMulai)} - ${formatJam(jamSelesai)} WIB';

  DateTime get mulai => DateTime(
    tanggalMulai.year,
    tanggalMulai.month,
    tanggalMulai.day,
    jamMulai.hour,
    jamMulai.minute,
  );

  DateTime get selesai {
    var s = DateTime(
      tanggalMulai.year,
      tanggalMulai.month,
      tanggalMulai.day,
      jamSelesai.hour,
      jamSelesai.minute,
    );

    if (!s.isAfter(mulai)) {
      s = s.add(const Duration(days: 1));
    }

    return s;
  }

  /// Status dihitung dari tanggal dan jam.
  JadwalStatus statusPada(DateTime now) {
    if (now.isBefore(mulai)) {
      return JadwalStatus.akanDatang;
    }

    if (now.isBefore(selesai)) {
      return JadwalStatus.berlangsung;
    }

    return JadwalStatus.selesai;
  }
}
