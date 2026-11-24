
class DemoAuthStore {
  DemoAuthStore._();

  static final DemoAuthStore instance = DemoAuthStore._();

  String? _email;
  String? _password;
  String? _role;

  // Dipertahankan agar halaman lain tidak error.
  bool isNewPendampingLogin = false;
  bool isDemoMahasiswaLogin = false;

  // Menandai sesi pendamping yang berhasil login melalui backend.
  bool isBackendPendampingLogin = false;

  // Menyimpan akun hasil registrasi berdasarkan EMAIL.
  void register({
    required String email,
    required String password,
    required String role,
  }) {
    _email = email.trim().toLowerCase();
    _password = password;
    _role = role;
  }

  // Memeriksa email, password, dan jenis pengguna.
  
bool canLogin(
  String email,
  String password,
  String role,
) {
  final cleanEmail = email.trim().toLowerCase();

  isNewPendampingLogin = false;
  isDemoMahasiswaLogin = false;

  // AKUN DEMO MAHASISWA
  if (cleanEmail == 'mahasiswa@incluniv.test' &&
      password == 'Demo12345' &&
      role == 'Mahasiswa Disabilitas') {
    isDemoMahasiswaLogin = true;
    return true;
  }

  // AKUN DEMO PENDAMPING
  if (cleanEmail == 'pendamping@incluniv.test' &&
      password == 'Demo12345' &&
      role == 'Pendamping') {
    return true;
  }

  // AKUN HASIL REGISTRASI FRONTEND
  final valid =
      _email == cleanEmail &&
      _password == password &&
      _role == role;

  if (valid && role == 'Pendamping') {
    isNewPendampingLogin = true;
  }

  return valid;
}

}