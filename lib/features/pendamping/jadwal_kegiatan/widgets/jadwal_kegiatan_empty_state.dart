import 'package:flutter/material.dart';

import 'jadwal_kegiatan_theme.dart';

/// Tampilan "Jadwal tidak tersedia" (gambar paling kiri di Figma).
/// Ilustrasi dibuat dari widget Flutter. Jika kamu punya aset hasil export
/// Figma (PNG/SVG), ganti bagian [_Ilustrasi] dengan Image.asset(...).
class JkEmptyState extends StatelessWidget {
  const JkEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _Ilustrasi(),
          SizedBox(height: 12),
          Text(
            'Jadwal tidak tersedia',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: JkColors.orange,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Belum ada jadwal kegiatan pada kategori ini. '
            'Silakan tambahkan jadwal baru untuk memulai sesi pendampingan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, height: 1.5, color: JkColors.muted),
          ),
        ],
      ),
    );
  }
}

class _Ilustrasi extends StatelessWidget {
  const _Ilustrasi();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Awan / blob biru muda kiri atas
          Positioned(
            left: 0,
            top: 6,
            child: Container(
              width: 120,
              height: 52,
              decoration: BoxDecoration(
                color: JkColors.lightBlue,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          // Lingkaran biru kanan
          Positioned(
            right: 6,
            top: 34,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFD3E2FA),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bayangan di bawah kalender
          Positioned(
            left: 40,
            right: 40,
            bottom: 6,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: JkColors.lightBlue,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          // Kalender oranye
          Positioned(
            left: 52,
            top: 34,
            child: Container(
              width: 128,
              height: 128,
              padding: const EdgeInsets.fromLTRB(6, 18, 6, 6),
              decoration: BoxDecoration(
                color: JkColors.orange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: JkColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(child: _WajahSedih()),
              ),
            ),
          ),
          // Dua cincin kalender
          Positioned(
            left: 84,
            top: 24,
            child: _cincin(),
          ),
          Positioned(
            left: 148,
            top: 24,
            child: _cincin(),
          ),
          // Bintang kecil
          const Positioned(
            right: 62,
            top: 56,
            child: Icon(Icons.auto_awesome, size: 14, color: JkColors.blue),
          ),
          // Titik oranye kecil
          Positioned(
            left: 52,
            bottom: 38,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: JkColors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Badge peringatan
          Positioned(
            right: 54,
            bottom: 26,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: JkColors.orange,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: JkColors.white, width: 3),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: JkColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cincin() {
    return Container(
      width: 8,
      height: 22,
      decoration: BoxDecoration(
        color: JkColors.navy,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _WajahSedih extends StatelessWidget {
  const _WajahSedih();

  @override
  Widget build(BuildContext context) {
    const mata = BoxDecoration(color: Color(0xFF9AA8C0), shape: BoxShape.circle);

    return SizedBox(
      width: 44,
      height: 32,
      child: Stack(
        children: [
          Positioned(
            left: 2,
            top: 2,
            child: Container(width: 9, height: 9, decoration: mata),
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Container(width: 9, height: 9, decoration: mata),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 0,
            child: CustomPaint(
              size: const Size(20, 10),
              painter: _MulutSedihPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MulutSedihPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9AA8C0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}