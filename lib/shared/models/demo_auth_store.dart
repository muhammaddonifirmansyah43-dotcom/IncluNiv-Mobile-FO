
class DemoAuthStore {
  DemoAuthStore._();

  static final DemoAuthStore instance = DemoAuthStore._();

  String? _nim;
  String? _password;
  String? _role;

  // Menentukan apakah Pendamping yang sedang login
  // merupakan akun baru hasil registrasi.
  bool isNewPendampingLogin = false;

  // Akun yang dibuat melalui Register.
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

    // Akun demo lama: dashboard berisi data.
    if (cleanNim == '2315407011111' &&
        password == 'Demo12345') {
      return true;
    }

    // Akun yang baru dibuat melalui Register.
    final valid = _nim == cleanNim &&
        _password == password &&
        _role == role;

    if (valid && role == 'Pendamping') {
      isNewPendampingLogin = true;
    }

    return valid;
  }
}
