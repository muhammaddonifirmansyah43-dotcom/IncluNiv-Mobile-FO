import 'package:flutter/material.dart';

/// Data profil dummy (diambil dari frame Figma).
class ProfilStore extends ChangeNotifier {
  ProfilStore._();

  static final ProfilStore instance = ProfilStore._();

  String nama = 'Dono Prasetyo';
  final String nim = '254365796116534';
  String email = 'karinaputri@student.ub.ac.id';
  String telepon = '084523456745';
  final String prodi = 'Fakultas Ilmu Komputer/Teknik Informatika';
  final String disabilitas = 'Tuli';
  String sandi = 'password';

  String get panggilan => nama.trim().split(RegExp(r'\s+')).first;

  void simpan({
    required String nama,
    required String email,
    required String telepon,
    required String sandi,
  }) {
    this.nama = nama;
    this.email = email;
    this.telepon = telepon;
    this.sandi = sandi;
    notifyListeners();
  }
}
