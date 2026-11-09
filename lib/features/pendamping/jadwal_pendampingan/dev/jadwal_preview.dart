import 'package:flutter/material.dart';
import '../../home/presentation/pages/pendamping_home_page.dart';
import '../data/jadwal_dummy.dart';
import '../presentation/pages/jadwal_pendampingan_page.dart';

/// Entry point terpisah. Tidak menyentuh main.dart / routing tim.
void main() => runApp(const _JadwalPreviewApp());

class _JadwalPreviewApp extends StatelessWidget {
  const _JadwalPreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          void open(JadwalStatus tab) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => JadwalPendampinganPage(initialTab: tab),
              ),
            );
          }

          return PendampingHomePage(
            onAkanDatangTap: () => open(JadwalStatus.akanDatang),
            onBerlangsungTap: () => open(JadwalStatus.berlangsung),
            onSelesaiTap: () => open(JadwalStatus.selesai),
            onOngoingDetailTap: () => open(JadwalStatus.berlangsung),
            onNextDetailTap: () => open(JadwalStatus.akanDatang),
          );
        },
      ),
    );
  }
}