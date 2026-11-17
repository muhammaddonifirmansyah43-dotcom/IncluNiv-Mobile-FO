
import 'package:flutter/material.dart';

import '../../../../../shared/models/pendamping_profile_store.dart';

import '../../data/pendampingan_dummy.dart';
import '../home_style.dart';
import '../widgets/home_background.dart';
import '../widgets/next_session_card.dart';
import '../widgets/ongoing_session_card.dart';
import '../widgets/stat_card.dart';

import '../../../jadwal_pendampingan/controller/jadwal_controller.dart';
import '../../../jadwal_pendampingan/data/jadwal_dummy.dart';
import '../../../jadwal_pendampingan/presentation/widgets/empty_state.dart';

class PendampingHomePage extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final bool showAppBar;
  final bool isNewAccount;

  final VoidCallback? onAkanDatangTap;
  final VoidCallback? onBerlangsungTap;
  final VoidCallback? onSelesaiTap;
  final VoidCallback? onOngoingDetailTap;
  final VoidCallback? onNextDetailTap;
  final VoidCallback? onJadwalPerkuliahanTap;

  const PendampingHomePage({
    super.key,
    this.onMenuTap,
    this.showAppBar = true,
    this.isNewAccount = false,
    this.onAkanDatangTap,
    this.onBerlangsungTap,
    this.onSelesaiTap,
    this.onOngoingDetailTap,
    this.onNextDetailTap,
    this.onJadwalPerkuliahanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.white,

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
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Stack(
                  children: [
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
                          // SAPAAN
                          AnimatedBuilder(
                            animation:
                                PendampingProfileStore.instance,
                            builder: (context, _) {
                              final nama =
                                  PendampingProfileStore
                                      .instance.nama.trim();

                              final namaTampil = nama.isNotEmpty
                                  ? nama
                                  : isNewAccount
                                      ? 'Pendamping'
                                      : PendampingHomeDummy
                                          .namaPendamping;

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

                          Text(
                            'Riwayat Pendampingan',
                            style: HomeText.sectionTitle,
                          ),

                          const SizedBox(height: 12),

                          if (isNewAccount)
                            _emptyDashboard()
                          else
                            AnimatedBuilder(
                              animation:
                                  JadwalDataStore.instance,
                              builder: (context, _) {
                                return _filledDashboard();
                              },
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

  // ==========================================
  // BERANDA KOSONG - DESAIN FIGMA
  // ==========================================

  Widget _emptyDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _emptyStatCard(
                icon: Icons.event_available,
                label: 'Akan Datang',
                iconColor: HomeColors.blue,
                iconBackground: HomeColors.lightBlue,
                cardColor: HomeColors.white,
                textColor: HomeColors.navy,
                onTap: onAkanDatangTap,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _emptyStatCard(
                icon: Icons.play_arrow_rounded,
                label: 'Berlangsung',
                iconColor: HomeColors.orange,
                iconBackground:
                    HomeColors.orange.withAlpha(35),
                cardColor: HomeColors.white,
                textColor: HomeColors.orange,
                showDot: true,
                onTap: onBerlangsungTap,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _emptyStatCard(
                icon: Icons.check_circle_outline,
                label: 'Selesai',
                iconColor: HomeColors.white,
                iconBackground:
                    HomeColors.white.withAlpha(25),
                cardColor: HomeColors.navy,
                textColor: HomeColors.white,
                dark: true,
                onTap: onSelesaiTap,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 43,
          child: ElevatedButton.icon(
            onPressed: onJadwalPerkuliahanTap,
            icon: const Icon(
              Icons.event_note_outlined,
              size: 18,
            ),
            label: const Text(
              'Jadwal Perkuliahan',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0057C8),
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  const Color(0xFF0057C8),
              disabledForegroundColor: Colors.white,
              elevation: 3,
              shadowColor: Colors.black.withAlpha(55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Pendampingan Sedang Berlangsung',
          style: HomeText.sectionTitle.copyWith(
            fontSize: 16,
          ),
        ),

        const Center(
          child: EmptyState(
            title: 'Jadwal tidak tersedia',
            message:
                'Belum ada jadwal pendampingan pada kategori ini. '
                'Silakan tambahkan jadwal baru untuk memulai '
                'sesi pendampingan.',
          ),
        ),
      ],
    );
  }

  // ==========================================
  // KARTU STATISTIK AKUN BARU
  // ==========================================

  Widget _emptyStatCard({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color iconBackground,
    required Color cardColor,
    required Color textColor,
    bool showDot = false,
    bool dark = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 88,
          padding: const EdgeInsets.fromLTRB(
            9,
            12,
            9,
            9,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: dark
                  ? HomeColors.navy
                  : const Color(0xFFE8EAF0),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: iconColor,
                    ),
                  ),

                  if (showDot) ...[
                    const Spacer(),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: HomeColors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ] else
                    const Spacer(),

                  Text(
                    '–',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      height: 1,
                    ),
                  ),
                ],
              ),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BERANDA AKUN DEMO
  // ==========================================

  Widget _filledDashboard() {
    final store = JadwalDataStore.instance;

    // Jumlah diambil dari data Jadwal Pendampingan.
    final akanDatang = store.count(
      JadwalStatus.akanDatang,
      isNewAccount: false,
    );

    final berlangsung = store.count(
      JadwalStatus.berlangsung,
      isNewAccount: false,
    );

    final selesai = store.count(
      JadwalStatus.selesai,
      isNewAccount: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TIGA KARTU STATISTIK
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.event_available,
                count: akanDatang,
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
                count: berlangsung,
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
                count: selesai,
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

        // PENDAMPINGAN BERLANGSUNG
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

        // PENDAMPINGAN SELANJUTNYA
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
    );
  }
}
