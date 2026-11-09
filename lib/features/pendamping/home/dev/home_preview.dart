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
            onMenuTap: () => snack('Menu ditekan (sidebar milik anggota lain)'),
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