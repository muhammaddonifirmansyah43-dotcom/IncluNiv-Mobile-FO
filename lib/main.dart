
import 'package:flutter/material.dart';

// ==========================================
// AUTHENTICATION
// ==========================================
import 'features/auth/landing/landing_page.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';

// SERVICES DAN PROFILE STORE
import 'services/auth_service.dart';
import 'services/mentor_profile_service.dart';
import 'shared/models/pendamping_profile_store.dart';

// STATUS AKUN DEMO / AKUN BARU
import 'shared/models/demo_auth_store.dart';

// ==========================================
// MAHASISWA DIFABEL
// ==========================================
import 'features/mahasiswa/pages/beranda_page.dart';
import 'features/mahasiswa/data/jadwal_store.dart';

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
// APLIKASI UTAMA INCLUNIV
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
      initialRoute: '/',
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
                Navigator.of(context).pushReplacementNamed('/login');
              },
              onRegistered: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),

        // LOGIN
        '/login': (context) => LoginPage(
              onRegister: () {
                Navigator.of(context).pushNamed('/register');
              },
              onLoginSuccess: (role) async {
                // MENGATUR DATA DASHBOARD MAHASISWA
                if (role == 'Mahasiswa') {
                  if (DemoAuthStore.instance.isDemoMahasiswaLogin) {
                    JadwalStore.instance.isiDataContoh();
                  } else {
                    JadwalStore.instance.kosongkan();
                  }
                }

                // SINKRONISASI PROFIL PENDAMPING DARI BACKEND
                if (role == 'Pendamping') {
                  final profile =
                      await MentorProfileService.getMyProfile();

                  PendampingProfileStore.instance.syncFromApi(profile);
                }

                // CEK CONTEXT SETELAH PROSES ASYNC
                if (!context.mounted) return;

                // MENENTUKAN BERANDA SESUAI AKTOR
                final tujuan = role == 'Pendamping'
                    ? '/pendamping'
                    : '/mahasiswa';

                // HAPUS RIWAYAT HALAMAN LOGIN
                Navigator.of(context).pushNamedAndRemoveUntil(
                  tujuan,
                  (route) => false,
                );
              },
            ),

        // BERANDA MAHASISWA DIFABEL
        '/mahasiswa': (context) => const BerandaMahasiswaPage(),

        // BERANDA PENDAMPING
        '/pendamping': (context) => _BerandaPendampingTerintegrasi(
              onLogout: () async {
                // HAPUS TOKEN LOGIN BACKEND
                await AuthService.logout();

                // RESET STATUS SESI PENDAMPING
                DemoAuthStore.instance.isBackendPendampingLogin = false;
                DemoAuthStore.instance.isNewPendampingLogin = false;

                if (!context.mounted) return;

                // KEMBALI KE LANDING PAGE
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

class _BerandaPendampingTerintegrasi extends StatelessWidget {
  final VoidCallback onLogout;

  const _BerandaPendampingTerintegrasi({
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // CEK STATUS AKUN PENDAMPING
    final bool isNewPendamping =
        DemoAuthStore.instance.isNewPendampingLogin;

    // FUNGSI BUKA JADWAL PENDAMPINGAN
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

    // LAYOUT BERANDA PENDAMPING
    return PendampingHomeShell(
      onLogoutConfirmed: onLogout,
      additionalPages: {
        PendampingMenu.jadwalKegiatan: (_) =>
            const JadwalKegiatanPage(),
        PendampingMenu.pengisianJadwal: (_) =>
            const kegiatan.JadwalFormPage(),
        PendampingMenu.jadwalPendampingan: (_) =>
            const JadwalPendampinganPage(),
      },
      child: PendampingHomePage(
        showAppBar: false,
        onJadwalPerkuliahanTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const kegiatan.JadwalFormPage(),
            ),
          );
        },
        isNewAccount: isNewPendamping,
        onAkanDatangTap: () {
          openJadwal();
        },
        onBerlangsungTap: () {
          openJadwal(jp.JadwalStatus.berlangsung);
        },
        onSelesaiTap: () {
          openJadwal(jp.JadwalStatus.selesai);
        },
        onOngoingDetailTap: () {
          openJadwal(jp.JadwalStatus.berlangsung);
        },
        onNextDetailTap: () {
          openJadwal();
        },
      ),
    );
  }
}
