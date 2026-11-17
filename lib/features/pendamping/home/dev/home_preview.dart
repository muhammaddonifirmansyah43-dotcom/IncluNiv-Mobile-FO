
import 'package:flutter/material.dart';

import '../presentation/pages/pendamping_home_page.dart';

void main() {
  runApp(const HomePreviewApp());
}

class HomePreviewApp extends StatefulWidget {
  const HomePreviewApp({super.key});

  @override
  State<HomePreviewApp> createState() =>
      _HomePreviewAppState();
}

class _HomePreviewAppState extends State<HomePreviewApp> {
  // Default preview: akun Pendamping baru.
  bool isNewAccount = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          void snack(String pesan) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(pesan)),
            );
          }

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // PILIH KONDISI UNTUK PREVIEW
                  Container(
                    color: const Color(0xFFEEF2FF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Preview Pendamping Baru',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F2D5B),
                            ),
                          ),
                        ),
                        Switch(
                          value: isNewAccount,
                          activeThumbColor:
                              const Color(0xFF3B82F6),
                          onChanged: (value) {
                            setState(() {
                              isNewAccount = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // BERANDA PENDAMPING
                  Expanded(
                    child: PendampingHomePage(
                      isNewAccount: isNewAccount,
                      showAppBar: true,

                      onMenuTap: () {
                        snack('Menu ditekan');
                      },

                      onAkanDatangTap: () {
                        snack('Akan Datang');
                      },

                      onBerlangsungTap: () {
                        snack('Berlangsung');
                      },

                      onSelesaiTap: () {
                        snack('Selesai');
                      },

                      onOngoingDetailTap: () {
                        snack(
                          'Detail pendampingan berlangsung',
                        );
                      },

                      onNextDetailTap: () {
                        snack(
                          'Detail pendampingan selanjutnya',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
