import 'package:flutter/material.dart';
import '../home_style.dart';

/// App bar beranda: hamburger (kiri) + logo IncluNiv (kanan, opsional).
/// Hamburger hanya memanggil callback; sidebar dibuat oleh rekan lain.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final bool showLogo;

  const HomeAppBar({super.key, this.onMenuTap, this.showLogo = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HomeColors.lightBlue,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: HomeColors.navy, size: 28),
        onPressed: onMenuTap,
      ),
      actions: showLogo
          ? const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: _Logo(),
              ),
            ]
          : null,
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
            style: HomeText.greeting.copyWith(fontSize: 22),
            children: const [
              TextSpan(text: 'Inclu'),
              TextSpan(
                text: 'Niv',
                style: TextStyle(color: HomeColors.orange),
              ),
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
              colors: [HomeColors.blue, HomeColors.navy],
            ),
          ),
          child: const Icon(Icons.school, size: 18, color: HomeColors.white),
        ),
      ],
    );
  }
}