enum JadwalStatus { akanDatang, berlangsung, selesai }

class JadwalItem {
  final String id;
  final String mataKuliah;
  final String kelas;
  final int sks;
  final String tanggal;
  final String jam;
  final String lokasi;
  final String mahasiswa;
  final String jenisDisabilitas;
  final String kebutuhan;
  final String fakultas;
  final String telepon;
  final String? fotoUrl; // null = tampilkan placeholder
  final JadwalStatus status;

  const JadwalItem({
    required this.id,
    required this.mataKuliah,
    required this.kelas,
    required this.sks,
    required this.tanggal,
    required this.jam,
    required this.lokasi,
    required this.mahasiswa,
    required this.jenisDisabilitas,
    required this.kebutuhan,
    required this.fakultas,
    required this.telepon,
    required this.status,
    this.fotoUrl,
  });

  JadwalItem copyWith({JadwalStatus? status}) => JadwalItem(
        id: id,
        mataKuliah: mataKuliah,
        kelas: kelas,
        sks: sks,
        tanggal: tanggal,
        jam: jam,
        lokasi: lokasi,
        mahasiswa: mahasiswa,
        jenisDisabilitas: jenisDisabilitas,
        kebutuhan: kebutuhan,
        fakultas: fakultas,
        telepon: telepon,
        fotoUrl: fotoUrl,
        status: status ?? this.status,
      );
}

/// Dummy data sementara, sampai backend terintegrasi.
class JadwalDummy {
  static final List<JadwalItem> items = [
    // ---- Akan Datang ----
    const JadwalItem(
      id: 'j1',
      mataKuliah: 'Interaksi Manusia & Komputer',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '13:00 - 15:30 WIB',
      lokasi: 'Gedung F FILKOM, R. 3.2 (Lift Aktif)',
      mahasiswa: 'Keonho',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.akanDatang,
    ),
    const JadwalItem(
      id: 'j2',
      mataKuliah: 'Pemrograman Dasar',
      kelas: 'Kelas D',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '13:00 - 15:30 WIB',
      lokasi: 'Gedung F FILKOM, R. 4.12 (Lift Aktif)',
      mahasiswa: 'Keonho',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.akanDatang,
    ),
    // ---- Berlangsung ----
    const JadwalItem(
      id: 'j3',
      mataKuliah: 'Manajemen Sistem Informasi',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '07:00 - 08:40 WIB',
      lokasi: 'Gedung Vokasi Dieng lt. 4. Ruang A402',
      mahasiswa: 'Keonho',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.berlangsung,
    ),
    // ---- Selesai ----
    const JadwalItem(
      id: 'j4',
      mataKuliah: 'Interaksi Manusia & Komputer',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '13:00 - 15:30 WIB',
      lokasi: 'Gedung F FILKOM, R. 3.2 (Lift Aktif)',
      mahasiswa: 'Rizki',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.selesai,
    ),
    const JadwalItem(
      id: 'j5',
      mataKuliah: 'Agama Islam',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Rabu, 30 Okt 2024',
      jam: '14:00 - 16:10 WIB',
      lokasi: 'Gedung F FILKOM, R. 1.2 (Lift Aktif)',
      mahasiswa: 'Raditya',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.selesai,
    ),
    const JadwalItem(
      id: 'j6',
      mataKuliah: 'Manajemen Sistem Informasi',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '07:00 - 08:40 WIB',
      lokasi: 'Gedung Vokasi Dieng lt. 4. Ruang A402',
      mahasiswa: 'Keonho',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.selesai,
    ),
  ];
}