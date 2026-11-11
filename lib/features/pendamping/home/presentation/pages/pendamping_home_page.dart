
import 'package:flutter/material.dart';

import '../../../../../shared/models/pendamping_profile_store.dart';

import '../../data/pendampingan_dummy.dart';
import '../home_style.dart';
import '../widgets/home_background.dart';
import '../widgets/next_session_card.dart';
import '../widgets/ongoing_session_card.dart';
import '../widgets/stat_card.dart';

/// Halaman Beranda Pendamping.
///
/// Integrasi:
/// - Nama mengikuti PendampingProfileStore.
/// - Sidebar menggunakan PendampingHomeShell.
/// - Navigasi kartu menggunakan callback dari main.dart.
/// - Tetap mendukung preview mandiri.
class PendampingHomePage extends StatelessWidget {
  /// Callback tombol hamburger jika memakai AppBar sendiri.
  final VoidCallback? onMenuTap;

  /// Gunakan false jika dibungkus PendampingHomeShell
  /// agar tidak muncul dua AppBar.
  final bool showAppBar;

  // CALLBACK NAVIGASI
  final VoidCallback? onAkanDatangTap;
  final VoidCallback? onBerlangsungTap;
  final VoidCallback? onSelesaiTap;
  final VoidCallback? onOngoingDetailTap;
  final VoidCallback? onNextDetailTap;

  const PendampingHomePage({
    super.key,
    this.onMenuTap,
    this.showAppBar = true,
    this.onAkanDatangTap,
    this.onBerlangsungTap,
    this.onSelesaiTap,
    this.onOngoingDetailTap,
    this.onNextDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    // DATA RIWAYAT PENDAMPINGAN
    final riwayat = PendampingHomeDummy.riwayat;

    return Scaffold(
      backgroundColor: HomeColors.white,

      // APPBAR HANYA UNTUK PREVIEW MANDIRI
      appBar: showAppBar
          ? AppBar(
              backgroundColor: HomeColors.lightBlue,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: HomeColors.navy,
                  size: 28,
                ),
                onPressed: onMenuTap,
              ),
            )
          : null,

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            top: !showAppBar,
            bottom: false,

            child: SingleChildScrollView(
              child: ConstrainedBox(
                // Menjaga tinggi halaman agar dekorasi
                // background tetap mengikuti tinggi layar.
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),

                child: Stack(
                  children: [
                    // BACKGROUND ASLI BERANDA
                    const Positioned.fill(
                      child: HomeBackground(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        24,
                        20,
                        32,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          // ==========================
                          // SAPAAN PENDAMPING
                          // ==========================
                          AnimatedBuilder(
                            animation:
                                PendampingProfileStore.instance,
                            builder: (context, _) {
                              final nama =
                                  PendampingProfileStore
                                      .instance.nama.trim();

                              final namaTampil = nama.isEmpty
                                  ? PendampingHomeDummy
                                      .namaPendamping
                                  : nama;

                              return Text(
                                'Halo, $namaTampil!',
                                style: HomeText.greeting,
                              );
                            },
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Kamu telah berkomitmen dalam ketersediaan sebagai '
                            'pendamping mahasiswa difabel yang dinaungi oleh '
                            'Pusat Layanan Disabilitas (PLD).',
                            style: HomeText.body,
                          ),

                          const SizedBox(height: 24),

                          // ==========================
                          // RIWAYAT PENDAMPINGAN
                          // ==========================
                          Text(
                            'Riwayat Pendampingan',
                            style: HomeText.sectionTitle,
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // AKAN DATANG
                              Expanded(
                                child: StatCard(
                                  icon: Icons.event_available,
                                  count: riwayat.akanDatang,
                                  label: 'Akan Datang',
                                  background: HomeColors.white,
                                  iconColor: HomeColors.blue,
                                  iconBackground:
                                      HomeColors.lightBlue,
                                  textColor: HomeColors.navy,
                                  countColor: HomeColors.blue,
                                  onTap: onAkanDatangTap,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // BERLANGSUNG
                              Expanded(
                                child: StatCard(
                                  icon: Icons.play_arrow_rounded,
                                  count: riwayat.berlangsung,
                                  label: 'Berlangsung',
                                  background: HomeColors.white,
                                  iconColor: HomeColors.orange,
                                  iconBackground:
                                      HomeColors.orange.withAlpha(46),
                                  textColor: HomeColors.orange,
                                  countColor: HomeColors.orange,
                                  showDot: true,
                                  onTap: onBerlangsungTap,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // SELESAI
                              Expanded(
                                child: StatCard(
                                  icon: Icons.check_circle_outline,
                                  count: riwayat.selesai,
                                  label: 'Selesai',
                                  background: HomeColors.navy,
                                  iconColor: HomeColors.white,
                                  iconBackground:
                                      HomeColors.white.withAlpha(30),
                                  textColor: HomeColors.white,
                                  countColor: HomeColors.white,
                                  onTap: onSelesaiTap,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // ==========================
                          // PENDAMPINGAN BERLANGSUNG
                          // ==========================
                          Text(
                            'Pendampingan Sedang Berlangsung',
                            style: HomeText.sectionTitle.copyWith(
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 14),

                          OngoingSessionCard(
                            item: PendampingHomeDummy.berlangsung,
                            onDetailTap: onOngoingDetailTap,
                          ),

                          const SizedBox(height: 28),

                          // ==========================
                          // PENDAMPINGAN SELANJUTNYA
                          // ==========================
                          Text(
                            'Pendampingan Selanjutnya',
                            style: HomeText.sectionTitle.copyWith(
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 14),

                          NextSessionCard(
                            item: PendampingHomeDummy.selanjutnya,
                            onDetailTap: onNextDetailTap,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
