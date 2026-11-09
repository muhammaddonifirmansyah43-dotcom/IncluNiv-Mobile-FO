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
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: MhsText.fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: valueColor,
                      ),
                    ),
                    Row(
                      children: [
                        if (orangeDot) ...[
                          const Icon(
                            Icons.circle,
                            size: 7,
                            color: MhsColors.orange,
                          ),
                          const SizedBox(width: 5),
                        ],
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontFamily: MhsText.fontFamily,
                              fontSize: 12,
                              color: labelColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
