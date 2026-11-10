import 'package:flutter/material.dart';

class JadwalColors {
  static const Color navy = Color(0xFF0F2D5B);
  static const Color blue = Color(0xFF3B82F6);
  static const Color orange = Color(0xFFF97316);
  static const Color lightBlue = Color(0xFFE6F0FF);
  static const Color white = Color(0xFFFFFFFF);

  // Di luar palet resmi, diambil dari tampilan Figma.
  static const Color tabActive = Color(0xFF0052CC);
  static const Color slate = Color(0xFF64748B);
}

class JadwalText {
  // Ganti setelah font tim didaftarkan di pubspec.yaml. null = font default.
  static const String? fontFamily = null;

  static TextStyle _base(double size, FontWeight weight, Color color,
          {double? height}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  static TextStyle title = _base(24, FontWeight.w800, JadwalColors.navy);
  static TextStyle subtitle =
      _base(14, FontWeight.w400, JadwalColors.slate, height: 1.4);
  static TextStyle tab(Color c) => _base(12, FontWeight.w700, c);
  static TextStyle courseTitle =
      _base(19, FontWeight.w700, JadwalColors.navy, height: 1.2);
  static TextStyle courseSub =
      _base(14, FontWeight.w400, JadwalColors.slate);
  static TextStyle dateBold = _base(15, FontWeight.w500, JadwalColors.navy);
  static TextStyle dateLight =
      _base(14, FontWeight.w400, JadwalColors.slate);
  static TextStyle infoRow =
      _base(15, FontWeight.w500, JadwalColors.navy, height: 1.3);
  static TextStyle sideInfo =
      _base(12, FontWeight.w600, JadwalColors.navy, height: 1.3);
  static TextStyle disability =
      _base(12, FontWeight.w500, JadwalColors.slate);
  static TextStyle button = _base(12, FontWeight.w700, JadwalColors.white);
  static TextStyle emptyTitle =
      _base(16, FontWeight.w700, JadwalColors.navy);
  static TextStyle logo = _base(22, FontWeight.w800, JadwalColors.navy);
}

BoxShadow get jadwalShadow => BoxShadow(
      color: JadwalColors.navy.withAlpha(46),
      blurRadius: 10,
      offset: const Offset(0, 4),
    );