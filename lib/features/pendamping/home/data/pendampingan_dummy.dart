class PendampinganItem {
  final String namaMahasiswa;
  final String jam;
  final String lokasi;
  final String? fotoUrl; // null = tampilkan placeholder

  const PendampinganItem({
    required this.namaMahasiswa,
    required this.jam,
    required this.lokasi,
    this.fotoUrl,
  });
}

class RiwayatSummary {
  final int akanDatang;
  final int berlangsung;
  final int selesai;

  const RiwayatSummary({
    required this.akanDatang,
    required this.berlangsung,
    required this.selesai,
  });
}

/// Dummy data sementara, sampai backend terintegrasi.
class PendampingHomeDummy {
  static const String namaPendamping = 'Karina Putri';

  static const RiwayatSummary riwayat = RiwayatSummary(
    akanDatang: 1,
    berlangsung: 1,
    selesai: 3,
  );

  static const PendampinganItem berlangsung = PendampinganItem(
    namaMahasiswa: 'Keonho',
    jam: '07:00 - 08:40',
    lokasi: 'Gedung Vokasi Dieng, lt. 4\nRuang A402',
  );

  static const PendampinganItem selanjutnya = PendampinganItem(
    namaMahasiswa: 'Keonho',
    jam: '09:00 - 12:40',
    lokasi: 'Gedung Filkom A. Lt. 2 Ruang A214',
  );
}