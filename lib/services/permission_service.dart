
import '../core/api/api_client.dart';

class PermissionService {
  // Mengajukan izin pendamping.
  static Future<Map<String, dynamic>> createPermission({
    required String reason,
    required DateTime startAt,
    required DateTime endAt,
    int? assignmentId,
  }) async {
    final body = <String, dynamic>{
      'reason': reason.trim(),
      'startAt': startAt.toUtc().toIso8601String(),
      'endAt': endAt.toUtc().toIso8601String(),
    };

    if (assignmentId != null) {
      body['assignmentId'] = assignmentId;
    }

    final response = await ApiClient.post(
      '/api/permissions',
      body,
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw ApiException(
        500,
        'Format respons pengajuan izin tidak valid',
      );
    }

    return data;
  }
}
