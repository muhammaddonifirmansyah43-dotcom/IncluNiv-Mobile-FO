import 'package:flutter/material.dart';

import '../data/jadwal_kegiatan_model.dart';
import 'jadwal_kegiatan_theme.dart';

/// Kartu jadwal (gambar tengah di Figma).
class JkJadwalCard extends StatelessWidget {
  const JkJadwalCard({super.key, required this.jadwal, this.onTap});

  final JadwalKegiatan jadwal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1F5FB),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: JkColors.border),
            boxShadow: const [
              BoxShadow(
                color: JkColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 22,
                      color: JkColors.navy,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        jadwal.mataKuliah,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: JkColors.navy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: JkColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: JkColors.shadow,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _Baris(label: 'Hari, Tanggal', nilai: jadwal.hariTanggalLabel),
                    const SizedBox(height: 8),
                    _Baris(label: 'Waktu', nilai: jadwal.waktuLabel),
                    const SizedBox(height: 8),
                    _Baris(label: 'Gedung', nilai: jadwal.gedung),
                    const SizedBox(height: 8),
                    _Baris(label: 'Ruang', nilai: jadwal.ruangan),
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

class _Baris extends StatelessWidget {
  const _Baris({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    const gaya = TextStyle(fontSize: 12, color: JkColors.navy, height: 1.3);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: gaya.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        const Text(':  ', style: gaya),
        Expanded(child: Text(nilai, style: gaya)),
      ],
    );
  }
}