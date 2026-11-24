
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/mentor_profile_service.dart';
import '../logout/logout_dialog.dart';

class ProfilePendampingPage extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLogoutConfirmed;

  const ProfilePendampingPage({
    super.key,
    this.onBack,
    this.onLogoutConfirmed,
  });

  @override
  State<ProfilePendampingPage> createState() =>
      _ProfilePendampingPageState();
}

class _ProfilePendampingPageState
    extends State<ProfilePendampingPage> {
  static const navy = Color(0xFF0F2D5B);
  static const orange = Color(0xFFF97316);
  static const inputBg = Color(0xFFEEF2FF);
  static const peach = Color(0xFFFFD7BB);

  // DATA PROFIL DARI BACKEND
  Map<String, dynamic>? _profilApi;
  bool _loadingProfil = true;
  String? _errorProfil;

  // MEMBACA FIELD DARI RESPONSE API
  String _nilaiProfil(List<String> keys) {
    final profil = _profilApi;

    if (profil == null) return '-';

    for (final key in keys) {
      final value = profil[key];

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '-';
  }

  // MENGAMBIL PROFIL DARI BACKEND
  Future<void> _ambilProfilPendamping() async {
    if (!mounted) return;

    setState(() {
      _loadingProfil = true;
      _errorProfil = null;
    });

    try {
      final profile =
          await MentorProfileService.getMyProfile();

      if (!mounted) return;

      setState(() {
        _profilApi = profile;
        _loadingProfil = false;
      });

      _loadData();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorProfil = error
            .toString()
            .replaceFirst('Exception: ', '');

        _loadingProfil = false;
      });
    }
  }

  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _keahlianController = TextEditingController();

  final bool _isEditing = false;
  bool _showPassword = false;
  Uint8List? _pendingFoto;

  @override
  void initState() {
    super.initState();

    // AMBIL PROFIL SAAT HALAMAN DIBUKA
    _ambilProfilPendamping();
  }

  // MENGISI CONTROLLER DARI DATA API
  void _loadData() {
    _emailController.text = _nilaiProfil(['email']);

    _teleponController.text =
        _nilaiProfil(['phoneNumber', 'telepon']);

    _keahlianController.text =
        _nilaiProfil(['skills', 'keahlian']);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _teleponController.dispose();
    _keahlianController.dispose();

    super.dispose();
  }

  // EDIT PROFIL BELUM DIHUBUNGKAN KE BACKEND
  void _startEdit() {
    _showMessage(
      'Edit profil belum terhubung ke API backend. '
      'Data dari MySQL ditampilkan hanya untuk dibaca.',
    );
  }

  // MEMILIH FOTO (UNTUK INTEGRASI EDIT NANTI)
  Future<void> _pickPhoto() async {
    if (!_isEditing) return;

    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _pendingFoto = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memilih foto: $e',
          ),
        ),
      );
    }
  }

  // SIMPAN PROFIL BELUM TERHUBUNG KE API UPDATE
  void _saveProfile() {
    final email = _emailController.text.trim();
    final telepon = _teleponController.text.trim();
    final keahlian = _keahlianController.text.trim();

    if (email.isEmpty ||
        telepon.isEmpty ||
        keahlian.isEmpty) {
      _showMessage(
        'Semua kolom yang diedit wajib diisi.',
      );
      return;
    }

    final validEmail = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);

    if (!validEmail) {
      _showMessage(
        'Format email tidak valid.',
      );
      return;
    }

    _showMessage(
      'Penyimpanan perubahan profil belum tersedia.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navy,
        content: Text(message),
      ),
    );
  }

  // LOGOUT AKAN DIINTEGRASIKAN SETELAH PROFIL
  Future<void> _confirmLogout() async {
    final confirmed = await LogoutDialog.show(context);

    if (!mounted || confirmed != true) return;

    if (widget.onLogoutConfirmed != null) {
      widget.onLogoutConfirmed!();
    } else {
      _showMessage(
        'Logout dikonfirmasi. '
        'Pengakhiran sesi akan dihubungkan saat integrasi.',
      );
    }
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFBBC4D5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Kembali',
                    onPressed: _handleBack,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      25,
                      14,
                      25,
                      24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 440,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Profile Pendamping',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // STATUS LOADING API
                            if (_loadingProfil)
                              const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child:
                                    LinearProgressIndicator(),
                              ),

                            // STATUS ERROR API
                            if (_errorProfil != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Gagal memuat profil: '
                                      '$_errorProfil',
                                      textAlign:
                                          TextAlign.center,
                                    ),
                                    TextButton(
                                      onPressed:
                                          _ambilProfilPendamping,
                                      child: const Text(
                                        'Coba Lagi',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // FOTO PROFIL
                            _buildPhoto(),

                            const SizedBox(height: 20),

                            // NAMA DARI API
                            _profileField(
                              label: 'Nama Lengkap',
                              icon: Icons.person_outline,
                              value: _nilaiProfil(
                                ['fullName', 'nama'],
                              ),
                            ),

                            // NIM DARI API
                            _profileField(
                              label:
                                  'Nomor Induk Mahasiswa',
                              icon: Icons.badge_outlined,
                              value: _nilaiProfil(
                                ['studentCode', 'nim'],
                              ),
                            ),

                            // EMAIL DARI API
                            _profileField(
                              label: 'Email',
                              icon: Icons.alternate_email,
                              value: _nilaiProfil(
                                ['email'],
                              ),
                              editable: true,
                              controller:
                                  _emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                            ),

                            // TELEPON DARI API
                            _profileField(
                              label: 'Nomor Telepon',
                              icon: Icons.phone,
                              value: _nilaiProfil(
                                ['phoneNumber', 'telepon'],
                              ),
                              editable: true,
                              controller:
                                  _teleponController,
                              keyboardType:
                                  TextInputType.phone,
                            ),

                            // FAKULTAS DARI API
                            _profileField(
                              label:
                                  'Fakultas/Program Studi',
                              icon: Icons.apartment,
                              value: _nilaiProfil(
                                ['department', 'fakultas'],
                              ),
                            ),

                            // KEAHLIAN DARI API
                            _profileField(
                              label: 'Keahlian',
                              icon: Icons.handyman_outlined,
                              value: _nilaiProfil(
                                ['skills', 'keahlian'],
                              ),
                              editable: true,
                              controller:
                                  _keahlianController,
                            ),

                            _passwordField(),

                            const SizedBox(height: 24),

                            if (_isEditing)
                              _saveButton()
                            else
                              _actionButtons(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FOTO PROFIL
  Widget _buildPhoto() {
    // Foto dummy tidak digunakan lagi.
    // Integrasi URL foto backend akan dilakukan
    // setelah respons API dipastikan.
    final Uint8List? bytes = _pendingFoto;

    return Center(
      child: SizedBox(
        width: 155,
        height: 155,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bytes == null
                    ? peach
                    : const Color(0xFFEDEEF5),
                border: bytes == null
                    ? null
                    : Border.all(
                        color: const Color(0xFFE1E5EE),
                        width: 2,
                      ),
                image: bytes == null
                    ? null
                    : DecorationImage(
                        image: MemoryImage(bytes),
                        fit: BoxFit.cover,
                      ),
              ),
              child: bytes == null
                  ? const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 112,
                    )
                  : null,
            ),

            if (_isEditing)
              Positioned(
                bottom: 4,
                right: 5,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 1,
                  child: IconButton(
                    tooltip: 'Ganti foto profil',
                    onPressed: _pickPhoto,
                    icon: const Icon(
                      Icons.edit,
                      color: navy,
                      size: 19,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // FIELD PROFIL
  Widget _profileField({
    required String label,
    required IconData icon,
    required String value,
    bool editable = false,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final canEdit = _isEditing && editable;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 7),

          Container(
            height: 48,
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(9),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  offset: Offset(0, 3),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 13,
                    right: 10,
                  ),
                  child: Icon(
                    icon,
                    size: 17,
                    color: navy,
                  ),
                ),

                Expanded(
                  child: canEdit
                      ? TextField(
                          controller: controller,
                          keyboardType: keyboardType,
                          maxLines: 1,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration:
                              const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        )
                      : Text(
                          value.isEmpty
                              ? '-'
                              : value,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                if (canEdit)
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 12,
                      left: 4,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: navy,
                      size: 15,
                    ),
                  ),

                if (!canEdit)
                  const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // KATA SANDI TIDAK DAPAT DIEDIT DI PROFIL
  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kata Sandi',
            style: TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 7),

          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
            ),
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(9),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  offset: Offset(0, 3),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: navy,
                  size: 17,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    _showPassword
                        ? 'Kata sandi tersembunyi'
                        : '••••••••',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                IconButton(
                  tooltip: 'Informasi kata sandi',
                  onPressed: () {
                    setState(() {
                      _showPassword =
                          !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: navy,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TOMBOL KELUAR DAN EDIT PROFILE
  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _confirmLogout,
            style: OutlinedButton.styleFrom(
              foregroundColor: orange,
              side: const BorderSide(
                color: orange,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              'Keluar Akun',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),

        const SizedBox(width: 28),

        Expanded(
          child: ElevatedButton(
            onPressed: _startEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              foregroundColor: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TOMBOL SIMPAN
  Widget _saveButton() {
    return Center(
      child: SizedBox(
        width: 140,
        height: 41,
        child: ElevatedButton(
          onPressed: _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: orange,
            foregroundColor: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(7),
            ),
          ),
          child: const Text(
            'Simpan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
