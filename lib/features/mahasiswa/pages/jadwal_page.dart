import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';
import '../data/jadwal_model.dart';
import '../data/jadwal_store.dart';
import '../widgets/jadwal_cards.dart';
import '../widgets/jadwal_kosong.dart';
import '../widgets/mhs_bars.dart';
import 'jadwal_form_page.dart';
import 'profil_page.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key, this.tabAwal = JadwalStatus.akanDatang});

  final JadwalStatus tabAwal;

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  late JadwalStatus _tab;

  @override
  void initState() {
    super.initState();
    _tab = widget.tabAwal;
  }

  void _bukaProfil() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfilMahasiswaPage()),
    );
  }

  Future<void> _tambah() async {
    final hasil = await Navigator.of(context).push<Jadwal>(
      MaterialPageRoute<Jadwal>(builder: (_) => const JadwalFormPage()),
    );
    if (!mounted || hasil == null) return;
    setState(() => _tab = hasil.statusPada(DateTime.now()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Jadwal berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    final store = JadwalStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final daftar = store.daftar(_tab);
        final kosong = daftar.isEmpty;

        return Scaffold(
          backgroundColor: MhsColors.white,
          floatingActionButton: kosong
              ? null
              : FloatingActionButton(
                  onPressed: _tambah,
                  tooltip: 'Tambah jadwal',
                  backgroundColor: MhsColors.blue,
                  foregroundColor: MhsColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.add_rounded, size: 30),
                ),
          body: Column(
            children: [
              MhsSubAppBar(
                title: kosong ? 'Jadwal Perkuliahan' : null,
                onAvatarTap: _bukaProfil,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
                  children: [
                    const Text(
                      'Jadwal Pendampingan',
                      textAlign: TextAlign.center,
                      style: MhsText.h2,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola sesi pendampingan akademik mahasiswa',
                      textAlign: TextAlign.center,
                      style: MhsText.body,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _TabChip(
                          icon: Icons.edit_calendar_outlined,
                          label:
                              'Akan Datang (${store.jumlah(JadwalStatus.akanDatang)})',
                          aktif: _tab == JadwalStatus.akanDatang,
                          onTap: () =>
                              setState(() => _tab = JadwalStatus.akanDatang),
                        ),
                        const SizedBox(width: 8),
                        _TabChip(
                          icon: Icons.sync_rounded,
                          label:
                              'Berlangsung (${store.jumlah(JadwalStatus.berlangsung)})',
                          aktif: _tab == JadwalStatus.berlangsung,
                          onTap: () =>
                              setState(() => _tab = JadwalStatus.berlangsung),
                        ),
                        const SizedBox(width: 8),
                        _TabChip(
                          icon: Icons.check_circle_outline_rounded,
                          label:
                              'Selesai (${store.jumlah(JadwalStatus.selesai)})',
                          aktif: _tab == JadwalStatus.selesai,
                          onTap: () =>
                              setState(() => _tab = JadwalStatus.selesai),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (kosong)
                      JadwalKosongView(onTambah: _tambah)
                    else
                      for (final j in daftar)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: JadwalDetailCard(jadwal: j),
                        ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.icon,
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final warna = aktif ? MhsColors.white : MhsColors.navy;
    return Expanded(
      child: Material(
        color: aktif ? MhsColors.blue : MhsColors.barBg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: aktif ? MhsColors.blue : MhsColors.border,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Icon(icon, size: 15, color: warna),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: MhsText.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: warna,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
