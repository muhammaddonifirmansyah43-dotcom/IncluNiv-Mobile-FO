import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';
import '../data/profil_store.dart';
import '../widgets/mhs_bars.dart';
import '../widgets/mhs_button.dart';

class ProfilMahasiswaPage extends StatefulWidget {
  const ProfilMahasiswaPage({super.key});

  @override
  State<ProfilMahasiswaPage> createState() => _ProfilMahasiswaPageState();
}

class _ProfilMahasiswaPageState extends State<ProfilMahasiswaPage> {
  final _store = ProfilStore.instance;

  late final TextEditingController _nama = TextEditingController();
  late final TextEditingController _nimC = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _telp = TextEditingController();
  late final TextEditingController _prodi = TextEditingController();
  late final TextEditingController _disabilitas = TextEditingController();
  late final TextEditingController _sandi = TextEditingController();

  bool _edit = false;
  bool _sembunyiDisabilitas = false;
  bool _sembunyiSandi = true;
  Map<String, String> _error = {};

  @override
  void initState() {
    super.initState();
    _muat();
  }

  void _muat() {
    _nama.text = _store.nama;
    _nimC.text = _store.nim;
    _email.text = _store.email;
    _telp.text = _store.telepon;
    _prodi.text = _store.prodi;
    _disabilitas.text = _store.disabilitas;
    _sandi.text = _store.sandi;
  }

  @override
  void dispose() {
    for (final c in [
      _nama,
      _nimC,
      _email,
      _telp,
      _prodi,
      _disabilitas,
      _sandi,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_edit) _muat();
      _edit = !_edit;
      _error = {};
    });
  }

  void _simpan() {
    final e = <String, String>{};

    if (_nama.text.trim().isEmpty) {
      e['nama'] = 'Nama wajib diisi';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email.text.trim())) {
      e['email'] = 'Format email tidak valid';
    }

    if (!RegExp(r'^[0-9+\- ]{8,}$').hasMatch(_telp.text.trim())) {
      e['telp'] = 'Nomor telepon tidak valid';
    }

    if (_sandi.text.length < 6) {
      e['sandi'] = 'Minimal 6 karakter';
    }

    setState(() => _error = e);
    if (e.isNotEmpty) return;

    _store.simpan(
      nama: _nama.text.trim(),
      email: _email.text.trim(),
      telepon: _telp.text.trim(),
      sandi: _sandi.text,
    );

    setState(() => _edit = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhsColors.white,
      body: Column(
        children: [
          const MhsSubAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Profile Mahasiswa',
                      style: TextStyle(
                        fontFamily: MhsText.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: MhsColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: _Avatar(editing: _edit, onTap: _toggleEdit),
                  ),
                  const SizedBox(height: 18),
                  _ProfilField(
                    label: 'Nama Lengkap',
                    icon: Icons.person_outline_rounded,
                    controller: _nama,
                    modeEdit: _edit,
                    error: _error['nama'],
                  ),
                  _ProfilField(
                    label: 'Nomor Induk Mahasiswa',
                    icon: Icons.badge_outlined,
                    controller: _nimC,
                    modeEdit: _edit,
                    bisaDiedit: false,
                  ),
                  _ProfilField(
                    label: 'Email',
                    icon: Icons.alternate_email_rounded,
                    controller: _email,
                    modeEdit: _edit,
                    keyboardType: TextInputType.emailAddress,
                    error: _error['email'],
                  ),
                  _ProfilField(
                    label: 'Nomor Telepon',
                    icon: Icons.phone_rounded,
                    controller: _telp,
                    modeEdit: _edit,
                    keyboardType: TextInputType.phone,
                    error: _error['telp'],
                  ),
                  _ProfilField(
                    label: 'Fakultas/Program Studi',
                    icon: Icons.apartment_rounded,
                    controller: _prodi,
                    modeEdit: _edit,
                    bisaDiedit: false,
                  ),
                  _ProfilField(
                    label: 'Jenis Disabilitas',
                    icon: Icons.accessible_rounded,
                    controller: _disabilitas,
                    modeEdit: _edit,
                    bisaDiedit: false,
                    punyaToggle: true,
                    tersembunyi: _sembunyiDisabilitas,
                    onToggle: () => setState(
                      () => _sembunyiDisabilitas = !_sembunyiDisabilitas,
                    ),
                  ),
                  _ProfilField(
                    label: 'Kata Sandi',
                    icon: Icons.lock_outline_rounded,
                    controller: _sandi,
                    modeEdit: _edit,
                    punyaToggle: true,
                    tersembunyi: _sembunyiSandi,
                    onToggle: () =>
                        setState(() => _sembunyiSandi = !_sembunyiSandi),
                    error: _error['sandi'],
                  ),
                  if (_edit) ...[
                    const SizedBox(height: 8),
                    MhsButton(
                      label: 'Simpan Perubahan',
                      icon: Icons.check_circle_outline_rounded,
                      background: MhsColors.orange,
                      onPressed: _simpan,
                    ),
                    const SizedBox(height: 10),
                    MhsButton(
                      label: 'Batal',
                      background: MhsColors.lightBlue,
                      foreground: MhsColors.navy,
                      onPressed: _toggleEdit,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.editing, required this.onTap});

  final bool editing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFD8BF),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 100,
                color: MhsColors.white,
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Semantics(
              button: true,
              label: editing ? 'Batalkan edit profil' : 'Edit profil',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: editing ? MhsColors.orange : MhsColors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: MhsColors.shadow,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    editing ? Icons.close_rounded : Icons.edit_rounded,
                    size: 18,
                    color: editing ? MhsColors.white : MhsColors.navy,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilField extends StatelessWidget {
  const _ProfilField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.modeEdit,
    this.bisaDiedit = true,
    this.punyaToggle = false,
    this.tersembunyi = false,
    this.onToggle,
    this.keyboardType,
    this.error,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool modeEdit;
  final bool bisaDiedit;
  final bool punyaToggle;
  final bool tersembunyi;
  final VoidCallback? onToggle;
  final TextInputType? keyboardType;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final readOnly = !(modeEdit && bisaDiedit);
    final terkunci = modeEdit && !bisaDiedit;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: MhsText.label.copyWith(fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: MhsColors.fieldFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: error != null ? MhsColors.danger : MhsColors.fieldFill,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x290F2D5B),
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: MhsColors.navy),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    showCursor: !readOnly,
                    obscureText: punyaToggle && tersembunyi,
                    keyboardType: keyboardType,
                    style: TextStyle(
                      fontFamily: MhsText.fontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: terkunci ? MhsColors.muted : MhsColors.navy,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (punyaToggle)
                  InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onToggle,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        tersembunyi
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: MhsColors.navy,
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
      ),
    );
  }
}
