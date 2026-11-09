import 'package:flutter/material.dart';
import '../../data/pendampingan_dummy.dart';
import '../home_style.dart';
import '../widgets/home_background.dart';
import '../widgets/next_session_card.dart';
import '../widgets/ongoing_session_card.dart';
import '../widgets/stat_card.dart';

/// Halaman Beranda Pendamping.
/// - Tidak membuat Drawer/sidebar (milik anggota lain).
/// - Navigasi lewat callback; sambungkan ke routing tim saat sudah siap.
class PendampingHomePage extends StatelessWidget {
  /// Dipanggil saat ikon hamburger ditekan (sambungkan ke sidebar tim).
  final VoidCallback? onMenuTap;

  /// false jika halaman ini dipasang di dalam layout yang sudah punya AppBar.
  final bool showAppBar;

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
    final riwayat = PendampingHomeDummy.riwayat;

    return Scaffold(
      backgroundColor: HomeColors.white,
      appBar: showAppBar
          ? AppBar(
              backgroundColor: HomeColors.lightBlue,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: HomeColors.navy, size: 28),
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
                // minimal setinggi layar, supaya gelembung bawah
                // tetap di dasar layar walau konten pendek
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Stack(
                  children: [
                    const Positioned.fill(child: HomeBackground()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Halo, ${PendampingHomeDummy.namaPendamping}!',
                              style: HomeText.greeting),
                          const SizedBox(height: 6),
                          Text(
                            'Kamu telah berkomitmen dalam ketersediaan sebagai '
                            'pendamping mahasiswa difabel yang dinaungi oleh '
                            'Pusat Layanan Disabilitas (PLD).',
                            style: HomeText.body,
                          ),
                          const SizedBox(height: 24),
                          Text('Riwayat Pendampingan',
                              style: HomeText.sectionTitle),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  icon: Icons.event_available,
                                  count: riwayat.akanDatang,
                                  label: 'Akan Datang',
                                  background: HomeColors.white,
                                  iconColor: HomeColors.blue,
                                  iconBackground: HomeColors.lightBlue,
                                  textColor: HomeColors.navy,
                                  countColor: HomeColors.blue,
                                  onTap: onAkanDatangTap,
                                ),
                              ),
                              const SizedBox(width: 12),
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
                          Text('Pendampingan Sedang Berlangsung',
                              style:
                                  HomeText.sectionTitle.copyWith(fontSize: 16)),
                          const SizedBox(height: 14),
                          OngoingSessionCard(
                            item: PendampingHomeDummy.berlangsung,
                            onDetailTap: onOngoingDetailTap,
                          ),
                          const SizedBox(height: 28),
                          Text('Pendampingan Selanjutnya',
                              style:
                                  HomeText.sectionTitle.copyWith(fontSize: 16)),
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