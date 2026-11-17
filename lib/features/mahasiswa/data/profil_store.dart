
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfilStore extends ChangeNotifier {
  ProfilStore._();

  static final ProfilStore instance = ProfilStore._();

  // DATA PROFIL MAHASISWA
  String nama = 'Dono Prasetyo';
  String nim = '254365796116534';
  String email = 'karinaputri@student.ub.ac.id';
  String telepon = '084523456745';
  String prodi = 'Fakultas Ilmu Komputer/Teknik Informatika';
  String disabilitas = 'Tuli';

  // FOTO PROFIL DALAM BENTUK BYTES
  Uint8List? foto;

  // NAMA PANGGILAN
  String get panggilan {
    final namaBersih = nama.trim();

    if (namaBersih.isEmpty) return 'Mahasiswa';

    return namaBersih.split(RegExp(r'\s+')).first;
  }

  // MENYIMPAN DATA DARI REGISTRASI
  void isiDariRegistrasi({
    required String nama,
    required String nim,
    required String email,
    required String telepon,
    required String prodi,
    required String disabilitas,
    required Uint8List fotoBytes,
  }) {
    this.nama = nama.trim();
    this.nim = nim.trim();
    this.email = email.trim();
    this.telepon = telepon.trim();
    this.prodi = prodi.trim();
    this.disabilitas = disabilitas.trim();

    // Foto langsung disimpan sebagai bytes.
    foto = fotoBytes;

    notifyListeners();
  }
}
