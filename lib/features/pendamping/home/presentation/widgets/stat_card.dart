import 'package:flutter/material.dart';
import '../home_style.dart';

class StatCard extends StatelessWidget {
  final IconData icon;

  /// null -> ditampilkan sebagai "-" (belum ada jadwal).
  final int? count;
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
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [homeCardShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: SizedBox(
              height: 78,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: iconBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, size: 20, color: iconColor),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showDot)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 3),
                              decoration: BoxDecoration(
                                color: countColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(count?.toString() ?? '-',
                              style: HomeText.statCount(countColor)),
                        ],
                      ),
                    ],
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(label, style: HomeText.statLabel(textColor)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}