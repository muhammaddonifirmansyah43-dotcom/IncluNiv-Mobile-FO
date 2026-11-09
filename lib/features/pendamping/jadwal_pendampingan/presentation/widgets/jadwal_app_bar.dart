import 'package:flutter/material.dart';
import '../jadwal_style.dart';

/// App bar: panah kembali (kiri) + logo IncluNiv (kanan).
class JadwalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const JadwalAppBar({super.key, required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
        icon: const Icon(Icons.arrow_back,
            color: JadwalColors.navy, size: 30),
        onPressed: onBack,
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: _Logo(),
        ),
      ],
    );
  }
}

/// PLACEHOLDER: ganti dengan Image.asset(...) setelah asset logo
/// tersedia dan didaftarkan di pubspec.yaml.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: JadwalText.logo,
            children: const [
              TextSpan(text: 'Inclu'),
              TextSpan(
                  text: 'Niv',
                  style: TextStyle(color: JadwalColors.orange)),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [JadwalColors.blue, JadwalColors.navy],
            ),
          ),
          child: const Icon(Icons.school,
              size: 18, color: JadwalColors.white),
        ),
      ],
    );
  }
}