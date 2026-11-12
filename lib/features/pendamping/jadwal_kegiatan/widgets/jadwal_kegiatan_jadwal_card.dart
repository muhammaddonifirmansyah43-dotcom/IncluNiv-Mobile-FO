import 'package:flutter/material.dart';

import '../data/jadwal_kegiatan_model.dart';
import 'jadwal_kegiatan_theme.dart';

/// Kartu jadwal (gambar tengah di Figma).
class JkJadwalCard extends StatelessWidget {
  const JkJadwalCard({super.key, required this.jadwal, this.onTap});

  final JadwalKegiatan jadwal;
  final VoidCallback? onTap;

  // Palet resmi (dipakai langsung agar tidak bergantung isi JkColors).
  static const Color _navy = Color(0xFF0F2D5B);
  static const Color _blue = Color(0xFF3B82F6);
  static const Color _lightBlue = Color(0xFFE6F0FF);

  static final BoxShadow _shadow = BoxShadow(
    color: _navy.withAlpha(46),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _lightBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [_shadow],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _blue.withAlpha(46),
                      ),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        size: 24,
                        color: _blue,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        jadwal.mataKuliah,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _navy,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: JkColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [_shadow],
                  ),
                  child: Column(
                    children: [
                      _Baris(
                          label: 'Hari, Tanggal',
                          nilai: jadwal.hariTanggalLabel),
                      const SizedBox(height: 12),
                      _Baris(label: 'Waktu', nilai: jadwal.waktuLabel),
                      const SizedBox(height: 12),
                      _Baris(label: 'Gedung', nilai: jadwal.gedung),
                      const SizedBox(height: 12),
                      _Baris(label: 'Ruang', nilai: jadwal.ruangan),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Baris extends StatelessWidget {
  const _Baris({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    const gaya = TextStyle(
      fontSize: 14,
      color: Color(0xFF334155),
      height: 1.3,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 108,
          child: Text(
            label,
            style: gaya.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F2D5B),
            ),
          ),
        ),
        const Text(': ', style: gaya),
        Expanded(child: Text(nilai, style: gaya)),
      ],
    );
  }
}