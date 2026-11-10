import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';

const BoxDecoration _barDecoration = BoxDecoration(
  color: MhsColors.barBg,
  boxShadow: [
    BoxShadow(color: MhsColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
  ],
);

/// Lokasi aset logo (harus terdaftar di pubspec.yaml).
const String _asetLogo = 'assets/images/landing_illustration.png';

class MhsLogo extends StatelessWidget {
  const MhsLogo({super.key, this.kecil = false});

  /// Versi lebih kecil untuk header halaman dalam.
  final bool kecil;

  @override
  Widget build(BuildContext context) {
    final ukuranLogo = kecil ? 30.0 : 38.0;
    final ukuranIkon = kecil ? 15.0 : 18.0;
    final ukuranTeks = kecil ? 20.0 : 24.0;

    // Cadangan kalau aset belum terdaftar / gagal dimuat.
    final cadangan = Container(
      width: ukuranLogo,
      height: ukuranLogo,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: MhsColors.navy,
        border: Border.fromBorderSide(
          BorderSide(color: MhsColors.orange, width: 2.5),
        ),
      ),
      child: Icon(
        Icons.accessibility_new_rounded,
        size: ukuranIkon,
        color: MhsColors.white,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          _asetLogo,
          width: ukuranLogo,
          height: ukuranLogo,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, _, _) => cadangan,
        ),
        const SizedBox(width: 8),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(
                text: 'Inclu',
                style: TextStyle(color: MhsColors.navy),
              ),
              TextSpan(
                text: 'Niv',
                style: TextStyle(color: MhsColors.blue),
              ),
            ],
          ),
          style: TextStyle(
            fontFamily: MhsText.fontFamily,
            fontSize: ukuranTeks,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class MhsAvatarButton extends StatelessWidget {
  const MhsAvatarButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: 'Profil',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MhsColors.white,
                    border: Border.all(color: MhsColors.border),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 22,
                    color: MhsColors.blue,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: MhsColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: MhsColors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header beranda: logo di kiri, avatar profil di kanan.
class MhsBrandBar extends StatelessWidget {
  const MhsBrandBar({super.key, required this.onProfilTap});

  final VoidCallback onProfilTap;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, top + 10, 16, 10),
      decoration: _barDecoration,
      child: Row(
        children: [
          const MhsLogo(),
          const Spacer(),
          MhsAvatarButton(onTap: onProfilTap),
        ],
      ),
    );
  }
}

/// Header halaman dalam: panah kembali, judul (opsional), lalu avatar
/// atau logo IncluNiv di kanan (kalau [logoDiKanan] true).
class MhsSubAppBar extends StatelessWidget {
  const MhsSubAppBar({
    super.key,
    this.title,
    this.onAvatarTap,
    this.logoDiKanan = false,
  });

  final String? title;
  final VoidCallback? onAvatarTap;
  final bool logoDiKanan;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, top + 8, 16, 8),
      decoration: _barDecoration,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 28,
              color: Color(0xFF94A3B8),
            ),
          ),
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: MhsText.section.copyWith(fontSize: 16),
              ),
            )
          else
            const Spacer(),
          if (logoDiKanan)
            const MhsLogo(kecil: true)
          else
            MhsAvatarButton(onTap: onAvatarTap),
        ],
      ),
    );
  }
}