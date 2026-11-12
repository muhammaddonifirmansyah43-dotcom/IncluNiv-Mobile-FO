import 'package:flutter/material.dart';
import '../presentation/pages/pendamping_home_page.dart';
import '../../jadwal_kegiatan/pages/jadwal_kegiatan_page.dart';
import '../../jadwal_pendampingan/data/jadwal_dummy.dart';
import '../../jadwal_pendampingan/presentation/pages/jadwal_pendampingan_page.dart';

void main() => runApp(const _RealHomePreviewApp());

class _RealHomePreviewApp extends StatelessWidget {
  const _RealHomePreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          void openJadwal(JadwalStatus tab) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => JadwalPendampinganPage(initialTab: tab),
              ),
            );
          }

          return PendampingHomePage(
            initialHasJadwal: false,
            onJadwalPerkuliahanTap: (ctx) async {
              await Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => const JadwalKegiatanPage(), // sesuaikan nama
                ),
              );
              // SEMENTARA: dianggap terisi setelah kembali, hanya untuk tes.
              return true;
            },
            onAkanDatangTap: () => openJadwal(JadwalStatus.akanDatang),
            onBerlangsungTap: () => openJadwal(JadwalStatus.berlangsung),
            onSelesaiTap: () => openJadwal(JadwalStatus.selesai),
            onOngoingDetailTap: () => openJadwal(JadwalStatus.berlangsung),
            onNextDetailTap: () => openJadwal(JadwalStatus.akanDatang),
          );
        },
      ),
    );
  }
}