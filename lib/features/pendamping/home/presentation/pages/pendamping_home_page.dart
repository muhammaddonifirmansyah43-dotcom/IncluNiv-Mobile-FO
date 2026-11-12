import 'package:flutter/material.dart';
import '../../data/pendampingan_dummy.dart';
import '../home_style.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_background.dart';
import '../widgets/home_empty_state.dart';
import '../widgets/jadwal_perkuliahan_button.dart';
import '../widgets/next_session_card.dart';
import '../widgets/ongoing_session_card.dart';
import '../widgets/stat_card.dart';

/// Halaman Beranda Pendamping.
/// - Kondisi kosong (belum isi jadwal): angka "-", tombol Jadwal
///   Perkuliahan, dan ilustrasi "Jadwal tidak tersedia".
/// - Kondisi terisi: riwayat + kartu pendampingan.
/// - Tidak membuat Drawer/sidebar (milik anggota lain).
class PendampingHomePage extends StatefulWidget {
  /// Dipanggil saat ikon hamburger ditekan (sambungkan ke sidebar tim).
  final VoidCallback? onMenuTap;

  /// false jika halaman ini dipasang di dalam layout yang sudah punya AppBar.
  final bool showAppBar;

  /// Kondisi awal. false = baru login, jadwal belum diisi.
  final bool initialHasJadwal;

  /// Dipanggil saat "Jadwal Perkuliahan" ditekan. Harus membuka halaman
  /// jadwal kegiatan dan mengembalikan `true` jika jadwal sudah terisi.
  final Future<bool?> Function(BuildContext context)? onJadwalPerkuliahanTap;

  final VoidCallback? onAkanDatangTap;
  final VoidCallback? onBerlangsungTap;
  final VoidCallback? onSelesaiTap;
  final VoidCallback? onOngoingDetailTap;
  final VoidCallback? onNextDetailTap;

  const PendampingHomePage({
    super.key,
    this.onMenuTap,
    this.showAppBar = true,
    this.initialHasJadwal = false,
    this.onJadwalPerkuliahanTap,
    this.onAkanDatangTap,
    this.onBerlangsungTap,
    this.onSelesaiTap,
    this.onOngoingDetailTap,
    this.onNextDetailTap,
  });

  @override
  State<PendampingHomePage> createState() => _PendampingHomePageState();
}

class _PendampingHomePageState extends State<PendampingHomePage> {
  late bool _hasJadwal = widget.initialHasJadwal;

  Future<void> _openJadwal() async {
    final open = widget.onJadwalPerkuliahanTap;
    if (open == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('Halaman jadwal belum terhubung'),
        ));
      return;
    }
    final filled = await open(context);
    if (filled == true && mounted) {
      setState(() => _hasJadwal = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final riwayat = PendampingHomeDummy.riwayat;
    final filled = _hasJadwal;

    return Scaffold(
      backgroundColor: HomeColors.white,
      appBar: widget.showAppBar
          ? HomeAppBar(onMenuTap: widget.onMenuTap, showLogo: !filled)
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            top: !widget.showAppBar,
            bottom: false,
            child: SingleChildScrollView(
              child: ConstrainedBox(
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
                                  count: filled ? riwayat.akanDatang : null,
                                  label: 'Akan Datang',
                                  background: HomeColors.white,
                                  iconColor: HomeColors.blue,
                                  iconBackground: HomeColors.lightBlue,
                                  textColor: HomeColors.navy,
                                  countColor: HomeColors.blue,
                                  onTap: widget.onAkanDatangTap,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.play_arrow_rounded,
                                  count: filled ? riwayat.berlangsung : null,
                                  label: 'Berlangsung',
                                  background: HomeColors.white,
                                  iconColor: HomeColors.orange,
                                  iconBackground:
                                      HomeColors.orange.withAlpha(46),
                                  textColor: HomeColors.orange,
                                  countColor: HomeColors.orange,
                                  showDot: true,
                                  onTap: widget.onBerlangsungTap,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.check_circle_outline,
                                  count: filled ? riwayat.selesai : null,
                                  label: 'Selesai',
                                  background: HomeColors.navy,
                                  iconColor: HomeColors.white,
                                  iconBackground:
                                      HomeColors.white.withAlpha(30),
                                  textColor: HomeColors.white,
                                  countColor: HomeColors.white,
                                  onTap: widget.onSelesaiTap,
                                ),
                              ),
                            ],
                          ),
                          if (!filled) ...[
                            const SizedBox(height: 24),
                            JadwalPerkuliahanButton(onTap: _openJadwal),
                            const SizedBox(height: 24),
                            Text('Pendampingan Sedang Berlangsung',
                                style: HomeText.sectionTitle
                                    .copyWith(fontSize: 16)),
                            const SizedBox(height: 8),
                            const Center(child: HomeEmptyState()),
                          ] else ...[
                            const SizedBox(height: 28),
                            Text('Pendampingan Sedang Berlangsung',
                                style: HomeText.sectionTitle
                                    .copyWith(fontSize: 16)),
                            const SizedBox(height: 14),
                            OngoingSessionCard(
                              item: PendampingHomeDummy.berlangsung,
                              onDetailTap: widget.onOngoingDetailTap,
                            ),
                            const SizedBox(height: 28),
                            Text('Pendampingan Selanjutnya',
                                style: HomeText.sectionTitle
                                    .copyWith(fontSize: 16)),
                            const SizedBox(height: 14),
                            NextSessionCard(
                              item: PendampingHomeDummy.selanjutnya,
                              onDetailTap: widget.onNextDetailTap,
                            ),
                          ],
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