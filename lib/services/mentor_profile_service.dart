
import '../core/api/api_client.dart';

class MentorProfileService {
  // SESUAIKAN DENGAN ROUTE BACKEND YANG SUDAH ADA.
  // Contoh ini menggunakan /api/mentors/me.
  static const String profileEndpoint = '/api/mentors/me';

  static Future<Map<String, dynamic>> getMyProfile() async {
    final response = await ApiClient.get(
      profileEndpoint,
    );

    // Backend mungkin membungkus profil dalam data
    // atau data.mentor / data.profile.
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('Data profil tidak valid');
    }

    final nested = data['mentor'] ?? data['profile'];

    if (nested is Map<String, dynamic>) {
      return nested;
    }

    return data;
  }
}
