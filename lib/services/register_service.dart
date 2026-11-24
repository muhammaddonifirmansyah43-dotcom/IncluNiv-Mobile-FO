
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../core/api/api_config.dart';
import 'package:http_parser/http_parser.dart';

class RegisterService {
  static Map<String, dynamic> _readResponse(
    http.Response response,
  ) {
    final Map<String, dynamic> body;

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException();
      }

      body = decoded;
    } catch (_) {
      throw Exception(
        'Respons server tidak valid (${response.statusCode})',
      );
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        body['success'] != true) {
      String message =
          body['message']?.toString() ??
          'Registrasi gagal';

      final errors = body['errors'];

      if (errors is Map) {
        final details = errors.values
            .whereType<List>()
            .expand((items) => items)
            .map((item) => item.toString())
            .toList();

        if (details.isNotEmpty) {
          message = details.join('\n');
        }
      }

      throw Exception(message);
    }

    return body;
  }

  // REGISTRASI PENDAMPING: JSON
  static Future<Map<String, dynamic>> registerMentor({
    required String fullName,
    required String studentCode,
    required String email,
    required String department,
    required String phoneNumber,
    required String skills,
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/auth/register/mentor',
    );

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'fullName': fullName.trim(),
            'studentCode': studentCode.trim(),
            'email': email.trim(),
            'department': department.trim(),
            'phoneNumber': phoneNumber.trim(),
            'skills': skills.trim(),
            'password': password,
            'confirmPassword': confirmPassword,
          }),
        )
        .timeout(const Duration(seconds: 30));

    return _readResponse(response);
  }

  // REGISTRASI MAHASISWA: MULTIPART + FOTO
  static Future<Map<String, dynamic>> registerStudent({
    required String fullName,
    required String studentCode,
    required String email,
    required String department,
    required String phoneNumber,
    required String disabilityType,
    required String supportNeeds,
    required String password,
    required String confirmPassword,
    required XFile photo,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/auth/register/student',
    );

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.fields.addAll({
      'fullName': fullName.trim(),
      'studentCode': studentCode.trim(),
      'email': email.trim(),
      'department': department.trim(),
      'phoneNumber': phoneNumber.trim(),
      'disabilityType': disabilityType.trim(),
      'supportNeeds': supportNeeds.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
    });

    final bytes = await photo.readAsBytes();

    if (bytes.length > 5 * 1024 * 1024) {
      throw Exception(
        'Ukuran foto maksimal 5 MB',
      );
    }

   
final extension = photo.name
    .split('.')
    .last
    .toLowerCase();

final String? mimeSubtype;

if (extension == 'jpg' || extension == 'jpeg') {
  mimeSubtype = 'jpeg';
} else if (extension == 'png') {
  mimeSubtype = 'png';
} else if (extension == 'webp') {
  mimeSubtype = 'webp';
} else {
  mimeSubtype = null;
}

if (mimeSubtype == null) {
  throw Exception(
    'Format foto harus JPG, PNG, atau WEBP',
  );
}

request.files.add(
  http.MultipartFile.fromBytes(
    'photo',
    bytes,
    filename: photo.name,
    contentType: MediaType(
      'image',
      mimeSubtype,
    ),
  ),
);


    final streamed = await request
        .send()
        .timeout(const Duration(seconds: 30));

    final response =
        await http.Response.fromStream(streamed);

    return _readResponse(response);
  }
}
