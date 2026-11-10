import 'package:flutter/material.dart';
import '../home_style.dart';

/// Gelembung dekoratif latar belakang (mengikuti Figma).
/// Pasang sebagai Positioned.fill di dalam Stack konten yang ter-scroll.
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  static final Color _peach = HomeColors.orange.withAlpha(36);

  Widget _bubble(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  Widget _ring(double size, Color color, double width) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: width),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Cincin oranye (kiri atas)
              Positioned(
                left: -135,
                top: -170,
                child: _ring(210, HomeColors.orange, 7),
              ),

              // Lingkaran peach besar (kanan atas)
              Positioned(
                right: -45,
                top: -50,
                child: _bubble(150, _peach),
              ),

              // Lingkaran biru muda (kanan, di bawah peach)
              Positioned(
                right: -40,
                top: 69,
                child: _bubble(90, HomeColors.lightBlue),
              ),

              // Titik biru muda kecil (dekat teks deskripsi)
              Positioned(
                left: w * 0.58,
                top: 155,
                child: _bubble(18, HomeColors.lightBlue),
              ),

              // Titik peach kecil (kanan, dekat judul "Berlangsung")
              Positioned(
                right: 3,
                top: 308,
                child: _bubble(18, HomeColors.orange.withAlpha(60)),
              ),

              // Lingkaran peach besar (kanan bawah)
              Positioned(
                right: -48,
                bottom: -63,
                child: _bubble(150, _peach),
              ),
            ],
          );
        },
      ),
    );
  }
}