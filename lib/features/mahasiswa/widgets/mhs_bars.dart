import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';

const BoxDecoration _barDecoration = BoxDecoration(
  color: MhsColors.barBg,
  boxShadow: [
    BoxShadow(color: MhsColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
  ],
);

class MhsLogo extends StatelessWidget {
  const MhsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Placeholder logo. Ganti dengan Image.asset kalau aset logo sudah ada.
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: MhsColors.navy,
            border: Border.fromBorderSide(
              BorderSide(color: MhsColors.orange, width: 2.5),
            ),
          ),
          child: const Icon(
            Icons.accessibility_new_rounded,
            size: 18,
            color: MhsColors.white,
          ),
        ),
        const SizedBox(width: 8),
        const Text.rich(
          TextSpan(
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
            fontSize: 24,
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

/// Header halaman dalam: panah kembali, judul (opsional), avatar.
class MhsSubAppBar extends StatelessWidget {
  const MhsSubAppBar({super.key, this.title, this.onAvatarTap});

  final String? title;
  final VoidCallback? onAvatarTap;

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
          MhsAvatarButton(onTap: onAvatarTap),
        ],
      ),
    );
  }
}
