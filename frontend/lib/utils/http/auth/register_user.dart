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

Future<Map<String, dynamic>> registerUser(
  String email,
  String phoneNumber,
  String password,
  String firstName,
  String lastName,
  BuildContext context,
) async {
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

    response = await dio.post(
      '/auth/register',
      data: {
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        "first_name": firstName,
        "last_name": lastName,
      },
    );
    // Web will automatically include cookies from the browser

    return _handleResponse(response, context);
  } on DioError catch (e) {
    return _handleDioError(context, e);
  }
}

Map<String, dynamic> _handleResponse(Response response, BuildContext context) {
  final data = response.data;
  final t = AppLocalizations.of(context)!;

  if (response.statusCode == 200 || response.statusCode == 201) {
    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    if (kIsWeb) {
      // On web: Only store access token if needed (refresh token should be in httpOnly cookie)
      _secureStorage.write(key: 'accessToken', value: accessToken);
      // Don't store refresh token on web!
    } else {
      // On mobile: Store both tokens securely
      _secureStorage.write(key: 'accessToken', value: accessToken);
      _secureStorage.write(key: 'refreshToken', value: refreshToken);
    }
    return data;
  } else if (response.statusCode == 400) {
    final message = data['message'] ?? 'Invalid request';
    throw Exception(message);
  } else if (response.statusCode == 409) {
    String message = data['message'].toLowerCase().trim() ?? '';

    if (message.contains("email")) {
      throw Exception(t.emailAlreadyExists);
    }
    if (message.contains("phone")) {
      throw Exception(t.phoneNumberAlreadyExists);
    }

    throw Exception(data['message'] ?? 'Registration failed');
  } else {
    print(data["message"]);
    throw Exception(
      'Failed to register: ${response.statusCode}, ${data["message"]}',
    );
  }
}

Map<String, dynamic> _handleDioError(BuildContext context, DioError e) {
  final t = AppLocalizations.of(context)!;

  if (e.response != null) {
    final data = e.response!.data;
    final statusCode = e.response!.statusCode;

    if (statusCode == 400) {
      final message = data['message'] ?? 'Invalid request';
      throw Exception(message);
    } else if (statusCode == 409) {
      String message = data['message'].toLowerCase().trim() ?? '';

      if (message.contains("email")) {
        throw Exception(t.emailAlreadyExists);
      }
      if (message.contains("phone")) {
        throw Exception(t.phoneNumberAlreadyExists);
      }
      throw Exception(data['message'] ?? 'Registration failed');
    } else {
      final message = data["message"];
      throw Exception('Failed to register: $statusCode, $message');
    }
  } else {
    throw Exception('Network error: ${e.message}');
  }
}
