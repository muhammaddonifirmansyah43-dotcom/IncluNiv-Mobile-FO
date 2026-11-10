
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/app_illustration.dart';
import '../register/register_page.dart';

class LandingPage extends StatelessWidget {
  final VoidCallback? onRegister;
  final VoidCallback? onLogin;

  const LandingPage({
    super.key,
    this.onRegister,
    this.onLogin,
  });

  static const navy = Color(0xFF0F2D5B);
  static const orange = Color(0xFFF97316);

  // Navigasi ke halaman Register
  void _openRegister(BuildContext context) {
    if (onRegister != null) {
      onRegister!();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Dekorasi kiri atas
              Positioned(
                top: -55,
                left: -55,
                child: _circle(
                  const Color(0xFFDCE8FF),
                  135,
                ),
              ),

              Positioned(
                top: 35,
                left: -65,
                child: _circle(
                  const Color(0xFFFFE3D4),
                  100,
                ),
              ),

              // Dekorasi kanan atas
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

              // Dekorasi kanan bawah
              Positioned(
                bottom: -55,
                right: -55,
                child: _circle(
                  const Color(0xFFFFE3D4),
                  120,
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight -
                          MediaQuery.of(context).padding.vertical,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),

                          // Logo global
                          const AppLogo(fontSize: 30),

                          const SizedBox(height: 24),

                          // Deskripsi aplikasi
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: Text(
                              'Platform yang dirancang untuk mendukung '
                              'mahasiswa penyandang disabilitas agar lebih '
                              'mudah mendapatkan hak pendidikan setara',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: navy,
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                          ),

                          const SizedBox(height: 34),

                          // Ilustrasi asli
                          const AppIllustration(size: 205),

                          const SizedBox(height: 32),

                          // Tombol buat akun
                          _button(
                            text: 'BUAT AKUN',
                            filled: true,
                            onPressed: () {
                              _openRegister(context);
                            },
                          ),

                          const SizedBox(height: 13),

                          // Tombol masuk
                          _button(
                            text: 'MASUK',
                            filled: false,
                            onPressed: () {
                              if (onLogin != null) {
                                onLogin!();
                              } else {
                                _message(
                                  context,
                                  'Halaman login belum dihubungkan.',
                                );
                              }
                            },
                          ),

                          const Spacer(),

                          const SizedBox(height: 40),

                          // Footer informasi
                          const _LandingFooter(),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _circle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _button({
    required String text,
    required bool filled,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: SizedBox(
        width: double.infinity,
        height: 43,
        child: filled
            ? ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: orange,
                  side: const BorderSide(
                    color: orange,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

  void _message(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

// FOOTER LANDING PAGE

class _LandingFooter extends StatelessWidget {
  const _LandingFooter();

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0F2D5B);
    const orange = Color(0xFFF97316);

    Widget item(IconData icon, String text) {
      return Row(
        children: [
          Icon(
            icon,
            color: orange,
            size: 13,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: navy,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          item(
            Icons.location_on,
            'Jl. Veteran, Ketawanggede, Lowokwaru, Kota Malang, Jawa Timur',
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: item(
                  Icons.phone,
                  '(0341) 551-611',
                ),
              ),
              Expanded(
                child: item(
                  Icons.email_outlined,
                  'info@ub.ac.id',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: item(
                  Icons.camera_alt_outlined,
                  '@pld.ub',
                ),
              ),
              Expanded(
                child: item(
                  Icons.language,
                  'pld.ub.ac.id',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
