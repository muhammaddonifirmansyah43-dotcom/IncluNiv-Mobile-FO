import 'package:flutter/material.dart';

import '../data/jadwal_kegiatan_model.dart';
import '../data/jadwal_kegiatan_store.dart';
import '../widgets/jadwal_kegiatan_empty_state.dart';
import '../widgets/jadwal_kegiatan_jadwal_card.dart';
import '../widgets/jadwal_kegiatan_theme.dart';
import '../widgets/jadwal_kegiatan_tombol.dart';
import '../widgets/jadwal_kegiatan_top_bar.dart';
import 'jadwal_form_page.dart';

/// Halaman Jadwal Kegiatan (aktor Pendamping).
///
/// Alur: kosong (gambar kiri) -> tekan "Pengisian Jadwal" -> form ->
/// simpan -> kembali ke sini dan jadwal tampil sebagai kartu (gambar tengah).
class JadwalKegiatanPage extends StatelessWidget {
  const JadwalKegiatanPage({super.key, this.tampilkanAppBar = true});

  /// Set false jika layout buatan rekan sudah menyediakan bar atas sendiri.
  final bool tampilkanAppBar;

  Future<void> _bukaForm(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const JadwalFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JkColors.white,
      body: Column(
        children: [
          if (tampilkanAppBar) const JkTopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text('Jadwal Kegiatan', style: JkText.h1)),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Kelola Jadwal kegiatan rutin dan non rutin',
                    style: JkText.body,
                  ),
                ),
                const SizedBox(height: 16),
                JkTombol(
                  kompak: true,
                  label: 'Pengisian Jadwal',
                  icon: Icons.add_box_outlined,
                  onPressed: () => _bukaForm(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<JadwalKegiatan>>(
              valueListenable: JadwalKegiatanStore.instance.daftar,
              builder: (context, daftar, _) {
                if (daftar.isEmpty) {
                  return const Center(
                    child: SingleChildScrollView(child: JkEmptyState()),
                  );
                }
                return _DaftarJadwal(daftar: daftar);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Daftar jadwal dikelompokkan per hari (Senin ... Minggu).
class _DaftarJadwal extends StatelessWidget {
  const _DaftarJadwal({required this.daftar});

  final List<JadwalKegiatan> daftar;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final hari in JkFormat.hari) {
      final itemHari = daftar.where((j) => j.hari == hari).toList()
        ..sort((a, b) {
          final t = a.tanggal.compareTo(b.tanggal);
          return t != 0 ? t : a.menitMulai.compareTo(b.menitMulai);
        });

      if (itemHari.isEmpty) continue;

      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 10, left: 4),
          child: Text(
            hari,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: JkColors.navy,
            ),
          ),
        ),
      );

      for (final j in itemHari) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: JkJadwalCard(jadwal: j),
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: children,
    );
  }
}