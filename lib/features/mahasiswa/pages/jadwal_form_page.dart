import 'package:flutter/material.dart';

import '../core/format_waktu.dart';
import '../core/mhs_colors.dart';
import '../data/jadwal_model.dart';
import '../data/jadwal_store.dart';
import '../widgets/mhs_bars.dart';
import '../widgets/mhs_button.dart';

class JadwalFormPage extends StatefulWidget {
  const JadwalFormPage({super.key, this.onSimpan});

  /// Jika diisi, jadwal diserahkan ke callback ini (bukan ke JadwalStore).
  final void Function(Jadwal jadwal)? onSimpan;

  @override
  State<JadwalFormPage> createState() => _JadwalFormPageState();
}

class _JadwalFormPageState extends State<JadwalFormPage> {
  final _mk = TextEditingController();
  final _gedung = TextEditingController();
  final _ruang = TextEditingController();

  String? _hari;
  DateTime? _tanggal;
  TimeOfDay? _mulai;
  TimeOfDay? _selesai;
  Map<String, String> _error = {};

  @override
  void dispose() {
    _mk.dispose();
    _gedung.dispose();
    _ruang.dispose();
    super.dispose();
  }

  int _menit(TimeOfDay t) => t.hour * 60 + t.minute;

  void _hapusError(String kunci) {
    if (_error.containsKey(kunci)) {
      setState(() => _error = Map.of(_error)..remove(kunci));
    }
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final awal = DateTime(now.year, now.month, now.day);
    var initial = _tanggal ?? awal;
    final idx = _hari == null ? null : daftarHari.indexOf(_hari!) + 1;

    if (idx != null) {
      while (initial.weekday != idx) {
        initial = initial.add(const Duration(days: 1));
      }
    }

    final hasil = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: awal.subtract(const Duration(days: 365)),
      lastDate: awal.add(const Duration(days: 730)),
      selectableDayPredicate: idx == null ? null : (d) => d.weekday == idx,
    );

    if (hasil == null) return;

    setState(() {
      _tanggal = hasil;
      _hari ??= namaHari(hasil);
      _error = Map.of(_error)
        ..remove('tanggal')
        ..remove('hari');
    });
  }

  Future<void> _pilihJam({required bool mulai}) async {
    final hasil = await showTimePicker(
      context: context,
      initialTime:
          (mulai ? _mulai : _selesai) ?? const TimeOfDay(hour: 8, minute: 0),
    );

    if (hasil == null) return;

    setState(() {
      if (mulai) {
        _mulai = hasil;
      } else {
        _selesai = hasil;
      }
      _error = Map.of(_error)
        ..remove('mulai')
        ..remove('selesai');
    });
  }

  bool _validasi() {
    final e = <String, String>{};

    if (_mk.text.trim().isEmpty) {
      e['mk'] = 'Nama mata kuliah wajib diisi';
    }
    if (_hari == null) e['hari'] = 'Pilih hari';
    if (_tanggal == null) e['tanggal'] = 'Pilih tanggal';
    if (_mulai == null) e['mulai'] = 'Pilih jam';

    if (_selesai == null) {
      e['selesai'] = 'Pilih jam';
    } else if (_mulai != null && _menit(_selesai!) <= _menit(_mulai!)) {
      e['selesai'] = 'Harus setelah jam mulai';
    }

    if (_gedung.text.trim().isEmpty) e['gedung'] = 'Wajib diisi';
    if (_ruang.text.trim().isEmpty) e['ruang'] = 'Wajib diisi';

    setState(() => _error = e);
    return e.isEmpty;
  }

  void _simpan() {
    if (!_validasi()) return;

    final jadwal = Jadwal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      mataKuliah: _mk.text.trim(),
      hari: _hari!,
      tanggalMulai: _tanggal!,
      jamMulai: _mulai!,
      jamSelesai: _selesai!,
      gedung: _gedung.text.trim(),
      ruangan: _ruang.text.trim(),
      // Dummy: backend nanti yang mencocokkan pendamping.
      pendamping: Pendamping.contoh,
    );

    if (widget.onSimpan != null) {
      widget.onSimpan!(jadwal);
    } else {
      JadwalStore.instance.tambah(jadwal);
    }

    Navigator.of(context).pop(jadwal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhsColors.white,
      body: Column(
        children: [
          const MhsSubAppBar(title: 'Pengisian jadwal'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MhsColors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    const Center(
                      child: Text('Jadwal Kuliah', style: MhsText.h2),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        'Kelola sesi pendampingan akademik mahasiswa',
                        style: MhsText.body,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _Kolom(
                      label: 'Nama Mata Kuliah',
                      wajib: true,
                      error: _error['mk'],
                      child: _InputTeks(
                        controller: _mk,
                        hint: 'Contoh: Interaksi Manusia & Komputer',
                        adaError: _error.containsKey('mk'),
                        onChanged: (_) => _hapusError('mk'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Kolom(
                            label: 'Hari Pertemuan',
                            error: _error['hari'],
                            child: _KotakDropdown(
                              nilai: _hari,
                              hint: 'Senin',
                              adaError: _error.containsKey('hari'),
                              onChanged: (v) => setState(() {
                                _hari = v;
                                final idx = daftarHari.indexOf(v!) + 1;
                                if (_tanggal != null &&
                                    _tanggal!.weekday != idx) {
                                  _tanggal = null;
                                }
                                _hapusError('hari');
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Kolom(
                            label: 'Mulai Tanggal',
                            error: _error['tanggal'],
                            child: _KotakPilih(
                              teks: _tanggal == null
                                  ? null
                                  : formatTanggal(_tanggal!),
                              hint: '23 Okt 2024',
                              icon: Icons.calendar_today_outlined,
                              adaError: _error.containsKey('tanggal'),
                              onTap: _pilihTanggal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Kolom(
                            label: 'Jam Mulai',
                            error: _error['mulai'],
                            child: _KotakPilih(
                              teks: _mulai == null ? null : formatJam(_mulai!),
                              hint: '08:00',
                              icon: Icons.schedule_rounded,
                              adaError: _error.containsKey('mulai'),
                              onTap: () => _pilihJam(mulai: true),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Kolom(
                            label: 'Jam Selesai',
                            error: _error['selesai'],
                            child: _KotakPilih(
                              teks: _selesai == null
                                  ? null
                                  : formatJam(_selesai!),
                              hint: '10:30',
                              icon: Icons.schedule_rounded,
                              adaError: _error.containsKey('selesai'),
                              onTap: () => _pilihJam(mulai: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _Kolom(
                            label: 'Gedung',
                            error: _error['gedung'],
                            child: _InputTeks(
                              controller: _gedung,
                              hint: 'Gedung Fasilkom A',
                              adaError: _error.containsKey('gedung'),
                              onChanged: (_) => _hapusError('gedung'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Kolom(
                            label: 'Ruangan / Lab',
                            error: _error['ruang'],
                            child: _InputTeks(
                              controller: _ruang,
                              hint: 'Lab R.304 Lt. 3',
                              adaError: _error.containsKey('ruang'),
                              onChanged: (_) => _hapusError('ruang'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    MhsButton(
                      label: 'Simpan Jadwal',
                      icon: Icons.check_circle_outline_rounded,
                      background: MhsColors.orange,
                      onPressed: _simpan,
                    ),
                    const SizedBox(height: 10),
                    MhsButton(
                      label: 'Batal',
                      background: MhsColors.lightBlue,
                      foreground: MhsColors.navy,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Kolom extends StatelessWidget {
  const _Kolom({
    required this.label,
    required this.child,
    this.wajib = false,
    this.error,
  });

  final String label;
  final Widget child;
  final bool wajib;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: MhsText.label)),
            if (wajib)
              const Text(
                '*Wajib',
                style: TextStyle(
                  fontFamily: MhsText.fontFamily,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: MhsColors.danger,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        child,
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style: const TextStyle(
                fontSize: 11,
                color: MhsColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

BoxDecoration _kotak(bool adaError) => BoxDecoration(
  color: MhsColors.fieldFill,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: adaError ? MhsColors.danger : MhsColors.fieldFill),
);

const TextStyle _isiStyle = TextStyle(
  fontFamily: MhsText.fontFamily,
  fontSize: 12.5,
  fontWeight: FontWeight.w600,
  color: MhsColors.navy,
);

const TextStyle _hintStyle = TextStyle(
  fontFamily: MhsText.fontFamily,
  fontSize: 12.5,
  color: MhsColors.hint,
);

class _InputTeks extends StatelessWidget {
  const _InputTeks({
    required this.controller,
    required this.hint,
    required this.adaError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final bool adaError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _kotak(adaError),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: _isiStyle,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: _hintStyle,
        ),
      ),
    );
  }
}

class _KotakPilih extends StatelessWidget {
  const _KotakPilih({
    required this.teks,
    required this.hint,
    required this.icon,
    required this.adaError,
    required this.onTap,
  });

  final String? teks;
  final String hint;
  final IconData icon;
  final bool adaError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: _kotak(adaError),
        child: Row(
          children: [
            Expanded(
              child: Text(
                teks ?? hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: teks == null ? _hintStyle : _isiStyle,
              ),
            ),
            Icon(icon, size: 16, color: MhsColors.hint),
          ],
        ),
      ),
    );
  }
}

class _KotakDropdown extends StatelessWidget {
  const _KotakDropdown({
    required this.nilai,
    required this.hint,
    required this.adaError,
    required this.onChanged,
  });

  final String? nilai;
  final String hint;
  final bool adaError;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _kotak(adaError),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: nilai,
          isExpanded: true,
          hint: const Text('Senin', style: _hintStyle),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: MhsColors.hint,
          ),
          style: _isiStyle,
          items: [
            for (final h in daftarHari)
              DropdownMenuItem<String>(value: h, child: Text(h)),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
