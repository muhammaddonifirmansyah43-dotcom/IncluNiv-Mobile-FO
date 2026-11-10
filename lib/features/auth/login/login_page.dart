
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/app_illustration.dart';

class _AuthColors {
  static const navy = Color(0xFF0F2D5B);
  static const blue = Color(0xFF3B82F6);
  static const orange = Color(0xFFF97316);
  static const input = Color(0xFFEEF2FF);
  static const red = Color(0xFFE53935);
}

// BACKGROUND BERSAMA LOGIN DAN LUPA SANDI
class _AuthBackground extends StatelessWidget {
  final Widget child;

  const _AuthBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -46,
            right: 7,
            child: _circle(
              95,
              const Color(0xFFDCE8FF),
            ),
          ),
          Positioned(
            top: 35,
            right: -45,
            child: _circle(
              90,
              const Color(0xFFFFE7D6),
            ),
          ),
          Positioned(
            top: 220,
            left: -55,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _AuthColors.orange,
                  width: 5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 285,
            right: 29,
            child: _circle(
              23,
              _AuthColors.input,
            ),
          ),
          Positioned(
            bottom: -60,
            right: -42,
            child: _circle(
              130,
              const Color(0xFFDCE8FF),
            ),
          ),
          Positioned(
            bottom: -84,
            left: -45,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _AuthColors.navy,
                  width: 5,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
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

// LOGO DAN ILUSTRASI YANG SUDAH DIBUAT LUKI
class _AuthBrand extends StatelessWidget {
  const _AuthBrand();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppLogo(fontSize: 30),
        SizedBox(height: 12),
        AppIllustration(size: 148),
      ],
    );
  }
}

// ================= LOGIN =================

class LoginPage extends StatefulWidget {
  final VoidCallback? onRegister;
  final void Function(String role)? onLoginSuccess;

  const LoginPage({
    super.key,
    this.onRegister,
    this.onLoginSuccess,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  String? _nimError;
  String? _passwordError;
  String? _loginError;

  // Akun khusus simulasi frontend.
  // BUKAN autentikasi backend sungguhan.
  static const demoNim = '2315407011111';
  static const demoPassword = 'Demo12345';

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(String role) {
    FocusScope.of(context).unfocus();

    final nim = _nimController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _nimError = nim.isEmpty
          ? 'Wajib diisi'
          : !RegExp(r'^\d+$').hasMatch(nim)
              ? 'NIM harus berupa angka'
              : null;

      _passwordError =
          password.isEmpty ? 'Wajib diisi' : null;

      _loginError = null;
    });

    if (_nimError != null || _passwordError != null) {
      return;
    }

    if (nim != demoNim || password != demoPassword) {
      setState(() {
        _loginError = 'Username atau password salah';
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _AuthColors.navy,
        content: Text(
          'Simulasi masuk sebagai $role berhasil. '
          'Backend belum terhubung.',
        ),
      ),
    );

    widget.onLoginSuccess?.call(role);
  }

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ForgotPasswordPage(),
      ),
    );
  }

  Widget _input({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required String? error,
    required ValueChanged<String> onChanged,
    bool obscure = false,
    Widget? suffix,
    TextInputType type = TextInputType.text,
  }) {
    final hasError = error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _AuthColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (hasError)
              Flexible(
                child: Text(
                  error,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _AuthColors.red,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 47,
          child: TextField(
            controller: controller,
            keyboardType: type,
            obscureText: obscure,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 12,
              color: _AuthColors.navy,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFADB6C8),
                fontSize: 11,
              ),
              prefixIcon: Icon(
                icon,
                color: _AuthColors.blue,
                size: 19,
              ),
              suffixIcon: suffix,
              filled: true,
              fillColor: _AuthColors.input,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError
                      ? _AuthColors.red
                      : const Color(0xFFD9DDEB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: hasError
                      ? _AuthColors.red
                      : _AuthColors.blue,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0057BF),
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(
                icon,
                color: const Color(0xFF0057BF),
                size: 17,
              ),
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final compact = height < 690;

    return _AuthBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(35, 0, 35, 35),
        children: [
          SizedBox(height: compact ? 20 : 100),

          const _AuthBrand(),

          SizedBox(height: compact ? 14 : 22),

          _input(
            label: 'NIM (Nomor Induk Mahasiswa)',
            hint: 'Contoh: 215150200111001',
            controller: _nimController,
            icon: Icons.badge_outlined,
            type: TextInputType.number,
            error: _nimError,
            onChanged: (_) {
              setState(() {
                _nimError = null;
                _loginError = null;
              });
            },
          ),

          const SizedBox(height: 18),

          _input(
            label: 'Password / Kata Sandi',
            hint: 'Masukkan kata sandi akun',
            controller: _passwordController,
            icon: Icons.lock_outline,
            obscure: _obscurePassword,
            error: _passwordError,
            onChanged: (_) {
              setState(() {
                _passwordError = null;
                _loginError = null;
              });
            },
            suffix: IconButton(
              tooltip: _obscurePassword
                  ? 'Tampilkan kata sandi'
                  : 'Sembunyikan kata sandi',
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _AuthColors.blue,
                size: 19,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),

          // Ruang tetap untuk pesan error login
          SizedBox(
            height: 24,
            child: _loginError == null
                ? null
                : Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: _AuthColors.red,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          _loginError!,
                          style: const TextStyle(
                            color: _AuthColors.red,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          Row(
            children: [
              SizedBox(
                height: 28,
                width: 28,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: _AuthColors.blue,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Ingat Saya',
                  style: TextStyle(
                    color: _AuthColors.navy,
                    fontSize: 11,
                  ),
                ),
              ),
              TextButton(
                onPressed: _openForgotPassword,
                child: const Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(
                    color: _AuthColors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _loginButton(
            label: 'Masuk sebagai Mahasiswa Disabilitas',
            icon: Icons.accessible_forward,
            onPressed: () =>
                _login('Mahasiswa Disabilitas'),
          ),

          const SizedBox(height: 13),

          _loginButton(
            label: 'Masuk sebagai Pendamping',
            icon: Icons.support_agent_outlined,
            onPressed: () => _login('Pendamping'),
          ),

          const SizedBox(height: 26),

          const Row(
            children: [
              Expanded(
                child: Divider(
                  color: Color(0xFFE3E8F2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Text(
                  'ATAU',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Color(0xFFE3E8F2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Belum memiliki akun? ',
                style: TextStyle(
                  color: Color(0xFF777777),
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (widget.onRegister != null) {
                    widget.onRegister!();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Hubungkan tombol ke halaman Register.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Registrasi',
                  style: TextStyle(
                    color: _AuthColors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= LUPA KATA SANDI =================

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitReset() {
    final email = _emailController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailError = 'Wajib diisi';
      } else if (!RegExp(
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      ).hasMatch(email)) {
        _emailError = 'Email tidak valid';
      } else {
        _emailError = null;
      }
    });

    if (_emailError != null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20, 28, 20, 23,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFF18C51B),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 47,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Tautan reset terkirim',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Silakan periksa email Anda dan klik '
                  'tautan yang kami kirim untuk '
                  'mengatur ulang kata sandi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: _AuthColors.navy,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mode demo: email belum benar-benar dikirim.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 19),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF0057BF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke halaman login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 690;

    return _AuthBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          35, 0, 35, 35,
        ),
        children: [
          SizedBox(height: compact ? 20 : 100),
          const _AuthBrand(),
          SizedBox(height: compact ? 24 : 54),

          const Text(
            'Lupa kata sandi?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Masukkan username atau email yang\n'
            'terdaftar pada akun anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _AuthColors.navy,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 44),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Email Mahasiswa UB',
                  style: TextStyle(
                    color: _AuthColors.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_emailError != null)
                Text(
                  _emailError!,
                  style: const TextStyle(
                    color: _AuthColors.red,
                    fontSize: 10,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 47,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {
                if (_emailError != null) {
                  setState(() {
                    _emailError = null;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'nama_anda@student.ub.ac.id',
                hintStyle: const TextStyle(
                  color: Color(0xFFADB6C8),
                  fontSize: 11,
                ),
                prefixIcon: const Icon(
                  Icons.alternate_email,
                  color: _AuthColors.blue,
                  size: 19,
                ),
                filled: true,
                fillColor: _AuthColors.input,
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: _emailError == null
                        ? const Color(0xFFD9DDEB)
                        : _AuthColors.red,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: _AuthColors.blue,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: _submitReset,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF0057BF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(9),
                ),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.accessible_forward,
                    size: 19,
                  ),
                  SizedBox(width: 9),
                  Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
