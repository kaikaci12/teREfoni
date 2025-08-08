import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/io.dart';
import 'package:dio/browser.dart';

class THttpHelper {
  // Use different base URLs for web vs mobile
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // For web development
    } else {
      return 'http://10.0.2.2:3000'; // For Android emulator
    }
  }

  static Dio? _dio;

  static Dio get dio {
    _dio ??= _initializeDio();
    return _dio!;
  }

  static Dio _initializeDio() {
    final dioInstance = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        contentType: 'application/json',
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    // Enable sending cookies automatically on web
    if (kIsWeb) {
      (dioInstance.httpClientAdapter as BrowserHttpClientAdapter)
              .withCredentials =
          true;
    }

    // Add interceptors for better error handling
    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          print('Dio Error: ${e.message}');
          print('Dio Error Type: ${e.type}');
          print('Dio Error URL: ${e.requestOptions.uri}');
          if (e.response != null) {
            print('Dio Error Status: ${e.response!.statusCode}');
            print('Dio Error Data: ${e.response!.data}');
          }
          handler.next(e);
        },
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          print('Dio Request: ${options.method} ${options.path}');
          print('Dio Request URL: ${options.uri}');
          handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          print('Dio Response: ${response.statusCode}');
          handler.next(response);
        },
      ),
    );

    return dioInstance;
  }

  // Test method to check if the server is reachable
  static Future<bool> testConnection() async {
    try {
      print('Testing connection to: $_baseUrl');
      final response = await dio.get(
        '/api/auth/test',
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('Connection test successful: ${response.statusCode}');
      return true;
    } on DioException catch (e) {
      print('Connection test failed: ${e.message}');
      print('Error type: ${e.type}');
      return false;
    }
  }

  // Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await dio.get('/$endpoint');
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic data,
  ) async {
    try {
      final response = await dio.post('/$endpoint', data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    try {
      final response = await dio.put('/$endpoint', data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Helper method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await dio.delete('/$endpoint');
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Handle the HTTP response
  static Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // Handle Dio errors
  static Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      throw Exception('Failed to load data: ${e.response!.statusCode}');
    } else {
      // Provide more specific error messages based on error type
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception(
            'Connection timeout. Please check your internet connection.',
          );
        case DioExceptionType.sendTimeout:
          throw Exception('Request timeout. Please try again.');
        case DioExceptionType.receiveTimeout:
          throw Exception('Response timeout. Please try again.');
        case DioExceptionType.badResponse:
          throw Exception('Server error: ${e.response?.statusCode}');
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled.');
        case DioExceptionType.connectionError:
          throw Exception(
            'Connection error. Please check if the server is running on $_baseUrl',
          );
        case DioExceptionType.unknown:
        default:
          throw Exception('Network error: ${e.message}');
      }
    }
  }
}
