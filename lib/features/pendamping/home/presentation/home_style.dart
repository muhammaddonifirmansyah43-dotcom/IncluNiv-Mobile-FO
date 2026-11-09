import 'package:flutter/material.dart';

class HomeColors {
  static const Color navy = Color(0xFF0F2D5B);
  static const Color blue = Color(0xFF3B82F6);
  static const Color orange = Color(0xFFF97316);
  static const Color lightBlue = Color(0xFFE6F0FF);
  static const Color white = Color(0xFFFFFFFF);
}

class HomeText {
  // Ganti sesuai font tim (mis. 'PlusJakartaSans') SETELAH font
  // didaftarkan di pubspec.yaml. Jika null, memakai font default Flutter.
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

  static TextStyle greeting = _base(26, FontWeight.w800, HomeColors.navy);
  static TextStyle body =
      _base(14, FontWeight.w400, const Color(0xFF475569), height: 1.4);
  static TextStyle sectionTitle =
      _base(15, FontWeight.w600, HomeColors.navy);
  static TextStyle statLabel(Color c) => _base(12, FontWeight.w700, c);
  static TextStyle statCount(Color c) => _base(26, FontWeight.w800, c);
  static TextStyle profileLabel =
      _base(16, FontWeight.w600, const Color(0xFF1D4ED8));
  static TextStyle studentNameLarge =
      _base(28, FontWeight.w800, HomeColors.navy);
  static TextStyle studentNameXL =
      _base(34, FontWeight.w800, HomeColors.navy);
  static TextStyle detail = _base(12, FontWeight.w600, HomeColors.navy);
  static TextStyle info =
      _base(12, FontWeight.w600, HomeColors.navy, height: 1.4);
}

BoxShadow get homeCardShadow => BoxShadow(
      color: HomeColors.navy.withAlpha(46),
      blurRadius: 10,
      offset: const Offset(0, 4),
    );