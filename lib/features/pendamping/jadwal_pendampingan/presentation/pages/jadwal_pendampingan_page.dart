import 'package:flutter/material.dart';
import '../../controller/jadwal_controller.dart';
import '../../data/jadwal_dummy.dart';
import '../../../home/presentation/widgets/home_empty_state.dart';
import '../jadwal_style.dart';
import '../widgets/ajukan_perizinan_dialog.dart';
import '../widgets/jadwal_app_bar.dart';
import '../widgets/jadwal_card.dart';
import '../widgets/status_tab_bar.dart';
import '../widgets/success_toast.dart';

/// Halaman Jadwal Pendampingan (aktor pendamping).
/// - Tidak membuat Drawer/sidebar (milik anggota lain).
/// - Tab, Ajukan Perizinan, Setujui, dan Konfirmasi Kehadiran
///   bekerja di dalam satu halaman.
class JadwalPendampinganPage extends StatefulWidget {
  /// Tab yang aktif saat halaman dibuka.
  final JadwalStatus initialTab;

  /// Panah kembali. Jika null -> Navigator.maybePop (kembali ke beranda).
  final VoidCallback? onBackTap;

  /// Dipanggil setelah pengajuan perizinan dikirim (item + alasan).
  /// Sambungkan ke backend / modul perizinan tim jika sudah siap.
  final void Function(JadwalItem item, String alasan)? onPerizinanSubmitted;

  /// false jika dipasang di layout yang sudah punya AppBar.
  final bool showAppBar;

  const JadwalPendampinganPage({
    super.key,
    this.initialTab = JadwalStatus.akanDatang,
    this.onBackTap,
    this.onPerizinanSubmitted,
    this.showAppBar = true,
  });

  @override
  State<JadwalPendampinganPage> createState() =>
      _JadwalPendampinganPageState();
}

class _JadwalPendampinganPageState extends State<JadwalPendampinganPage> {
  late final JadwalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = JadwalController(initialTab: widget.initialTab);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ));
  }

  void _back() {
    if (widget.onBackTap != null) {
      widget.onBackTap!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _ajukan(JadwalItem item) async {
    final alasan = await AjukanPerizinanDialog.show(context, item);
    if (alasan == null || !mounted) return;

    _controller.ajukanPerizinan(item.id);
    widget.onPerizinanSubmitted?.call(item, alasan);

    SuccessToast.show(
      context,
      title: 'Pengajuan Berhasil Diproses',
      message: 'Pengajuan izin kamu telah diproses, '
          'data mahasiswa akan dihapus dari halaman ini',
    );
  }

  void _setujui(JadwalItem item) {
    _controller.setujui(item.id);
    _snack('${item.mataKuliah} disetujui, dipindah ke Berlangsung');
  }

  void _konfirmasi(JadwalItem item) {
    _controller.konfirmasiKehadiran(item.id);
    _snack('Kehadiran dikonfirmasi, dipindah ke Selesai');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final items = _controller.visibleItems;

        return Scaffold(
          backgroundColor: JadwalColors.white,
          appBar: widget.showAppBar ? JadwalAppBar(onBack: _back) : null,
          body: SafeArea(
            top: !widget.showAppBar,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                Text('Jadwal Pendampingan',
                    textAlign: TextAlign.center, style: JadwalText.title),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Kelola sesi bantuan pendampingan akademik mahasiswa',
                    textAlign: TextAlign.center,
                    style: JadwalText.subtitle,
                  ),
                ),
                const SizedBox(height: 20),
                StatusTabBar(
                  selected: _controller.tab,
                  countOf: _controller.count,
                  onChanged: _controller.selectTab,
                ),
                const SizedBox(height: 24),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 36),
                    child: HomeEmptyState(),
                  )
                else
                  for (final item in items) ...[
                    JadwalCard(
                      key: ValueKey(item.id),
                      item: item,
                      onAjukanPerizinan: () => _ajukan(item),
                      onSetujui: () => _setujui(item),
                      onKonfirmasi: () => _konfirmasi(item),
                    ),
                    const SizedBox(height: 20),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}