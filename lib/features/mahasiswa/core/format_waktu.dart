import 'package:flutter/material.dart';

const List<String> daftarHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const List<String> _namaBulan = [
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

String namaHari(DateTime d) => daftarHari[d.weekday - 1];

String formatTanggal(DateTime d) =>
    '${namaHari(d)}, ${d.day} ${_namaBulan[d.month - 1]} ${d.year}';

String formatJam(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
