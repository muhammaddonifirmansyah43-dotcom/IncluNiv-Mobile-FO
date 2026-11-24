import 'package:flutter/material.dart';

import '../../controller/jadwal_controller.dart';
import '../../data/jadwal_dummy.dart';
import '../jadwal_style.dart';
import '../widgets/ajukan_perizinan_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/jadwal_app_bar.dart';
import '../widgets/jadwal_card.dart';
import '../widgets/status_tab_bar.dart';
import '../widgets/success_toast.dart';

import '../../../../../services/permission_service.dart';
import '../../../../../services/assignment_service.dart';
import '../../../../../shared/models/demo_auth_store.dart';

class JadwalPendampinganPage extends StatefulWidget {
  final JadwalStatus initialTab;
  final VoidCallback? onBackTap;

  final void Function(JadwalItem item, String alasan)?
      onPerizinanSubmitted;

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

class _JadwalPendampinganPageState
    extends State<JadwalPendampinganPage> {
  late final JadwalController _controller;

  @override
  void initState() {
    super.initState();

    _controller = JadwalController(
      initialTab: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _back() {
    if (widget.onBackTap != null) {
      widget.onBackTap!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  // ==========================================
  // DETAIL PENUGASAN
  // ==========================================
  Future<void> _lihatDetail(JadwalItem item) async {
    if (!DemoAuthStore.instance.isBackendPendampingLogin) {
      _tampilkanDetailDemo(item);
      return;
    }

    final assignmentId = int.tryParse(item.id);

    if (assignmentId == null) {
      _snack('ID penugasan tidak valid.');
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final detail = await AssignmentService.getAssignmentDetail(
        assignmentId,
      );

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return _DetailPenugasanDialog(
            data: detail,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
      _snack('Gagal mengambil detail penugasan: $e');
    }
  }

  void _tampilkanDetailDemo(JadwalItem item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return _DetailPenugasanDialog(
          data: {
            'id': item.id,
            'status': item.assignmentStatus ?? _statusDemo(item.status),
            'startAt': item.startAt?.toIso8601String(),
            'endAt': item.endAt?.toIso8601String(),
            'location': item.lokasi,
            'student': {
              'user': {
                'fullName': item.mahasiswa,
                'phoneNumber': item.telepon,
                'photoUrl': item.fotoUrl,
              },
              'disabilityType': item.jenisDisabilitas,
              'supportNeeds': item.kebutuhan,
            },
          },
          fallbackDate: item.tanggal,
          fallbackTime: item.jam,
        );
      },
    );
  }

  String _statusDemo(JadwalStatus status) {
    switch (status) {
      case JadwalStatus.akanDatang:
        return 'PENDING';
      case JadwalStatus.berlangsung:
        return 'ONGOING';
      case JadwalStatus.selesai:
        return 'COMPLETED';
    }
  }

  // ==========================================
  // PENGAJUAN IZIN
  // ==========================================
  Future<void> _ajukan(JadwalItem item) async {
    final alasan =
        await AjukanPerizinanDialog.show(context, item);

    if (alasan == null || !mounted) return;

    if (DemoAuthStore.instance.isBackendPendampingLogin) {
      try {
        if (item.startAt == null || item.endAt == null) {
          throw Exception(
            'Waktu penugasan tidak tersedia. '
            'Silakan muat ulang jadwal.',
          );
        }

        final assignmentId = int.tryParse(item.id);

        if (assignmentId == null) {
          throw Exception('ID penugasan tidak valid.');
        }

        await PermissionService.createPermission(
          reason: alasan,
          startAt: item.startAt!,
          endAt: item.endAt!,
          assignmentId: assignmentId,
        );

        if (!mounted) return;

        SuccessToast.show(
          context,
          title: 'Pengajuan Berhasil Dikirim',
          message: 'Pengajuan izin kamu sedang menunggu '
              'proses persetujuan.',
        );
      } catch (e) {
        if (!mounted) return;

        _snack('Gagal mengajukan izin: $e');
      }

      return;
    }

    _controller.ajukanPerizinan(item.id);

    widget.onPerizinanSubmitted?.call(item, alasan);

    SuccessToast.show(
      context,
      title: 'Pengajuan Berhasil Diproses',
      message: 'Pengajuan izin kamu telah diproses, '
          'data mahasiswa akan dihapus dari halaman ini',
    );
  }

  // ==========================================
  // KONFIRMASI KEHADIRAN
  // ==========================================
  void _konfirmasi(JadwalItem item) {
    _controller.konfirmasiKehadiran(item.id);

    _snack(
      'Kehadiran dikonfirmasi, '
      'dipindah ke Selesai',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final items = _controller.visibleItems;

        return Scaffold(
          backgroundColor: JadwalColors.white,
          appBar: widget.showAppBar
              ? JadwalAppBar(onBack: _back)
              : null,
          body: SafeArea(
            top: !widget.showAppBar,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                32,
              ),
              children: [
                Text(
                  'Jadwal Pendampingan',
                  textAlign: TextAlign.center,
                  style: JadwalText.title,
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Text(
                    'Kelola sesi bantuan pendampingan '
                    'akademik mahasiswa',
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
                if (_controller.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_controller.loadError != null)
                  Column(
                    children: [
                      const EmptyState(
                        title: 'Gagal Memuat Penugasan',
                        message:
                            'Terjadi kendala saat mengambil data dari server. '
                            'Periksa koneksi internet dan coba kembali.',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed:
                            _controller.loadBackendAssignments,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  )
                else if (items.isEmpty)
                  const EmptyState()
                else
                  for (final item in items) ...[
                    JadwalCard(
                      key: ValueKey(item.id),
                      item: item,
                      onDetail: () => _lihatDetail(item),
                      onAjukanPerizinan: () => _ajukan(item),
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

// ==========================================
// DIALOG DETAIL PENUGASAN
// ==========================================
class _DetailPenugasanDialog extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? fallbackDate;
  final String? fallbackTime;

  const _DetailPenugasanDialog({
    required this.data,
    this.fallbackDate,
    this.fallbackTime,
  });

  String _value(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'Belum tersedia';
    }

    return value.toString();
  }

  String _formatDate(dynamic value) {
    if (value == null) return fallbackDate ?? 'Belum tersedia';

    final date = DateTime.tryParse(value.toString());
    if (date == null) return _value(value);

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(dynamic start, dynamic end) {
    final startDate = DateTime.tryParse(start?.toString() ?? '');
    final endDate = DateTime.tryParse(end?.toString() ?? '');

    if (startDate == null || endDate == null) {
      return fallbackTime ?? 'Belum tersedia';
    }

    String time(DateTime date) {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return '${time(startDate)} - ${time(endDate)} WIB';
  }

  String _statusLabel(dynamic value) {
    switch (value?.toString()) {
      case 'PENDING':
        return 'Menunggu';
      case 'ACCEPTED':
        return 'Diterima';
      case 'ONGOING':
        return 'Berlangsung';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return _value(value);
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: JadwalColors.navy,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(
                color: JadwalColors.slate,
                fontSize: 13,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              _value(value),
              style: const TextStyle(
                color: JadwalColors.navy,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = data['student'] is Map
        ? Map<String, dynamic>.from(data['student'])
        : <String, dynamic>{};

    final user = student['user'] is Map
        ? Map<String, dynamic>.from(student['user'])
        : <String, dynamic>{};

    return Dialog(
      backgroundColor: JadwalColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detail Penugasan',
                      style: TextStyle(
                        color: JadwalColors.navy,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              _sectionTitle('Informasi Penugasan'),
              _detailRow('ID Penugasan', data['id']),
              _detailRow('Status', _statusLabel(data['status'])),
              _detailRow(
                'Tanggal',
                _formatDate(data['startAt']),
              ),
              _detailRow(
                'Waktu',
                _formatTime(data['startAt'], data['endAt']),
              ),
              _detailRow('Lokasi', data['location']),
              _sectionTitle('Informasi Mahasiswa'),
              _detailRow('Nama', user['fullName']),
              _detailRow('NIM', student['studentCode']),
              _detailRow('Program Studi', student['department']),
              _detailRow('Jenis Disabilitas', student['disabilityType']),
              _detailRow('Kebutuhan Dukungan', student['supportNeeds']),
              _detailRow('Nomor Telepon', user['phoneNumber']),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: JadwalColors.navy,
                    foregroundColor: JadwalColors.white,
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
