
import 'package:flutter/material.dart';

class AppIllustration extends StatelessWidget {
  final double size;

  const AppIllustration({
    super.key,
    this.size = 210,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/landing_illustration.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  color: Color(0xFF0F2D5B),
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Ilustrasi tidak ditemukan',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
