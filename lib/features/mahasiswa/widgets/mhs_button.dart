import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';

class MhsButton extends StatelessWidget {
  const MhsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.background = MhsColors.blue,
    this.foreground = MhsColors.white,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: MhsText.fontFamily,
                  color: foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
