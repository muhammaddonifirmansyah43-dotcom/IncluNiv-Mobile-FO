import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';
import 'mhs_button.dart';

const String _pesanDefault =
    'Belum ada jadwal pendampingan pada kategori ini. Silakan tambahkan '
    'jadwal baru untuk memulai sesi pendampingan.';

class JadwalKosongView extends StatelessWidget {
  const JadwalKosongView({super.key, this.onTambah, this.pesan});

  final VoidCallback? onTambah;
  final String? pesan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const JadwalKosongIlustrasi(),
          const SizedBox(height: 8),
          const Text(
            'Jadwal tidak tersedia',
            style: TextStyle(
              fontFamily: MhsText.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: MhsColors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              pesan ?? _pesanDefault,
              textAlign: TextAlign.center,
              style: MhsText.body,
            ),
          ),
          if (onTambah != null) ...[
            const SizedBox(height: 24),
            MhsButton(
              label: 'Tambah Jadwal Perkuliahan',
              icon: Icons.add_rounded,
              onPressed: onTambah,
            ),
          ],
        ],
      ),
    );
  }
}

class JadwalKosongIlustrasi extends StatelessWidget {
  const JadwalKosongIlustrasi({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 8,
            top: 18,
            child: Container(
              width: 120,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD9E8FF),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 58,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFC7DBF7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x330F2D5B),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          const _Kalender(),
          const Positioned(
            right: 30,
            top: 34,
            child: Icon(Icons.add, size: 12, color: MhsColors.blue),
          ),
          Positioned(
            left: 42,
            bottom: 56,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: MhsColors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 50,
            bottom: 26,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MhsColors.orange,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MhsColors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: MhsColors.shadow,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 22,
                color: MhsColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Kalender extends StatelessWidget {
  const _Kalender();

  Widget _cincin() => Container(
    width: 9,
    height: 22,
    decoration: BoxDecoration(
      color: MhsColors.navy,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: MhsColors.white, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 122,
      height: 126,
      child: Stack(
        children: [
          Positioned.fill(
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: MhsColors.orange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: MhsColors.white,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 52,
                    height: 40,
                    child: CustomPaint(painter: _WajahSedih()),
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: 0, left: 28, child: _cincin()),
          Positioned(top: 0, right: 28, child: _cincin()),
        ],
      ),
    );
  }
}

class _WajahSedih extends CustomPainter {
  const _WajahSedih();

  @override
  void paint(Canvas canvas, Size size) {
    const warna = Color(0xFF8FA3C0);
    final mata = Paint()..color = warna;

    canvas.drawCircle(Offset(size.width * 0.27, size.height * 0.2), 3.5, mata);
    canvas.drawCircle(Offset(size.width * 0.73, size.height * 0.2), 3.5, mata);

    final mulut = Paint()
      ..color = warna
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.27, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.45,
        size.width * 0.73,
        size.height * 0.9,
      );

    canvas.drawPath(path, mulut);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
