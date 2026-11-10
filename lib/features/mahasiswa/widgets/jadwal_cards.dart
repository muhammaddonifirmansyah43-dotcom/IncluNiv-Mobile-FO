import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/format_waktu.dart';
import '../core/mhs_colors.dart';
import '../data/jadwal_model.dart';

const Color _infoBg = Color(0xFFEEF3FF);

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: MhsColors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: MhsText.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: MhsColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}

class _JudulJadwal extends StatelessWidget {
  const _JudulJadwal(this.judul);

  final String judul;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: MhsColors.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.devices_rounded,
            size: 22,
            color: MhsColors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            judul,
            style: const TextStyle(
              fontFamily: MhsText.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: MhsColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}

const BoxDecoration _kartuDecoration = BoxDecoration(
  color: MhsColors.white,
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(BorderSide(color: MhsColors.border)),
  boxShadow: [
    BoxShadow(color: MhsColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
  ],
);

/// Kartu lengkap (halaman Jadwal Pendampingan).
class JadwalDetailCard extends StatelessWidget {
  const JadwalDetailCard({super.key, required this.jadwal});

  final Jadwal jadwal;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _InfoRow(
        icon: Icons.calendar_today_outlined,
        text: formatTanggal(jadwal.tanggalMulai),
      ),
      _InfoRow(icon: Icons.place_outlined, text: jadwal.lokasi),
      if (jadwal.dosen != null)
        _InfoRow(
          icon: Icons.person_outline_rounded,
          text: 'Dosen: ${jadwal.dosen}',
        ),
      _InfoRow(icon: Icons.schedule_rounded, text: jadwal.rentangJam),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _kartuDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _JudulJadwal(jadwal.mataKuliah),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _infoBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  rows[i],
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Pendamping', style: MhsText.section),
          const SizedBox(height: 8),
          PendampingTile(pendamping: jadwal.pendamping),
        ],
      ),
    );
  }
}

/// Kartu ringkas (beranda).
class JadwalRingkasCard extends StatelessWidget {
  const JadwalRingkasCard({
    super.key,
    required this.jadwal,
    required this.onLihatDetail,
  });

  final Jadwal jadwal;
  final VoidCallback onLihatDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MhsColors.barBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MhsColors.border),
        boxShadow: const [
          BoxShadow(
            color: MhsColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _JudulJadwal(jadwal.mataKuliah),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MhsColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text:
                      '${formatTanggal(jadwal.tanggalMulai)}  •  ${jadwal.rentangJam}',
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.place_outlined, text: jadwal.lokasi),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoRow(
                        icon: Icons.person_outline_rounded,
                        text: 'Pendamping: ${jadwal.pendamping.nama}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: MhsColors.orange,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onLihatDetail,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontFamily: MhsText.fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: MhsColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PendampingTile extends StatelessWidget {
  const PendampingTile({super.key, required this.pendamping});

  final Pendamping pendamping;

  Future<void> _salinNomor(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: pendamping.whatsapp));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nomor ${pendamping.whatsapp} disalin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MhsColors.lightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MhsColors.navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              pendamping.inisial,
              style: const TextStyle(
                fontFamily: MhsText.fontFamily,
                color: MhsColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pendamping.nama,
                  style: const TextStyle(
                    fontFamily: MhsText.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: MhsColors.navy,
                  ),
                ),
                Text(
                  'NIM: ${pendamping.nim}',
                  style: MhsText.body.copyWith(fontSize: 11.5),
                ),
                Text(
                  pendamping.prodi,
                  style: MhsText.body.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: MhsColors.orange,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _salinNomor(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.chat_rounded,
                              size: 14,
                              color: MhsColors.white,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                'WhatsApp (${pendamping.whatsapp})',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: MhsText.fontFamily,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: MhsColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> tampilkanDetailJadwal(BuildContext context, Jadwal jadwal) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(child: JadwalDetailCard(jadwal: jadwal)),
      ),
    ),
  );
}
