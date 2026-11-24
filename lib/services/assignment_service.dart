
import '../core/api/api_client.dart';

class AssignmentService {
  /// Mengambil seluruh penugasan milik pendamping yang login.
  static Future<List<Map<String, dynamic>>> getMyAssignments() async {
    final response = await ApiClient.get('/api/assignments/my');

    final data = response['data'];

    if (data is! List) {
      throw ApiException(500, 'Format daftar penugasan tidak valid');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  /// Mengambil detail penugasan berdasarkan ID.
  static Future<Map<String, dynamic>> getAssignmentDetail(
    int id,
  ) async {
    final response = await ApiClient.get('/api/assignments/my/$id');

    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw ApiException(500, 'Format detail penugasan tidak valid');
    }

    return data;
  }
}

