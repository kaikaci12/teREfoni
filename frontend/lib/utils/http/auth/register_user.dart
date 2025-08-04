import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _baseUrl = kIsWeb
    ? 'http://localhost:3000'
    : "http://10.0.2.2:3000";
final _secureStorage = const FlutterSecureStorage();

Future<Map<String, dynamic>> registerUser(String endpoint, dynamic data) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/$endpoint'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: json.encode(data),
  );
  return _handleResponse(response);
}

Map<String, dynamic> _handleResponse(http.Response response) {
  final data = json.decode(response.body);

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
    throw Exception('Invalid request: ${data['message']}');
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}
