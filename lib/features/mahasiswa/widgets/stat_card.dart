
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
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 17,
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
              const SizedBox(height: 9),
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
                        fontWeight: FontWeight.w500,
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
