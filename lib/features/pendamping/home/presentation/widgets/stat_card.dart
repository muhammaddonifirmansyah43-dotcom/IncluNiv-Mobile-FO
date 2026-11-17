
import 'package:flutter/material.dart';
import '../home_style.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color background;
  final Color iconColor;
  final Color iconBackground;
  final Color textColor;
  final Color countColor;
  final bool showDot;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    required this.background,
    required this.iconColor,
    required this.iconBackground,
    required this.textColor,
    required this.countColor,
    this.showDot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = background == HomeColors.navy;
    final radius = BorderRadius.circular(14);

    return Material(
      color: background,
      elevation: 5,
      shadowColor: const Color(0x590F2D5B),
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 88,
          padding: const EdgeInsets.fromLTRB(9, 12, 9, 9),
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            border: Border.all(
              color: isDark
                  ? const Color(0xFF0F2D5B)
                  : const Color(0xFFE1E7F2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: iconColor,
                    ),
                  ),
                  const Spacer(),
                  if (showDot) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: countColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: countColor,
                      height: 1,
                    ),
                  ),
                ],
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  maxLines: 1,
                  style: HomeText.statLabel(textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
