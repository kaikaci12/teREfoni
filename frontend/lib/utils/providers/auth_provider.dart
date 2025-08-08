import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/http/auth/get_access_token.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  bool _isLoading = true;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  AuthProvider() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;

    final token = await _storage.read(key: 'accessToken');
    debugPrint("token: $token");
    if (token != null && !JwtDecoder.isExpired(token)) {
      _isAuthenticated = true;
    } else {
      try {
        final response = await getAccessToken("api/auth/refresh");
        debugPrint(response["message"]);
        _isAuthenticated = true;
      } catch (e) {
        debugPrint(e.toString());
        _isAuthenticated = false;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
}
