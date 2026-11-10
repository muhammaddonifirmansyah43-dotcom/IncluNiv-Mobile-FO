import 'package:flutter/material.dart';
import '../features/pendamping/logout/logout_dialog.dart';

void main() {
  runApp(const PreviewLogoutApp());
}

class PreviewLogoutApp extends StatelessWidget {
  const PreviewLogoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PreviewLogoutPage(),
    );
  }
}

class PreviewLogoutPage extends StatelessWidget {
  const PreviewLogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      appBar: AppBar(
        title: const Text('Preview Logout'),
        backgroundColor: const Color(0xFF0F2D5B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await LogoutDialog.show(context);

            if (!context.mounted) return;

            if (result == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Konfirmasi logout berhasil diuji.',
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Tampilkan Popup Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF97316),
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}