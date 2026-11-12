
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';
import '../data/profil_store.dart';
import '../widgets/mhs_bars.dart';

// POPUP LOGOUT DARI ABY
import '../../pendamping/logout/logout_dialog.dart';

// ==========================================
// HALAMAN PROFIL MAHASISWA DIFABEL
// PROFIL BERSIFAT READ ONLY
// ==========================================

class ProfilMahasiswaPage extends StatefulWidget {
  const ProfilMahasiswaPage({super.key});

  @override
  State<ProfilMahasiswaPage> createState() =>
      _ProfilMahasiswaPageState();
}

class _ProfilMahasiswaPageState
    extends State<ProfilMahasiswaPage> {
  final ProfilStore _store = ProfilStore.instance;

  @override
  void initState() {
    super.initState();

    // Mendengarkan perubahan data dari ProfilStore.
    _store.addListener(_refresh);

    
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    super.dispose();
  }

  // ========================================
  // LOGOUT MAHASISWA DIFABEL
  // ========================================

  Future<void> _logout() async {
    final confirmed = await LogoutDialog.show(context);

    if (!mounted || confirmed != true) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  // ========================================
  // TAMPILAN PROFIL MAHASISWA
  // ========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhsColors.white,
      body: Column(
        children: [
          // HEADER ASLI MAHASISWA
          const MhsSubAppBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                32,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL
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

                  // FOTO PROFIL DARI REGISTRASI
                  Center(
                    child: _Avatar(
                      foto: _store.foto,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // NAMA LENGKAP
                  _ProfilField(
                    label: 'Nama Lengkap',
                    icon: Icons.person_outline_rounded,
                    value: _store.nama,
                  ),

                  // NIM
                  _ProfilField(
                    label: 'Nomor Induk Mahasiswa',
                    icon: Icons.badge_outlined,
                    value: _store.nim,
                  ),

                  // EMAIL
                  _ProfilField(
                    label: 'Email',
                    icon: Icons.alternate_email_rounded,
                    value: _store.email,
                  ),

                  // NOMOR TELEPON
                  _ProfilField(
                    label: 'Nomor Telepon',
                    icon: Icons.phone_rounded,
                    value: _store.telepon,
                  ),

                  // FAKULTAS / PROGRAM STUDI
                  _ProfilField(
                    label: 'Fakultas/Program Studi',
                    icon: Icons.apartment_rounded,
                    value: _store.prodi,
                  ),

                  // JENIS DISABILITAS
                  _ProfilField(
                    label: 'Jenis Disabilitas',
                    icon: Icons.accessible_rounded,
                    value: _store.disabilitas,
                  ),

                  const SizedBox(height: 20),

                  // TOMBOL LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 46,

                    child: OutlinedButton.icon(
                      onPressed: _logout,

                      icon: const Icon(
                        Icons.logout_rounded,
                        size: 19,
                      ),

                      label: const Text(
                        'Keluar Akun',
                        style: TextStyle(
                          fontFamily: MhsText.fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: MhsColors.orange,
                        backgroundColor: Colors.white,

                        side: const BorderSide(
                          color: MhsColors.orange,
                          width: 1.5,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// KOMPONEN FOTO PROFIL MAHASISWA
// TIDAK ADA TOMBOL EDIT
// ==========================================

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.foto,
  });

  final Uint8List? foto;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFD8BF),

        image: foto == null
            ? null
            : DecorationImage(
                image: MemoryImage(foto!),
                fit: BoxFit.cover,
              ),
      ),

      child: foto == null
          ? const Icon(
              Icons.person_rounded,
              size: 100,
              color: MhsColors.white,
            )
          : null,
    );
  }
}

// ==========================================
// KOMPONEN FIELD PROFIL
// SEMUA DATA HANYA DAPAT DILIHAT
// ==========================================

class _ProfilField extends StatelessWidget {
  const _ProfilField({
    required this.label,
    required this.icon,
    required this.value,
  });

  final String label;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: MhsText.label.copyWith(
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 48,
            ),

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: MhsColors.fieldFill,

              borderRadius: BorderRadius.circular(10),

              border: Border.all(
                color: MhsColors.fieldFill,
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
                Icon(
                  icon,
                  size: 20,
                  color: MhsColors.navy,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    value.isEmpty ? '-' : value,

                    style: const TextStyle(
                      fontFamily: MhsText.fontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: MhsColors.navy,
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
