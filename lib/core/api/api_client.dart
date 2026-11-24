
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'token_storage.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiClient {
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}$endpoint',
    );

    final token = requiresAuth
        ? await TokenStorage.getToken()
        : null;

    if (requiresAuth && token == null) {
      throw ApiException(
        401,
        'Silakan login terlebih dahulu',
      );
    }

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization': 'Bearer $token',
    };

    final request = http.Request(method, uri);
    request.headers.addAll(headers);

    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamedResponse =
        await _client.send(request).timeout(
              const Duration(seconds: 20),
            );

    final response =
        await http.Response.fromStream(streamedResponse);

    Map<String, dynamic> data;

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException();
      }
      data = decoded;
    } catch (_) {
      throw ApiException(
        response.statusCode,
        'Format respons server tidak valid',
      );
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw ApiException(
        response.statusCode,
        data['message']?.toString() ??
            'Terjadi kesalahan',
      );
    }

    return data;
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = true,
  }) {
    return request(
      'GET',
      endpoint,
      requiresAuth: requiresAuth,
    );
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) {
    return request(
      'POST',
      endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  static Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    return request(
      'PATCH',
      endpoint,
      body: body,
    );
  }

  static Future<Map<String, dynamic>> delete(
    String endpoint,
  ) {
    return request('DELETE', endpoint);
  }
}