import 'package:flutter/material.dart';
import '../presentation/pages/pendamping_home_page.dart';

/// Entry point terpisah. Tidak menyentuh main.dart milik tim.
void main() => runApp(const _HomePreviewApp());

class _HomePreviewApp extends StatelessWidget {
  const _HomePreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          void snack(String msg) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));

          return PendampingHomePage(
            // false = kondisi baru login. Ubah ke true untuk melihat terisi.
            initialHasJadwal: false,
            onMenuTap: () => snack('Menu ditekan (sidebar milik anggota lain)'),
            onJadwalPerkuliahanTap: (ctx) => Navigator.of(ctx).push<bool>(
              MaterialPageRoute(builder: (_) => const _JadwalStub()),
            ),
            onAkanDatangTap: () => snack('Akan Datang'),
            onBerlangsungTap: () => snack('Berlangsung'),
            onSelesaiTap: () => snack('Selesai'),
            onOngoingDetailTap: () => snack('Detail pendampingan berlangsung'),
            onNextDetailTap: () => snack('Detail pendampingan selanjutnya'),
          );
        },
      ),
    );
  }
}

/// Pengganti SEMENTARA halaman jadwal kegiatan. Hanya untuk tes.
class _JadwalStub extends StatelessWidget {
  const _JadwalStub();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Kegiatan (stub)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Anggap jadwal sudah diisi'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Kembali tanpa mengisi'),
            ),
          ],
        ),
      ),
    );
  }
}