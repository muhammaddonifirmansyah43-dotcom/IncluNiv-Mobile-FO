
import 'package:flutter/material.dart';

// ==========================================
// AUTHENTICATION
// ==========================================
import 'features/auth/landing/landing_page.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';

// ==========================================
// MAHASISWA DIFABEL
// ==========================================
import 'features/mahasiswa/pages/beranda_page.dart';

// ==========================================
// PENDAMPING
// ==========================================
import 'features/pendamping/home/presentation/pages/pendamping_home_page.dart';
import 'features/pendamping/layout/pendamping_sidebar.dart';

// JADWAL KEGIATAN PENDAMPING
import 'features/pendamping/jadwal_kegiatan/pages/jadwal_kegiatan_page.dart';
import 'features/pendamping/jadwal_kegiatan/pages/jadwal_form_page.dart'
    as kegiatan;

// JADWAL PENDAMPINGAN
import 'features/pendamping/jadwal_pendampingan/presentation/pages/jadwal_pendampingan_page.dart';
import 'features/pendamping/jadwal_pendampingan/data/jadwal_dummy.dart'
    as jp;

// ==========================================
// ENTRY POINT APLIKASI
// ==========================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const IncluNivApp());
}

// ==========================================
// APLIKASI UTAMA
// ==========================================

class IncluNivApp extends StatelessWidget {
  const IncluNivApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IncluNiv',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
        ),

        scaffoldBackgroundColor: Colors.white,
      ),

      // HALAMAN PERTAMA
      initialRoute: '/',

      // ====================================
      // ROUTING SEMUA HALAMAN
      // ====================================

      routes: {
        // LANDING PAGE
        '/': (context) => LandingPage(
              onRegister: () {
                Navigator.of(context).pushNamed('/register');
              },
              onLogin: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),

        // REGISTER
        '/register': (context) => RegisterPage(
              onLogin: () {
                Navigator.of(context).pushReplacementNamed(
                  '/login',
                );
              },

              onRegistered: () {
                Navigator.of(context).pushReplacementNamed(
                  '/login',
                );
              },
            ),

        // LOGIN
        '/login': (context) => LoginPage(
              onRegister: () {
                Navigator.of(context).pushNamed(
                  '/register',
                );
              },

              onLoginSuccess: (role) {
                // PILIH BERANDA SESUAI AKTOR
                final tujuan = role == 'Pendamping'
                    ? '/pendamping'
                    : '/mahasiswa';

                // HAPUS HALAMAN LOGIN DARI RIWAYAT
                Navigator.of(context).pushNamedAndRemoveUntil(
                  tujuan,
                  (route) => false,
                );
              },
            ),

        // BERANDA MAHASISWA DIFABEL
        '/mahasiswa': (context) =>
            const BerandaMahasiswaPage(),

        // BERANDA PENDAMPING
        '/pendamping': (context) =>
            _BerandaPendampingTerintegrasi(
              onLogout: () {
                // KEMBALI KE LANDING
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
            ),
      },
    );
  }
}

// ==========================================
// INTEGRASI BERANDA DAN SIDEBAR PENDAMPING
// ==========================================

class _BerandaPendampingTerintegrasi
    extends StatelessWidget {
  final VoidCallback onLogout;

  const _BerandaPendampingTerintegrasi({
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // ====================================
    // FUNGSI BUKA JADWAL PENDAMPINGAN
    // ====================================

    void openJadwal([
      jp.JadwalStatus tab = jp.JadwalStatus.akanDatang,
    ]) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => JadwalPendampinganPage(
            initialTab: tab,
          ),
        ),
      );
    }

    // ====================================
    // LAYOUT PENDAMPING
    // ====================================

    return PendampingHomeShell(
      // CALLBACK LOGOUT
      onLogoutConfirmed: onLogout,

      // ==================================
      // MENU SIDEBAR
      // ==================================
      additionalPages: {
        // JADWAL KEGIATAN
        PendampingMenu.jadwalKegiatan: (_) =>
            const JadwalKegiatanPage(),

        // PENGISIAN JADWAL
        PendampingMenu.pengisianJadwal: (_) =>
            const kegiatan.JadwalFormPage(),

        // JADWAL PENDAMPINGAN
        PendampingMenu.jadwalPendampingan: (_) =>
            const JadwalPendampinganPage(),
      },

      // ==================================
      // BERANDA ASLI BUATAN NAURA
      // ==================================
      child: PendampingHomePage(
        // MENGHINDARI DOUBLE APPBAR
        showAppBar: false,

        // KARTU AKAN DATANG
        onAkanDatangTap: () {
          openJadwal();
        },

        // KARTU BERLANGSUNG
        onBerlangsungTap: () {
          openJadwal(
            jp.JadwalStatus.berlangsung,
          );
        },

        // KARTU SELESAI
        onSelesaiTap: () {
          openJadwal(
            jp.JadwalStatus.selesai,
          );
        },

        // DETAIL PENDAMPINGAN BERLANGSUNG
        onOngoingDetailTap: () {
          openJadwal(
            jp.JadwalStatus.berlangsung,
          );
        },

        // DETAIL PENDAMPINGAN SELANJUTNYA
        onNextDetailTap: () {
          openJadwal();
        },
      ),
    );
  }
}
