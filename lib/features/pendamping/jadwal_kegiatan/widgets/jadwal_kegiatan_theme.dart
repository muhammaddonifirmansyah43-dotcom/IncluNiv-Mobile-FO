import 'package:flutter/material.dart';

/// Warna lokal modul Jadwal Kegiatan (tidak mengubah theme global).
class JkColors {
  JkColors._();

  // Palette resmi InclUniv
  static const Color navy = Color(0xFF0F2D5B);
  static const Color blue = Color(0xFF3B82F6);
  static const Color orange = Color(0xFFF97316);
  static const Color lightBlue = Color(0xFFE6F0FF);
  static const Color white = Color(0xFFFFFFFF);

  // Warna netral pendukung (di luar palette, untuk border/hint/error)
  static const Color border = Color(0xFFD9E2F2);
  static const Color shadow = Color(0x1A0F2D5B);
  static const Color fieldFill = Color(0xFFF1F5FB);
  static const Color hint = Color(0xFF8A97AD);
  static const Color muted = Color(0xFF6B7A90);
  static const Color danger = Color(0xFFE53935);
}

/// Gaya teks lokal. Font family mengikuti theme global aplikasi.
class JkText {
  JkText._();

  static const TextStyle h1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: JkColors.navy,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: JkColors.navy,
  );

  static const TextStyle body = TextStyle(
    fontSize: 12,
    color: JkColors.muted,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: JkColors.navy,
  );
}