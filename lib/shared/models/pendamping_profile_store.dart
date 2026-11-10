
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
