import 'package:flutter/material.dart';
import '../home_style.dart';

class JadwalPerkuliahanButton extends StatelessWidget {
  final VoidCallback onTap;

  const JadwalPerkuliahanButton({super.key, required this.onTap});

  // Biru lebih gelap dari palet, diambil dari tampilan Figma.
  static const Color _buttonBlue = Color(0xFF0052CC);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _buttonBlue,
      elevation: 3,
      shadowColor: HomeColors.navy.withAlpha(120),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_calendar_outlined,
                  size: 20, color: HomeColors.white),
              const SizedBox(width: 8),
              Text(
                'Jadwal Perkuliahan',
                style: HomeText.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}