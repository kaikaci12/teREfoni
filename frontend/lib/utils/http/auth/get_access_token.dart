import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Use platform-specific base URLs
const String _baseUrl = kIsWeb
    ? 'http://localhost:3000' // Web uses localhost
    : 'http://10.0.2.2:3000'; // Android emulator uses 10.0.2.2 to access host machine
final _secureStorage = const FlutterSecureStorage();

Future<Map<String, dynamic>> getAccessToken(String endpoint) async {
  try {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        contentType: 'application/json; charset=UTF-8',
      ),
    );

    // For web, we'll handle cookies differently
    // Dio 4.x doesn't have BrowserHttpClientAdapter, so we use standard approach
    late Response response;
    if (kIsWeb) {
      response = await dio.get('/$endpoint');
      // Web will automatically include cookies from the browser
    } else {
      final refreshToken = await _secureStorage.read(key: "refreshToken");

      response = await dio.get(
        '/$endpoint',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
    }
    return _handleResponse(response);
  } on DioError catch (e) {
    return _handleDioError(e);
  }
}

Map<String, dynamic> _handleResponse(Response response) {
  final data = response.data;

  if (response.statusCode == 200 || response.statusCode == 201) {
    final accessToken = data['accessToken'];

    if (accessToken != null) {
      _secureStorage.write(key: 'accessToken', value: accessToken);
    }
    return data;
  } else if (response.statusCode == 401) {
    throw Exception('${data["message"]}');
  } else {
    throw Exception('Something went wrong: ${response.statusCode}');
  }
}

Map<String, dynamic> _handleDioError(DioError e) {
  if (e.response != null) {
    final data = e.response!.data;
    final statusCode = e.response!.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      final accessToken = data['accessToken'];

      if (accessToken != null) {
        _secureStorage.write(key: 'accessToken', value: accessToken);
      }
      return data;
    } else if (statusCode == 401) {
      throw Exception('${data["message"]}');
    } else {
      throw Exception('Something went wrong: $statusCode');
    }
  } else {
    throw Exception('Network error: ${e.message}');
  }
}
