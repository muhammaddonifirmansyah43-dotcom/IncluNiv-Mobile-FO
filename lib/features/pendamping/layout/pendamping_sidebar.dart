
import 'package:flutter/material.dart';

import '../../../shared/models/pendamping_profile_store.dart';
import '../../../shared/widgets/app_logo.dart';
import '../profile/profile_page.dart';
import '../notifikasi/notifikasi_page.dart';

// IDENTITAS MENU SIDEBAR
enum PendampingMenu {
  profil,
  notifikasi,
  jadwalKegiatan,
  pengisianJadwal,
  jadwalPendampingan,
}

// LAYOUT SIDEBAR KHUSUS BERANDA PENDAMPING
class PendampingHomeShell extends StatelessWidget {
  final Widget child;

  // Halaman tambahan dari anggota lain.
  // Profil dan Notifikasi sudah terhubung.
  final Map<PendampingMenu, WidgetBuilder> additionalPages;

  const PendampingHomeShell({
    super.key,
    required this.child,
    this.additionalPages = const {},
  });

  static const navy = Color(0xFF0F2D5B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // SIDEBAR HANYA BERADA DI BERANDA
      drawer: _PendampingDrawer(
        additionalPages: additionalPages,
      ),

      drawerScrimColor: Colors.black54,
      drawerEdgeDragWidth: 25,

      // HEADER BERANDA
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF2FF),
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black26,
        toolbarHeight: 56,
        automaticallyImplyLeading: false,
        titleSpacing: 12,

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/landing_illustration.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 7),
            const AppLogo(fontSize: 23),
          ],
        ),

        actions: [
          Builder(
            builder: (scaffoldContext) {
              return IconButton(
                tooltip: 'Buka sidebar pendamping',
                icon: const Icon(
                  Icons.menu,
                  color: navy,
                  size: 27,
                ),
                onPressed: () {
                  Scaffold.of(scaffoldContext).openDrawer();
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: child,
    );
  }
}

// KOMPONEN DRAWER PENDAMPING
class _PendampingDrawer extends StatelessWidget {
  final Map<PendampingMenu, WidgetBuilder> additionalPages;

  const _PendampingDrawer({
    required this.additionalPages,
  });

  static const navy = Color(0xFF0F2D5B);
  static const blue = Color(0xFF3B82F6);
  static const lightBlue = Color(0xFFEEF2FF);
  static const peach = Color(0xFFFFD7BB);

  // HALAMAN SEMENTARA
  Widget _placeholder(String title) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        foregroundColor: navy,
        backgroundColor: lightBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Halaman $title sedang dikerjakan '
            'oleh anggota kelompok.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: navy,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  // NAVIGASI MENU SIDEBAR
  void _openMenu(
    BuildContext context,
    PendampingMenu menu,
  ) {
    late final WidgetBuilder builder;

    switch (menu) {
      case PendampingMenu.profil:
        builder = (_) => const ProfilePendampingPage();
        break;

      case PendampingMenu.notifikasi:
        builder = (_) => const NotifikasiPage();
        break;

      case PendampingMenu.jadwalKegiatan:
        builder = additionalPages[menu] ??
            (_) => _placeholder('Jadwal Kegiatan');
        break;

      case PendampingMenu.pengisianJadwal:
        builder = additionalPages[menu] ??
            (_) => _placeholder('Pengisian Jadwal');
        break;

      case PendampingMenu.jadwalPendampingan:
        builder = additionalPages[menu] ??
            (_) => _placeholder('Jadwal Pendampingan');
        break;
    }

    // SIMPAN NAVIGATOR SEBELUM DRAWER DITUTUP
    final navigator = Navigator.of(context);

    // TUTUP SIDEBAR
    navigator.pop();

    // BUKA HALAMAN TUJUAN
    navigator.push(
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // LEBAR SIDEBAR RESPONSIF
    final drawerWidth =
        (screenWidth * 0.84).clamp(250.0, 345.0).toDouble();

    return Drawer(
      width: drawerWidth,
      backgroundColor: Colors.white,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),

      child: SafeArea(
        child: Column(
          children: [
            // HEADER SIDEBAR
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: const BoxDecoration(
                color: lightBlue,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFCFD6E4),
                  ),
                ),
              ),

              child: Row(
                children: [
                  Image.asset(
                    'assets/images/landing_illustration.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 7),

                  const AppLogo(fontSize: 23),

                  const Spacer(),

                  IconButton(
                    tooltip: 'Tutup sidebar',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: navy,
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),

            // KONTEN SIDEBAR
            Expanded(
              child: AnimatedBuilder(
                animation: PendampingProfileStore.instance,
                builder: (context, _) {
                  final store =
                      PendampingProfileStore.instance;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      18,
                      22,
                      25,
                    ),

                    children: [
                      // FOTO PROFIL
                      _profilePhoto(store),

                      const SizedBox(height: 23),

                      // NAMA PENDAMPING
                      Text(
                        store.nama.isEmpty
                            ? 'Nama Pendamping'
                            : store.nama,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // NOMOR INDUK
                      Text(
                        store.nim.isEmpty
                            ? 'NIM belum tersedia'
                            : store.nim,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // EMAIL
                      Text(
                        store.email.isEmpty
                            ? 'Email belum tersedia'
                            : store.email,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // MENU PROFIL
                      _menuButton(
                        context,
                        title: 'Profile Pendamping',
                        icon: Icons.person_outline,
                        menu: PendampingMenu.profil,
                      ),

                      // MENU NOTIFIKASI
                      _menuButton(
                        context,
                        title: 'Notifikasi',
                        icon: Icons.notifications_none,
                        menu: PendampingMenu.notifikasi,
                      ),

                      // MENU JADWAL KEGIATAN
                      _menuButton(
                        context,
                        title: 'Jadwal Kegiatan',
                        icon: Icons.access_time_outlined,
                        menu: PendampingMenu.jadwalKegiatan,
                      ),

                      // MENU PENGISIAN JADWAL
                      _menuButton(
                        context,
                        title: 'Pengisian Jadwal',
                        icon: Icons.event_note_outlined,
                        menu: PendampingMenu.pengisianJadwal,
                      ),

                      // MENU JADWAL PENDAMPINGAN
                      _menuButton(
                        context,
                        title: 'Jadwal Pendampingan',
                        icon: Icons.calendar_month_outlined,
                        menu: PendampingMenu.jadwalPendampingan,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FOTO PROFIL OTOMATIS MENGIKUTI DATA PROFIL
  Widget _profilePhoto(PendampingProfileStore store) {
    final foto = store.foto;

    return Center(
      child: Container(
        height: 122,
        width: 122,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: foto == null
              ? peach
              : const Color(0xFFF0F2F8),
          image: foto == null
              ? null
              : DecorationImage(
                  image: MemoryImage(foto),
                  fit: BoxFit.cover,
                ),
        ),

        child: foto == null
            ? const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 91,
              )
            : null,
      ),
    );
  }

  // TOMBOL MENU SIDEBAR
  Widget _menuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required PendampingMenu menu,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19),

      child: Align(
        alignment: Alignment.centerLeft,

        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 205,
          ),

          child: Material(
            color: lightBlue,
            elevation: 2,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(10),

            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _openMenu(context, menu),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 11,
                ),

                child: Row(
                  children: [
                    // IKON MENU
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9E6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: blue,
                        size: 17,
                      ),
                    ),

                    const SizedBox(width: 10),

                    // NAMA MENU
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
