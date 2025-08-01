import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _baseUrl = 'http://localhost:3000';
final _secureStorage = const FlutterSecureStorage();

Future<Map<String, dynamic>> getAccessToken(String endpoint) async {
  final http.Response response;
  if (kIsWeb) {
    response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      //assuming web will automatically include refreshToken in cookies
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    return _handleResponse(response);
  } else {
    final refreshToken = await _secureStorage.read(key: "refreshToken");

    response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),

      headers: {
        'Authorization': 'Bearer $refreshToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return _handleResponse(response);
  }
}

Map<String, dynamic> _handleResponse(http.Response response) {
  final data = json.decode(response.body);

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
