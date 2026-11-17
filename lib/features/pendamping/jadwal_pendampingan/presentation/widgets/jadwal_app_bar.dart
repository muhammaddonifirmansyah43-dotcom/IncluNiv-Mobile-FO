
import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_logo.dart';
import '../jadwal_style.dart';

/// AppBar Jadwal Pendampingan.
/// Kiri: tombol kembali.
/// Kanan: gambar aplikasi dan tulisan IncluNiv.
class JadwalAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const JadwalAppBar({
    super.key,
    required this.onBack,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: JadwalColors.lightBlue,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      scrolledUnderElevation: 3,
      shadowColor: JadwalColors.navy.withAlpha(90),

      leading: IconButton(
        tooltip: 'Kembali',
        icon: const Icon(
          Icons.arrow_back,
          color: JadwalColors.navy,
          size: 30,
        ),
        onPressed: onBack,
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/landing_illustration.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 7),
                const AppLogo(fontSize: 23),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
