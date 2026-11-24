
import '../core/api/api_client.dart';
import '../core/api/token_storage.dart';

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String expectedRole,
  }) async {
    final response = await ApiClient.post(
      '/api/auth/login',
      {
        'email': email.trim(),
        'password': password,
      },
      requiresAuth: false,
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('Data login tidak valid');
    }

    final token = data['token'];
    final user = data['user'];

    if (token is! String ||
        token.isEmpty ||
        user is! Map<String, dynamic>) {
      throw Exception('Respons login tidak lengkap');
    }

    final role = user['role'];

    // Hanya role mobile yang diperbolehkan
    if (role != 'STUDENT' && role != 'MENTOR') {
      throw Exception(
        'Akun ini tidak memiliki akses ke aplikasi mobile',
      );
    }

    // Pastikan sesuai tombol login yang dipilih
    if (role != expectedRole) {
      throw Exception(
        'Akun tidak sesuai dengan jenis pengguna yang dipilih',
      );
    }

    // Token hanya disimpan setelah seluruh validasi berhasil
    await TokenStorage.saveToken(token);

    return user;
  }

  static Future<void> logout() async {
    await TokenStorage.clearToken();
  }
}
