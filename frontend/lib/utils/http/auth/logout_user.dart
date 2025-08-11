import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/l10n/app_localizations.dart';

// Use platform-specific base URLs
const String _baseUrl = kIsWeb
    ? 'http://localhost:3000' // Web uses localhost
    : 'http://10.0.2.2:3000'; // Android emulator uses 10.0.2.2 to access host machine
final _secureStorage = const FlutterSecureStorage();

Future<Map<String, dynamic>> logoutUser(BuildContext context) async {
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
      response = await dio.post('/auth/logout');
      // Web will automatically include cookies from the browser
    } else {
      response = await dio.post('/auth/logout');
    }

    return _handleResponse(response, context);
  } on DioError catch (e) {
    return _handleDioError(context, e);
  }
}

Map<String, dynamic> _handleResponse(Response response, BuildContext context) {
  final data = response.data;

  if (response.statusCode == 200 || response.statusCode == 201) {
    // Clear stored tokens
    _secureStorage.delete(key: 'accessToken');
    _secureStorage.delete(key: 'refreshToken');

    return data;
  } else if (response.statusCode == 400) {
    final message = data['message']?.toString() ?? 'Invalid request';
    throw Exception(message);
  } else if (response.statusCode == 401) {
    throw Exception('Unauthorized');
  } else {
    throw Exception('Failed to logout: ${response.statusCode}');
  }
}

Map<String, dynamic> _handleDioError(BuildContext context, DioError e) {
  if (e.response != null) {
    final data = e.response!.data;
    final statusCode = e.response!.statusCode;

    if (statusCode == 400) {
      final message = data['message']?.toString() ?? 'Invalid request';
      throw Exception(message);
    } else if (statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to logout: $statusCode');
    }
  } else {
    throw Exception('Network error: ${e.message}');
  }
}
