import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';
import '../data/jadwal_model.dart';
import '../data/jadwal_store.dart';
import '../data/profil_store.dart';
import '../widgets/jadwal_cards.dart';
import '../widgets/jadwal_kosong.dart';
import '../widgets/mhs_bars.dart';
import '../widgets/mhs_button.dart';
import '../widgets/stat_card.dart';
import 'jadwal_page.dart';
import 'profil_page.dart';

/// Beranda mahasiswa difabel. Hanya konten halaman (tanpa sidebar/navigasi global).
class BerandaMahasiswaPage extends StatelessWidget {
  const BerandaMahasiswaPage({super.key});

  void _bukaProfil(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfilMahasiswaPage()),
    );
  }

  void _bukaJadwal(
    BuildContext context, [
    JadwalStatus tab = JadwalStatus.akanDatang,
  ]) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => JadwalPage(tabAwal: tab)));
  }

  Widget _judul(String teks) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Text(teks, style: MhsText.section),
  );

  @override
  Widget build(BuildContext context) {
    final jadwalStore = JadwalStore.instance;
    final profil = ProfilStore.instance;

    return Scaffold(
      backgroundColor: MhsColors.white,
      body: AnimatedBuilder(
        animation: Listenable.merge([jadwalStore, profil]),
        builder: (context, _) {
          final kosong = jadwalStore.kosong;
          final berlangsung = jadwalStore.daftar(JadwalStatus.berlangsung);
          final akanDatang = jadwalStore.daftar(JadwalStatus.akanDatang);
          final selesai = jadwalStore.jumlah(JadwalStatus.selesai);
          String angka(int n) => kosong ? '–' : '$n';

          return Column(
            children: [
              MhsBrandBar(onProfilTap: () => _bukaProfil(context)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${profil.panggilan}',
                        style: MhsText.h1.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Universitas Brawijaya berkomitmen memberikan '
                        'kesetaraan hak belajar melalui Pusat Layanan '
                        'Disabilitas (PLD).',
                        style: MhsText.body,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: MhsStatCard(
                              icon: Icons.event_note_rounded,
                              iconBackground: MhsColors.lightBlue,
                              iconColor: MhsColors.blue,
                              value: angka(akanDatang.length),
                              label: 'Akan Datang',
                              background: MhsColors.white,
                              valueColor: MhsColors.navy,
                              labelColor: MhsColors.navy,
                              onTap: () => _bukaJadwal(context),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MhsStatCard(
                              icon: Icons.play_arrow_rounded,
                              iconBackground: MhsColors.orange,
                              iconColor: MhsColors.white,
                              value: angka(berlangsung.length),
                              label: 'Berlangsung',
                              background: MhsColors.white,
                              valueColor: MhsColors.orange,
                              labelColor: MhsColors.orange,
                              orangeDot: true,
                              onTap: () => _bukaJadwal(
                                context,
                                JadwalStatus.berlangsung,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MhsStatCard(
                              icon: Icons.check_rounded,
                              iconBackground: const Color(0x33FFFFFF),
                              iconColor: MhsColors.white,
                              value: angka(selesai),
                              label: 'Selesai',
                              background: MhsColors.navy,
                              valueColor: MhsColors.white,
                              labelColor: MhsColors.white,
                              onTap: () =>
                                  _bukaJadwal(context, JadwalStatus.selesai),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      MhsButton(
                        label: 'Jadwal Perkuliahan',
                        icon: Icons.event_note_rounded,
                        onPressed: () => _bukaJadwal(context),
                      ),
                      if (berlangsung.isEmpty && akanDatang.isEmpty)
                        Center(
                          child: JadwalKosongView(
                            pesan: kosong
                                ? null
                                : 'Tidak ada pendampingan yang sedang '
                                      'berlangsung atau akan datang.',
                          ),
                        )
                      else ...[
                        if (berlangsung.isNotEmpty) ...[
                          _judul('Pendampingan Sedang Berlangsung'),
                          for (final j in berlangsung)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: JadwalRingkasCard(
                                jadwal: j,
                                onLihatDetail: () =>
                                    tampilkanDetailJadwal(context, j),
                              ),
                            ),
                        ],
                        if (akanDatang.isNotEmpty) ...[
                          _judul('Pendampingan Akan Datang'),
                          for (final j in akanDatang.take(3))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: JadwalRingkasCard(
                                jadwal: j,
                                onLihatDetail: () =>
                                    tampilkanDetailJadwal(context, j),
                              ),
                            ),
                          if (akanDatang.length > 3)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _bukaJadwal(context),
                                child: const Text('Lihat semua'),
                              ),
                            ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
