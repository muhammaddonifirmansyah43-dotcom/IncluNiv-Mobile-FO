import 'package:flutter/material.dart';

/// Helper format khusus modul Jadwal Kegiatan (tanpa package intl).
class JkFormat {
  JkFormat._();

  static const List<String> hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _bulanPanjang = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _bulanSingkat = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Nama hari dari DateTime (weekday 1 = Senin).
  static String namaHari(DateTime d) => hari[d.weekday - 1];

  /// Contoh: 15 Oktober 2025
  static String tanggalPanjang(DateTime d) =>
      '${d.day} ${_bulanPanjang[d.month - 1]} ${d.year}';

  /// Contoh: 15 Okt 2025
  static String tanggalSingkat(DateTime d) =>
      '${d.day} ${_bulanSingkat[d.month - 1]} ${d.year}';

  /// Contoh: 07:00
  static String jam(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

/// Model jadwal kegiatan (dummy, belum terhubung backend).
class JadwalKegiatan {
  const JadwalKegiatan({
    required this.id,
    required this.mataKuliah,
    required this.hari,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.gedung,
    required this.ruangan,
  });

  final String id;
  final String mataKuliah;
  final String hari;
  final DateTime tanggal;
  final TimeOfDay jamMulai;
  final TimeOfDay jamSelesai;
  final String gedung;
  final String ruangan;

  int get menitMulai => jamMulai.hour * 60 + jamMulai.minute;

  String get waktuLabel =>
      '${JkFormat.jam(jamMulai)} - ${JkFormat.jam(jamSelesai)}';

  String get hariTanggalLabel => '$hari, ${JkFormat.tanggalPanjang(tanggal)}';
}