import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';

class MhsStatCard extends StatelessWidget {
  const MhsStatCard({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.background,
    required this.valueColor,
    required this.labelColor,
    this.orangeDot = false,
    this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String value;
  final String label;
  final Color background;
  final Color valueColor;
  final Color labelColor;
  final bool orangeDot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final adaBorder = background == MhsColors.white;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        // Kartu putih diberi border tipis (oranye untuk "Berlangsung").
        border: adaBorder
            ? Border.all(
                color: (orangeDot ? MhsColors.orange : MhsColors.border)
                    .withValues(alpha: .35)
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x260F2D5B),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 18),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: MhsText.fontFamily,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: valueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (orangeDot) ...[
                      const Icon(
                        Icons.circle,
                        size: 6,
                        color: MhsColors.orange,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: MhsText.fontFamily,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: labelColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}