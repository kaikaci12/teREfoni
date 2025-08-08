import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/utils/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:dio/browser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

const String _baseUrl = kIsWeb
    ? 'http://localhost:3000'
    : "http://10.0.2.2:3000";
final _secureStorage = const FlutterSecureStorage();

Future<Map<String, dynamic>> loginUser(
  BuildContext context,
  String endpoint,
  dynamic data,
) async {
  try {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        contentType: 'application/json; charset=UTF-8',
      ),
    );

    // Enable sending cookies automatically on web
    if (kIsWeb) {
      (dio.httpClientAdapter as BrowserHttpClientAdapter).withCredentials =
          true;
    }

    final response = await dio.post('/$endpoint', data: data);
    return _handleResponse(context, response);
  } on DioException catch (e) {
    return _handleDioError(context, e);
  }
}

Map<String, dynamic> _handleResponse(BuildContext context, Response response) {
  final data = response.data;

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
    Provider.of<AuthProvider>(context, listen: false).setAuthenticated(true);
    return data;
  } else if (response.statusCode == 400) {
    throw Exception('Invalid request: ${data['message']}');
  } else if (response.statusCode == 404 || response.statusCode == 401) {
    String message = data['message'].toString().toLowerCase().trim();
    final t = AppLocalizations.of(context)!;
    if (message.contains("password")) {
      throw Exception(t.incorrectPassword);
    }
    if (message.contains("user")) {
      throw Exception(t.userNotFound);
    }
    throw Exception(data['message']);
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Map<String, dynamic> _handleDioError(BuildContext context, DioException e) {
  if (e.response != null) {
    final data = e.response!.data;
    final statusCode = e.response!.statusCode;

    if (statusCode == 400) {
      throw Exception('Invalid request: ${data['message']}');
    } else if (statusCode == 404 || statusCode == 401) {
      String message = data['message'].toString().toLowerCase().trim();
      final t = AppLocalizations.of(context)!;
      if (message.contains("password")) {
        throw Exception(t.incorrectPassword);
      }
      if (message.contains("user")) {
        throw Exception(t.userNotFound);
      }
      throw Exception(data['message']);
    } else {
      throw Exception('Failed to load data: $statusCode');
    }
  } else {
    throw Exception('Network error: ${e.message}');
  }
}
