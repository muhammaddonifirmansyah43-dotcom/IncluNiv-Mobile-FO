
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
    final radius = BorderRadius.circular(13);
    final adaBorder = background == MhsColors.white;

    return Material(
      color: background,
      elevation: 5,
      shadowColor: const Color(0x590F2D5B),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: adaBorder
                ? Border.all(
                    color: (orangeDot
                            ? MhsColors.orange
                            : MhsColors.border)
                        .withValues(alpha: 0.35),
                    width: 0.8,
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                      color: iconColor,
                      size: 16,
                    ),
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
              const SizedBox(height: 10),
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
                        fontSize: 10,
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
    );
  }
}
