
import 'package:flutter/material.dart';

import '../features/auth/register/register_page.dart';
import '../features/pendamping/profile/profile_page.dart';
import '../shared/models/pendamping_profile_store.dart';

void main() {
  runApp(const PreviewProfileApp());
}

class PreviewProfileApp extends StatelessWidget {
  const PreviewProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Preview Profil Pendamping',
      debugShowCheckedModeBanner: false,
      home: PreviewMenu(),
    );
  }
}

class PreviewMenu extends StatelessWidget {
  const PreviewMenu({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0F2D5B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Profil Pendamping'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pengujian frontend IniClUniv',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: navy,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                _open(context, const RegisterPage());
              },
              child: const Text(
                '1. Isi Register Pendamping',
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                _open(
                  context,
                  const ProfilePendampingPage(),
                );
              },
              child: const Text(
                '2. Lihat dan Edit Profil',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Isi form Registrasi Pendamping terlebih dahulu, '
              'tekan Daftar, lalu kembali ke menu preview '
              'dan buka Profil.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () {
                PendampingProfileStore.instance.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Data demo profil dikosongkan.',
                    ),
                  ),
                );
              },
              child: const Text(
                'Reset Data Demo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
