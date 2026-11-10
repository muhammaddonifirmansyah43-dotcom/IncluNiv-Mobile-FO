import 'package:flutter/material.dart';

import 'jadwal_kegiatan_theme.dart';

/// Tombol lokal modul Jadwal Kegiatan.
/// - [kompak] = true  -> tombol kecil (seperti "Pengisian Jadwal"), ikon di kanan.
/// - [kompak] = false -> tombol selebar penuh (seperti "Simpan Jadwal"), ikon di kiri.
class JkTombol extends StatelessWidget {
  const JkTombol({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.background = JkColors.navy,
    this.foreground = JkColors.white,
    this.kompak = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final bool kompak;

  @override
  Widget build(BuildContext context) {
    final teks = Text(
      label,
      style: TextStyle(
        fontSize: kompak ? 12 : 14,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
    );

    final ikon = icon == null
        ? null
        : Icon(icon, size: kompak ? 16 : 20, color: foreground);

    return Material(
      color: background,
      elevation: kompak ? 3 : 0,
      shadowColor: JkColors.navy,
      borderRadius: BorderRadius.circular(kompak ? 10 : 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(kompak ? 10 : 12),
        onTap: onPressed,
        child: Container(
          height: kompak ? 36 : 48,
          width: kompak ? null : double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kompak ? 14 : 16),
          child: Row(
            mainAxisSize: kompak ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (ikon != null && !kompak) ...[ikon, const SizedBox(width: 8)],
              teks,
              if (ikon != null && kompak) ...[const SizedBox(width: 8), ikon],
            ],
          ),
        ),
      ),
    );
  }
}