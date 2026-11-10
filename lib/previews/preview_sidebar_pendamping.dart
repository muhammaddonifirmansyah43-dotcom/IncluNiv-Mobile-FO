
import 'package:flutter/material.dart';

import '../features/pendamping/layout/pendamping_sidebar.dart';
import '../shared/models/pendamping_profile_store.dart';

void main() {
  runApp(const PreviewSidebarApp());
}

class PreviewSidebarApp extends StatelessWidget {
  const PreviewSidebarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preview Sidebar Pendamping',
      home: PreviewBerandaPendamping(),
    );
  }
}

class PreviewBerandaPendamping extends StatelessWidget {
  const PreviewBerandaPendamping({super.key});

  @override
  Widget build(BuildContext context) {
    return PendampingHomeShell(
      child: AnimatedBuilder(
        animation: PendampingProfileStore.instance,
        builder: (context, _) {
          final store =
              PendampingProfileStore.instance;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Beranda Pendamping',
                  style: TextStyle(
                    color: Color(0xFF0F2D5B),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Halo, ${store.nama.isEmpty ? "Pendamping" : store.nama}!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0F2D5B),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F0FF),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Ini adalah Beranda sementara '
                    'untuk menguji Sidebar Pendamping.\n\n'
                    'Tekan ikon menu (☰) pada bagian '
                    'kanan atas untuk membuka sidebar.',
                    style: TextStyle(
                      color: Color(0xFF0F2D5B),
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Menu yang sudah bisa diuji:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2D5B),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  '• Profile Pendamping\n'
                  '• Notifikasi\n'
                  '• Jadwal Kegiatan (sementara)\n'
                  '• Pengisian Jadwal (sementara)\n'
                  '• Jadwal Pendampingan (sementara)',
                  style: TextStyle(
                    height: 1.9,
                    color: Color(0xFF0F2D5B),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
