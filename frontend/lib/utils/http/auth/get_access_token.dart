import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio/browser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _baseUrl = 'http://localhost:3000';
final _secureStorage = const FlutterSecureStorage();

Future<Map<String, dynamic>> getAccessToken(String endpoint) async {
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

    late Response response;
    if (kIsWeb) {
      response = await dio.get('/$endpoint');
      //assuming web will automatically include refreshToken in cookies
    } else {
      final refreshToken = await _secureStorage.read(key: "refreshToken");

      response = await dio.get(
        '/$endpoint',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
    }
    return _handleResponse(response);
  } on DioException catch (e) {
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

Map<String, dynamic> _handleDioError(DioException e) {
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
