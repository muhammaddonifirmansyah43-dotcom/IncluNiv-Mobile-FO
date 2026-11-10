import 'package:flutter/material.dart';

import 'jadwal_kegiatan_theme.dart';

/// Bar atas sederhana (panah kembali) sesuai desain Figma.
/// Ini BUKAN sidebar. Jika layout buatan rekan sudah menyediakan bar atas,
/// gunakan `JadwalKegiatanPage(tampilkanAppBar: false)`.
class JkTopBar extends StatelessWidget {
  const JkTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final atas = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: atas),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F4FF),
        border: Border(
          bottom: BorderSide(color: JkColors.border, width: 1.5),
        ),
      ),
      child: SizedBox(
        height: 52,
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 30,
              color: JkColors.navy,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
    );
  }
}