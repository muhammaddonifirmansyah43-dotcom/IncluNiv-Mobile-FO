
class DemoAuthStore {
  DemoAuthStore._();

  static final DemoAuthStore instance = DemoAuthStore._();

  String? _nim;
  String? _password;
  String? _role;

  // Penanda akun baru pendamping.
  bool isNewPendampingLogin = false;

  // Penanda akun Demo Mahasiswa.
  bool isDemoMahasiswaLogin = false;

  // Menyimpan akun hasil registrasi.
  void register({
    required String nim,
    required String password,
    required String role,
  }) {
    _nim = nim.trim();
    _password = password;
    _role = role;
  }

  // Memeriksa NIM, password, dan aktor.
  bool canLogin(
    String nim,
    String password,
    String role,
  ) {
    final cleanNim = nim.trim();

    // Reset status login sebelumnya.
    isNewPendampingLogin = false;
    isDemoMahasiswaLogin = false;

    // Akun Demo.
    if (cleanNim == '2315407011111' &&
        password == 'Demo12345') {
      // Tandai jika login sebagai mahasiswa.
      if (role == 'Mahasiswa') {
        isDemoMahasiswaLogin = true;
      }

      return true;
    }

    // Akun hasil registrasi.
    final valid = _nim == cleanNim &&
        _password == password &&
        _role == role;

    if (valid && role == 'Pendamping') {
      isNewPendampingLogin = true;
    }

    return valid;
  }
}
