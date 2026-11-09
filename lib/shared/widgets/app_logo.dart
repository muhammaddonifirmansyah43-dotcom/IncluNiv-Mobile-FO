
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;

  const AppLogo({
    super.key,
    this.fontSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Inclu',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F2D5B),
            letterSpacing: -1.2,
          ),
        ),
        Text(
          'Niv',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFF97316),
            letterSpacing: -1.2,
          ),
        ),
      ],
    );
  }
}
