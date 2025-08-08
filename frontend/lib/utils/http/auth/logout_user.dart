import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/utils/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:dio/browser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

const String _baseUrl = kIsWeb
    ? 'http://localhost:3000'
    : 'http://10.0.2.2:3000';

final _secureStorage = FlutterSecureStorage();

Future<Map<String, dynamic>> logoutUser(
  BuildContext context,
  String endpoint,
) async {
  try {
    late Response response;
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

    if (kIsWeb) {
      // On web: rely on httpOnly cookies for authentication
      debugPrint('Web logout: Using httpOnly cookies for authentication');
      response = await dio.delete('/$endpoint');
    } else {
      // On mobile: use refresh token from secure storage
      final refreshToken = await _secureStorage.read(key: "refreshToken");
      debugPrint(
        'Mobile logout: Refresh token found: ${refreshToken != null ? 'Yes' : 'No'}',
      );

      if (refreshToken == null) {
        // If no refresh token, just clear local storage and mark as logged out
        debugPrint('No refresh token found, clearing local storage');
        await _secureStorage.delete(key: "accessToken");
        await _secureStorage.delete(key: "refreshToken");
        Provider.of<AuthProvider>(
          context,
          listen: false,
        ).setAuthenticated(false);
        return {"message": "Logged out successfully (no token found)"};
      }

      response = await dio.delete(
        '/$endpoint',
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
    }

    return _handleResponse(context, response);
  } on DioException catch (e) {
    debugPrint('Logout DioException: ${e.message}');
    debugPrint('Logout DioException Type: ${e.type}');
    if (e.response != null) {
      debugPrint('Logout Response Status: ${e.response!.statusCode}');
      debugPrint('Logout Response Data: ${e.response!.data}');
    }
    return _handleDioError(context, e);
  } catch (error) {
    debugPrint("Logout error: $error");
    rethrow;
  }
}

Map<String, dynamic> _handleResponse(BuildContext context, Response response) {
  final data = response.data;
  debugPrint('Logout response status: ${response.statusCode}');
  debugPrint('Logout response data: $data');

  if (response.statusCode == 200 || response.statusCode == 204) {
    if (kIsWeb) {
      // On web, delete access token from local storage if stored manually
      _secureStorage.delete(key: "accessToken");
    } else {
      _secureStorage.delete(key: "accessToken");
      _secureStorage.delete(key: "refreshToken");
    }

    // ✅ Mark user as logged out
    Provider.of<AuthProvider>(context, listen: false).setAuthenticated(false);

    return {"message": data["message"] ?? "Logout successful"};
  } else {
    final String message = data["message"] ?? "Unknown error";
    throw Exception('$message, ${response.statusCode}');
  }
}

Map<String, dynamic> _handleDioError(BuildContext context, DioException e) {
  if (e.response != null) {
    final data = e.response!.data;
    final statusCode = e.response!.statusCode;

    // Handle unauthorized token error
    if (statusCode == 401) {
      debugPrint('Unauthorized token error, clearing local storage');
      // Clear tokens and mark as logged out even if server rejects the token
      if (kIsWeb) {
        _secureStorage.delete(key: "accessToken");
      } else {
        _secureStorage.delete(key: "accessToken");
        _secureStorage.delete(key: "refreshToken");
      }
      Provider.of<AuthProvider>(context, listen: false).setAuthenticated(false);
      return {"message": "Logged out successfully (token was invalid)"};
    }

    if (statusCode == 200 || statusCode == 204) {
      if (kIsWeb) {
        // On web, delete access token from local storage if stored manually
        _secureStorage.delete(key: "accessToken");
      } else {
        _secureStorage.delete(key: "accessToken");
        _secureStorage.delete(key: "refreshToken");
      }

      // ✅ Mark user as logged out
      Provider.of<AuthProvider>(context, listen: false).setAuthenticated(false);

      return {"message": data["message"] ?? "Logout successful"};
    } else {
      final String message = data["message"] ?? "Unknown error";
      throw Exception('$message, $statusCode');
    }
  } else {
    throw Exception('Network error: ${e.message}');
  }
}
