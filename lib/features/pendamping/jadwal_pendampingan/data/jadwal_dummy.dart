
enum JadwalStatus { akanDatang, berlangsung, selesai }

class JadwalItem {
  final String id;
  final String? mataKuliah;
  final String? kelas;
  final int? sks;
  final String tanggal;
  final String jam;
  final String lokasi;
  final String mahasiswa;
  final String jenisDisabilitas;
  final String kebutuhan;
  final String fakultas;
  final String telepon;
  final String? fotoUrl;
  final JadwalStatus status;

  // Status asli dari backend.
  final String? assignmentStatus;

  // Waktu asli penugasan dari backend.
  final DateTime? startAt;
  final DateTime? endAt;

  const JadwalItem({
    required this.id,
    this.mataKuliah,
    this.kelas,
    this.sks,
    required this.tanggal,
    required this.jam,
    required this.lokasi,
    required this.mahasiswa,
    this.jenisDisabilitas = 'Belum tersedia',
    this.kebutuhan = 'Belum tersedia',
    this.fakultas = 'Belum tersedia',
    this.telepon = 'Belum tersedia',
    required this.status,
    this.fotoUrl,
    this.assignmentStatus,
    this.startAt,
    this.endAt,
  });

  factory JadwalItem.fromJson(Map<String, dynamic> json) {
    final student = json['student'] is Map
        ? Map<String, dynamic>.from(json['student'])
        : <String, dynamic>{};

    final user = student['user'] is Map
        ? Map<String, dynamic>.from(student['user'])
        : <String, dynamic>{};

    final startAt = DateTime.tryParse(
      json['startAt']?.toString() ?? '',
    );

    final endAt = DateTime.tryParse(
      json['endAt']?.toString() ?? '',
    );

    final backendStatus = json['status']?.toString() ?? 'PENDING';

    final JadwalStatus mappedStatus;

    switch (backendStatus) {
      case 'ACCEPTED':
      case 'ONGOING':
        mappedStatus = JadwalStatus.berlangsung;
        break;
      case 'COMPLETED':
        mappedStatus = JadwalStatus.selesai;
        break;
      default:
        mappedStatus = JadwalStatus.akanDatang;
    }

    String formatDate(DateTime? date) {
      if (date == null) return 'Tanggal belum tersedia';

      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    String formatTime(DateTime? date) {
      if (date == null) return '--:--';

      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$hour:$minute';
    }

    final location = json['location']?.toString();

    return JadwalItem(
      id: json['id'].toString(),
      tanggal: formatDate(startAt),
      jam: '${formatTime(startAt)} - ${formatTime(endAt)} WIB',
      lokasi: location == null || location.isEmpty
          ? 'Lokasi belum tersedia'
          : location,
      mahasiswa: user['fullName']?.toString() ?? 'Mahasiswa',
      jenisDisabilitas:
          student['disabilityType']?.toString() ?? 'Belum tersedia',
      kebutuhan:
          student['supportNeeds']?.toString() ?? 'Belum tersedia',
      telepon: user['phoneNumber']?.toString() ?? 'Belum tersedia',
      fotoUrl: user['photoUrl']?.toString(),
      status: mappedStatus,
      assignmentStatus: backendStatus,
      startAt: startAt,
      endAt: endAt,
    );
  }

  JadwalItem copyWith({
    JadwalStatus? status,
    String? assignmentStatus,
  }) {
    return JadwalItem(
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
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      startAt: startAt,
      endAt: endAt,
    );
  }
}

/// Dummy data hanya untuk kebutuhan preview.
class JadwalDummy {
  static final List<JadwalItem> items = [
    const JadwalItem(
      id: 'j1',
      mataKuliah: 'Interaksi Manusia & Komputer',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '13:00 - 15:30 WIB',
      lokasi: 'Gedung F FILKOM, R. 3.2',
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
      lokasi: 'Gedung F FILKOM, R. 4.12',
      mahasiswa: 'Keonho',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.akanDatang,
    ),
    const JadwalItem(
      id: 'j3',
      mataKuliah: 'Manajemen Sistem Informasi',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '07:00 - 08:40 WIB',
      lokasi: 'Gedung Vokasi Dieng lt. 4',
      mahasiswa: 'Keonho',
      jenisDisabilitas: 'Disabilitas Rungu',
      kebutuhan: 'Juru Bahasa Isyarat/Typist',
      fakultas: 'Fakultas Ilmu Komputer',
      telepon: '+62 812-3456-7890',
      status: JadwalStatus.berlangsung,
    ),
    const JadwalItem(
      id: 'j4',
      mataKuliah: 'Interaksi Manusia & Komputer',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '13:00 - 15:30 WIB',
      lokasi: 'Gedung F FILKOM, R. 3.2',
      mahasiswa: 'Rizki',
      status: JadwalStatus.selesai,
    ),
    const JadwalItem(
      id: 'j5',
      mataKuliah: 'Agama Islam',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Rabu, 30 Okt 2024',
      jam: '14:00 - 16:10 WIB',
      lokasi: 'Gedung F FILKOM, R. 1.2',
      mahasiswa: 'Raditya',
      status: JadwalStatus.selesai,
    ),
    const JadwalItem(
      id: 'j6',
      mataKuliah: 'Manajemen Sistem Informasi',
      kelas: 'Kelas C',
      sks: 3,
      tanggal: 'Senin, 28 Okt 2024',
      jam: '07:00 - 08:40 WIB',
      lokasi: 'Gedung Vokasi Dieng lt. 4',
      mahasiswa: 'Keonho',
      status: JadwalStatus.selesai,
    ),
  ];
}
