
import 'package:flutter/foundation.dart';

class PendampingProfileStore extends ChangeNotifier {
  PendampingProfileStore._();

  static final PendampingProfileStore instance =
      PendampingProfileStore._();

  String nama = '';
  String nim = '';
  String email = '';
  String telepon = '';
  String fakultas = '';
  String keahlian = '';

  Uint8List? foto;

  bool get hasProfile => nim.isNotEmpty;

  // Menyimpan data setelah registrasi.
  void saveRegistration({
    required String nama,
    required String nim,
    required String email,
    required String telepon,
    required String fakultas,
    required String keahlian,
  }) {
    this.nama = nama;
    this.nim = nim;
    this.email = email;
    this.telepon = telepon;
    this.fakultas = fakultas;
    this.keahlian = keahlian;
    foto = null;

    notifyListeners();
  }

  // Sinkronisasi profil dari backend setelah login.
  void syncFromApi(Map<String, dynamic> profile) {
    nama = profile['fullName']?.toString() ?? '';
    nim = profile['studentCode']?.toString() ?? '';
    email = profile['email']?.toString() ?? '';
    telepon = profile['phoneNumber']?.toString() ?? '';
    fakultas = profile['department']?.toString() ?? '';

    final skills = profile['skills'];

    keahlian = skills is List
        ? skills.join(', ')
        : skills?.toString() ?? '';

    notifyListeners();
  }

  // Memperbarui profil secara lokal.
  void updateProfile({
    required String email,
    required String telepon,
    required String keahlian,
    Uint8List? foto,
  }) {
    this.email = email;
    this.telepon = telepon;
    this.keahlian = keahlian;

    if (foto != null) {
      this.foto = foto;
    }

    notifyListeners();
  }

  void setFoto(Uint8List bytes) {
    foto = bytes;
    notifyListeners();
  }

  // Menghapus data profil saat logout.
  void clear() {
    nama = '';
    nim = '';
    email = '';
    telepon = '';
    fakultas = '';
    keahlian = '';
    foto = null;

    notifyListeners();
  }
}
