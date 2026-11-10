import 'package:flutter/material.dart';

class MhsColors {
  MhsColors._();

  // Palet resmi
  static const Color navy = Color(0xFF0F2D5B);
  static const Color blue = Color(0xFF3B82F6);
  static const Color orange = Color(0xFFF97316);
  static const Color lightBlue = Color(0xFFE6F0FF);
  static const Color white = Color(0xFFFFFFFF);

  // Warna netral
  static const Color muted = Color(0xFF64748B);
  static const Color hint = Color(0xFF8A97AD);
  static const Color border = Color(0xFFD6E2F5);
  static const Color fieldFill = Color(0xFFEEF2FF);
  static const Color barBg = Color(0xFFF1F4FF);
  static const Color shadow = Color(0x1F0F2D5B);
  static const Color danger = Color(0xFFDC2626);
  static const Color success = Color(0xFF22C55E);
}

class MhsText {
  MhsText._();

  static const String? fontFamily = null;

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: MhsColors.navy,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: MhsColors.navy,
  );

  static const TextStyle section = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: MhsColors.navy,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: MhsColors.navy,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5,
    height: 1.45,
    color: MhsColors.muted,
  );
}
