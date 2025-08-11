import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:frontend/l10n/app_localizations.dart';

// Use platform-specific base URLs
const String _baseUrl = kIsWeb
    ? 'http://localhost:3000' // Web uses localhost
    : 'http://10.0.2.2:3000'; // Android emulator uses 10.0.2.2 to access host machine
final _secureStorage = const FlutterSecureStorage();

Future<Map<String, dynamic>> loginUser(
  String email,
  String phoneNumber,
  String password,
  BuildContext context,
) async {
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
    '/auth/login',
    data: {'email': email, 'phone_number': phoneNumber, 'password': password},
  );
  // Web will automatically include cookies from the browser

  return _handleResponse(response, context);
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
  } else if (response.statusCode == 404 || response.statusCode == 401) {
    String message = data['message'].toLowerCase().trim() ?? '';

    if (message.contains("password")) {
      throw Exception(t.incorrectPassword);
    }
    if (message.contains("user")) {
      throw Exception(t.userNotFound);
    }
    throw Exception(data['message'] ?? 'Login failed');
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}
