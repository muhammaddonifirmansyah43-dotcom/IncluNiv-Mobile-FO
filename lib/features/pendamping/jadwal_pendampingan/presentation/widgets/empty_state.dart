import 'package:flutter/material.dart';
import '../jadwal_style.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;

  const EmptyState({
    super.key,
    this.title = 'Jadwal tidak tersedia',
    this.message = 'Belum ada jadwal pendampingan pada kategori ini. '
        'Silakan tambahkan jadwal baru untuk memulai sesi pendampingan.',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        children: [
          const _Illustration(),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: JadwalText.title.copyWith(
                fontSize: 20, color: JadwalColors.orange),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: JadwalText.subtitle.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ilustrasi kalender sedih (dibuat dari widget).
class _Illustration extends StatelessWidget {
  const _Illustration();

  Widget _ring() => Container(
        width: 9,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(5),
        ),
      );

  Widget _eye() => Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: Color(0xFF94A3B8),
          shape: BoxShape.circle,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 220,
      child: Stack(
        children: [
          // gelembung latar
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              width: 112,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFFDDEEFF),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 44,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFB7CDF0),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // bayangan di bawah kalender
          Positioned(
            left: 36,
            right: 36,
            bottom: 8,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: JadwalColors.blue.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: JadwalColors.blue.withAlpha(40),
                    blurRadius: 14,
                  ),
                ],
              ),
            ),
          ),
          // badan kalender (oranye) + isi putih
          Positioned(
            left: 50,
            top: 28,
            child: Container(
              width: 130,
              height: 150,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: JadwalColors.orange,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: JadwalColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _eye(),
                          const SizedBox(width: 18),
                          _eye(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      // mulut sedih
                      Container(
                        width: 28,
                        height: 12,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Color(0xFFCBD5E1), width: 2),
                          ),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // cincin kalender
          Positioned(left: 78, top: 18, child: _ring()),
          Positioned(left: 143, top: 18, child: _ring()),
          // hiasan
          const Positioned(
            left: 158,
            top: 62,
            child: Icon(Icons.auto_awesome,
                size: 14, color: Color(0xFF38BDF8)),
          ),
          Positioned(
            left: 58,
            top: 140,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: JadwalColors.orange.withAlpha(120),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // lencana peringatan
          Positioned(
            right: 58,
            bottom: 20,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFB923C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: JadwalColors.white, width: 3),
                boxShadow: [jadwalShadow],
              ),
              child: const Icon(Icons.warning_amber_rounded,
                  size: 26, color: JadwalColors.white),
            ),
          ),
        ],
      ),
    );
  }
}