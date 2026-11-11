
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Penyimpanan data profil Mahasiswa Difabel sementara.
/// Data dapat berasal dari registrasi atau edit profil.
///
/// Belum menggunakan database atau backend.
class ProfilStore extends ChangeNotifier {
  ProfilStore._();

  static final ProfilStore instance = ProfilStore._();

  // =========================================
  // DATA PROFIL MAHASISWA DIFABEL
  // =========================================

  String nama = 'Dono Prasetyo';
  String nim = '254365796116534';
  String email = 'karinaputri@student.ub.ac.id';
  String telepon = '084523456745';
  String prodi = 'Fakultas Ilmu Komputer/Teknik Informatika';
  String disabilitas = 'Tuli';
  String sandi = 'password';

  // Foto profil disimpan sebagai bytes.
  // null berarti menggunakan ikon profil default.
  Uint8List? foto;

  // =========================================
  // NAMA PANGGILAN
  // =========================================

  String get panggilan {
    final namaBersih = nama.trim();

    if (namaBersih.isEmpty) {
      return 'Mahasiswa';
    }

    return namaBersih.split(RegExp(r'\s+')).first;
  }

  // =========================================
  // MENYIMPAN DATA DARI HALAMAN REGISTER
  // =========================================

  void isiDariRegistrasi({
    required String nama,
    required String nim,
    required String email,
    required String telepon,
    required String prodi,
    required String disabilitas,
  }) {
    this.nama = nama.trim();
    this.nim = nim.trim();
    this.email = email.trim();
    this.telepon = telepon.trim();
    this.prodi = prodi.trim();
    this.disabilitas = disabilitas.trim();

    // Akun baru menggunakan foto default.
    foto = null;

    // Memberi tahu halaman yang menggunakan ProfilStore
    // supaya memperbarui tampilan.
    notifyListeners();
  }

  // =========================================
  // MENYIMPAN PERUBAHAN DARI EDIT PROFIL
  // =========================================

  void simpan({
    required String nama,
    required String email,
    required String telepon,
    required String sandi,
    Uint8List? foto,
  }) {
    this.nama = nama.trim();
    this.email = email.trim();
    this.telepon = telepon.trim();
    this.sandi = sandi;
    this.foto = foto;

    notifyListeners();
  }
}
