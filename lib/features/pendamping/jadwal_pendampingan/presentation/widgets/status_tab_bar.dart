import 'package:flutter/material.dart';
import '../../data/jadwal_dummy.dart';
import '../jadwal_style.dart';

class StatusTabBar extends StatelessWidget {
  final JadwalStatus selected;
  final int Function(JadwalStatus) countOf;
  final ValueChanged<JadwalStatus> onChanged;

  const StatusTabBar({
    super.key,
    required this.selected,
    required this.countOf,
    required this.onChanged,
  });

  static const _tabs = <_TabData>[
    _TabData(JadwalStatus.akanDatang, 'Akan Datang',
        Icons.calendar_month_outlined),
    _TabData(JadwalStatus.berlangsung, 'Berlangsung', Icons.sync),
    _TabData(JadwalStatus.selesai, 'Selesai', Icons.check_circle_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _TabChip(
              data: _tabs[i],
              count: countOf(_tabs[i].status),
              isSelected: _tabs[i].status == selected,
              onTap: () => onChanged(_tabs[i].status),
            ),
          ),
        ],
      ],
    );
  }
}

class _TabData {
  final JadwalStatus status;
  final String label;
  final IconData icon;
  const _TabData(this.status, this.label, this.icon);
}

class _TabChip extends StatelessWidget {
  final _TabData data;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.data,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? JadwalColors.white : JadwalColors.navy;
    final countText = count == 0 ? '-' : '$count';
    final iconColor = isSelected ? JadwalColors.white : JadwalColors.blue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? JadwalColors.tabActive
                : JadwalColors.lightBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [jadwalShadow],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(data.icon, size: 18, color: iconColor),
                const SizedBox(width: 5),
                Text('${data.label} ($countText)',
                style: JadwalText.tab(fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}