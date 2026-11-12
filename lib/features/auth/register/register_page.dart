
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/models/pendamping_profile_store.dart';
import '../../../shared/models/demo_auth_store.dart';
import '../../mahasiswa/data/profil_store.dart';

// JENIS AKTOR REGISTRASI
enum RegisterRole {
  pendamping,
  mahasiswa,
}

class RegisterPage extends StatefulWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onBack;
  final VoidCallback? onRegistered;

  const RegisterPage({
    super.key,
    this.onLogin,
    this.onBack,
    this.onRegistered,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // WARNA RESMI APLIKASI
  static const Color navy = Color(0xFF0F2D5B);
  static const Color blue = Color(0xFF0056B8);
  static const Color orange = Color(0xFFF97316);
  static const Color lightBlue = Color(0xFFEFF2FF);
  static const Color errorRed = Color(0xFFD93025);

  RegisterRole selectedRole = RegisterRole.pendamping;

  // FOTO PROFIL MAHASISWA
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _fotoDipilih;
  String? _errorFoto;

  // CONTROLLER INPUT
  final _namaController = TextEditingController();
  final _nomorIndukController = TextEditingController();
  final _emailController = TextEditingController();
  final _fakultasController = TextEditingController();
  final _teleponController = TextEditingController();
  final _keahlianController = TextEditingController();
  final _disabilitasController = TextEditingController();
  final _dukunganController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  // PENYIMPAN PESAN ERROR
  final Map<TextEditingController, String> _errors = {};

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get isPendamping =>
      selectedRole == RegisterRole.pendamping;

  // MEMBERSIHKAN CONTROLLER
  @override
  void dispose() {
    _namaController.dispose();
    _nomorIndukController.dispose();
    _emailController.dispose();
    _fakultasController.dispose();
    _teleponController.dispose();
    _keahlianController.dispose();
    _disabilitasController.dispose();
    _dukunganController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  // NAVIGASI KEMBALI
  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // NAVIGASI KE LOGIN
  void _handleLogin() {
    if (widget.onLogin != null) {
      widget.onLogin!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Halaman Login belum dihubungkan pada preview ini.',
        ),
      ),
    );
  }

  // GANTI AKTOR REGISTRASI
  void _changeRole(RegisterRole role) {
    if (selectedRole == role) return;

    setState(() {
      selectedRole = role;
      _errors.clear();
      _fotoDipilih = null;
      _errorFoto = null;

      _keahlianController.clear();
      _disabilitasController.clear();
      _dukunganController.clear();
    });
  }

  // MEMILIH FOTO PROFIL DARI GALERI
  Future<void> _pilihFoto() async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 85,
      );

      if (foto == null || !mounted) return;

      final namaFile = foto.name.toLowerCase();

      final formatValid =
          namaFile.endsWith('.jpg') ||
          namaFile.endsWith('.jpeg') ||
          namaFile.endsWith('.png');

      if (!formatValid) {
        setState(() {
          _errorFoto = 'Gunakan JPG, JPEG, atau PNG';
        });
        return;
      }

      setState(() {
        _fotoDipilih = foto;
        _errorFoto = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorFoto = 'Foto gagal dipilih';
      });
    }
  }

  // VALIDASI INPUT
  String? _validateInput(
    TextEditingController controller,
  ) {
    final value = controller.text.trim();

    if (value.isEmpty) {
      return 'Wajib diisi';
    }

    if (controller == _emailController) {
      final pattern = RegExp(
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      );

      if (!pattern.hasMatch(value)) {
        return 'Email tidak valid';
      }
    }

    if (controller == _nomorIndukController) {
      if (!RegExp(r'^\d+$').hasMatch(value)) {
        return 'Harus berupa angka';
      }
    }

    if (controller == _passwordController &&
        controller.text.length < 8) {
      return 'Minimal 8 karakter';
    }

    if (controller == _konfirmasiController &&
        controller.text != _passwordController.text) {
      return 'Sandi tidak sama';
    }

    return null;
  }

  // TOMBOL DAFTAR
  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    final controllers = <TextEditingController>[
      _namaController,
      _nomorIndukController,
      _emailController,
      _fakultasController,
      _teleponController,
      if (isPendamping)
        _keahlianController
      else ...[
        _disabilitasController,
        _dukunganController,
      ],
      _passwordController,
      _konfirmasiController,
    ];

    final newErrors = <TextEditingController, String>{};

    for (final controller in controllers) {
      final error = _validateInput(controller);

      if (error != null) {
        newErrors[controller] = error;
      }
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(newErrors);

      _errorFoto =
          (!isPendamping && _fotoDipilih == null)
              ? 'Foto wajib dipilih'
              : null;
    });

    // JANGAN LANJUT JIKA ADA ERROR
    if (newErrors.isNotEmpty ||
        (!isPendamping && _fotoDipilih == null)) {
      return;
    }

    // SIMPAN DATA PROFIL PENDAMPING
    if (isPendamping) {
      PendampingProfileStore.instance.saveRegistration(
        nama: _namaController.text.trim(),
        nim: _nomorIndukController.text.trim(),
        email: _emailController.text.trim(),
        telepon: _teleponController.text.trim(),
        fakultas: _fakultasController.text.trim(),
        keahlian: _keahlianController.text.trim(),
      );
    }

    // SIMPAN DATA PROFIL MAHASISWA
    if (!isPendamping) {
      try {
        // Membaca foto langsung menjadi bytes.
        // Tidak menggunakan dart:io atau path_provider.
        final fotoBytes = await _fotoDipilih!.readAsBytes();

        if (!mounted) return;

        // Menyimpan data profil dan foto ke ProfilStore.
        ProfilStore.instance.isiDariRegistrasi(
          nama: _namaController.text.trim(),
          nim: _nomorIndukController.text.trim(),
          email: _emailController.text.trim(),
          telepon: _teleponController.text.trim(),
          prodi: _fakultasController.text.trim(),
          disabilitas: _disabilitasController.text.trim(),
          fotoBytes: fotoBytes,
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membaca foto profil: $e'),
          ),
        );
        return;
      }
    }

    // SIMPAN AKUN DEMO UNTUK LOGIN
    DemoAuthStore.instance.register(
      nim: _nomorIndukController.text.trim(),
      password: _passwordController.text,
      role: isPendamping
          ? 'Pendamping'
          : 'Mahasiswa Disabilitas',
    );

    // NAVIGASI SETELAH REGISTRASI
    if (widget.onRegistered != null) {
      widget.onRegistered!();
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navy,
        content: Text(
          'Registrasi '
          '${isPendamping ? "Pendamping" : "Mahasiswa Difabel"} '
          'berhasil. Silakan menuju halaman Login.',
        ),
      ),
    );
  }

  // TAMPILAN HALAMAN REGISTER
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // DEKORASI KIRI ATAS
          Positioned(
            top: -55,
            left: -55,
            child: _circle(
              const Color(0xFFDCE8FF),
              125,
            ),
          ),

          Positioned(
            top: 45,
            left: -65,
            child: _circle(
              const Color(0xFFFFE3D4),
              95,
            ),
          ),

          // DEKORASI KANAN ATAS
          Positioned(
            top: -30,
            right: -45,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: orange,
                  width: 3,
                ),
              ),
            ),
          ),

          // DEKORASI KANAN BAWAH
          Positioned(
            bottom: 90,
            right: -50,
            child: _circle(
              const Color(0xFFFFE3D4),
              105,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                SizedBox(
                  height: 42,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _handleBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: navy,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Registrasi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // FORM DAPAT DI-SCROLL
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      26,
                      12,
                      26,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),

                        const Text(
                          'Registrasi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: navy,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Bergabung dan dapatkan kemudahan akses '
                          'layanan Universitas Brawijaya yang setara, '
                          'aman, dan berdaya.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 9,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 14),

                        _roleSelector(),

                        const SizedBox(height: 14),

                        _field(
                          label: 'Nama Lengkap',
                          hint: 'Contoh: Brawijaya Pratama',
                          icon: Icons.person_outline,
                          controller: _namaController,
                        ),

                        _field(
                          label: 'Nomor Induk Mahasiswa (NIM)',
                          hint: 'Contoh: 2615502010000',
                          icon: Icons.badge_outlined,
                          controller: _nomorIndukController,
                          keyboardType: TextInputType.number,
                        ),

                        _field(
                          label: 'Email Mahasiswa UB',
                          hint: 'nama_anda@student.ub.ac.id',
                          icon: Icons.alternate_email,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        _field(
                          label: 'Fakultas/Program Studi',
                          hint: 'Contoh: Vokasi/D3 Teknologi Informasi',
                          icon: Icons.school_outlined,
                          controller: _fakultasController,
                        ),

                        _field(
                          label: 'Nomor Telepon',
                          hint: '+62 823 8901 2345',
                          icon: Icons.phone_outlined,
                          controller: _teleponController,
                          keyboardType: TextInputType.phone,
                        ),

                        if (isPendamping)
                          _field(
                            label: 'Keahlian',
                            hint: 'Masukkan Keahlian',
                            icon: Icons.psychology_outlined,
                            controller: _keahlianController,
                          )
                        else ...[
                          _field(
                            label: 'Jenis Disabilitas',
                            hint: 'Masukkan Jenis Disabilitas',
                            icon: Icons.accessible_forward,
                            controller: _disabilitasController,
                          ),
                          _field(
                            label: 'Kebutuhan Dukungan',
                            hint: 'Masukkan Jenis Dukungan',
                            icon: Icons.support_agent,
                            controller: _dukunganController,
                          ),
                        ],

                        _field(
                          label: 'Kata Sandi Akun',
                          hint: 'Minimal 8 karakter unik',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            tooltip: _obscurePassword
                                ? 'Tampilkan kata sandi'
                                : 'Sembunyikan kata sandi',
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 17,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        _field(
                          label: 'Konfirmasi Kata Sandi',
                          hint: 'Masukkan kembali sandi',
                          icon: Icons.lock_outline,
                          controller: _konfirmasiController,
                          obscure: _obscureConfirm,
                          suffix: IconButton(
                            tooltip: _obscureConfirm
                                ? 'Tampilkan konfirmasi sandi'
                                : 'Sembunyikan konfirmasi sandi',
                            onPressed: () {
                              setState(() {
                                _obscureConfirm =
                                    !_obscureConfirm;
                              });
                            },
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 17,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        // FORM FOTO KHUSUS MAHASISWA
                        if (!isPendamping) _photoField(),

                        const SizedBox(height: 20),

                        // TOMBOL DAFTAR
                        SizedBox(
                          height: 43,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Sudah punya akun resmi?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 10,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // TOMBOL LOGIN
                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: _handleLogin,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: lightBlue,
                              foregroundColor: navy,
                              side: BorderSide.none,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  // FORM FOTO PROFIL HORIZONTAL
  Widget _photoField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Foto Profil',
                  style: TextStyle(
                    color: navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (_errorFoto != null)
                Text(
                  _errorFoto!,
                  style: const TextStyle(
                    color: errorRed,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: _errorFoto != null
                      ? errorRed
                      : const Color(0xFFE1E5F0),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _pilihFoto,
                    style: TextButton.styleFrom(
                      foregroundColor: navy,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    child: const Text(
                      'Pilih Foto',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: const Color(0xFFD8DEEC),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        _fotoDipilih?.name ??
                            'Belum ada foto yang dipilih',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: _fotoDipilih == null
                              ? const Color(0xFFB7BDCA)
                              : navy,
                        ),
                      ),
                    ),
                  ),
                  if (_fotoDipilih != null)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Hapus pilihan foto',
                      onPressed: () {
                        setState(() {
                          _fotoDipilih = null;
                          _errorFoto = null;
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 15,
                        color: navy,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Format JPG, JPEG, atau PNG. Foto wajib diisi.',
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFF8A91A0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PILIHAN AKTOR
  Widget _roleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _roleButton(
          'Pendamping',
          RegisterRole.pendamping,
        ),
        const SizedBox(width: 7),
        _roleButton(
          'Mahasiswa\nDifabel',
          RegisterRole.mahasiswa,
        ),
      ],
    );
  }

  Widget _roleButton(
    String title,
    RegisterRole role,
  ) {
    final selected = selectedRole == role;

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: () => _changeRole(role),
        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? orange
              : const Color(0xFFFFE1CB),
          foregroundColor: selected
              ? Colors.white
              : navy,
          elevation: selected ? 2 : 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            height: 1.1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // KOMPONEN INPUT
  Widget _field({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    final error = _errors[controller];

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (error != null) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    error,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: errorRed,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 11,
                color: navy,
              ),
              onChanged: (_) {
                if (_errors.containsKey(controller) ||
                    (controller == _passwordController &&
                        _errors.containsKey(
                          _konfirmasiController,
                        ))) {
                  setState(() {
                    if (_errors.containsKey(controller)) {
                      final newError =
                          _validateInput(controller);

                      if (newError == null) {
                        _errors.remove(controller);
                      } else {
                        _errors[controller] = newError;
                      }
                    }

                    if (controller == _passwordController &&
                        _errors.containsKey(
                          _konfirmasiController,
                        )) {
                      final confirmError = _validateInput(
                        _konfirmasiController,
                      );

                      if (confirmError == null) {
                        _errors.remove(
                          _konfirmasiController,
                        );
                      } else {
                        _errors[_konfirmasiController] =
                            confirmError;
                      }
                    }
                  });
                }
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFFB7BDCA),
                  fontSize: 10,
                ),
                prefixIcon: Icon(
                  icon,
                  size: 15,
                  color: const Color(0xFF8A91A0),
                ),
                suffixIcon: suffix,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                filled: true,
                fillColor: lightBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: BorderSide(
                    color: error != null
                        ? errorRed
                        : const Color(0xFFE1E5F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: BorderSide(
                    color: error != null
                        ? errorRed
                        : blue,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DEKORASI LINGKARAN
  Widget _circle(
    Color color,
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
