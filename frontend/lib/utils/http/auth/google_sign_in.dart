import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String _baseUrl = kIsWeb
    ? 'http://localhost:3000'
    : 'http://10.0.2.2:3000'; // Adjust your backend URL

final Dio _dio = Dio();
final _secureStorage = const FlutterSecureStorage();

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['openid', 'email', 'profile'],
  clientId: kIsWeb
      ? '245752988939-4uponjjnjovupv66iqd66o4otanujg05.apps.googleusercontent.com'
      : null,
  serverClientId: !kIsWeb
      ? (defaultTargetPlatform == TargetPlatform.android
            ? 'Androidcleint id'
            : (defaultTargetPlatform == TargetPlatform.iOS
                  ? 'YOUR_IOS_SERVER_CLIENT_ID.apps.googleusercontent.com'
                  : null))
      : null,
);

Future<Map<String, dynamic>?> googleSignInFlow() async {
  try {
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) {
      throw Exception("Sign in canceled by user");
    }

    final GoogleSignInAuthentication auth = await account.authentication;
    final String? idToken = auth.idToken;
    if (idToken == null) {
      throw Exception("Failed to get ID token");
    }

    final data = await _sendIdTokenToBackend(idToken);
    if (data == null ||
        !data.containsKey('accessToken') ||
        (!kIsWeb && !data.containsKey('refreshToken'))) {
      throw Exception("Backend response missing tokens");
    }

    // Store tokens securely on all platforms
    await _secureStorage.write(key: 'accessToken', value: data['accessToken']);
    if (!kIsWeb && data.containsKey('refreshToken')) {
      await _secureStorage.write(
        key: 'refreshToken',
        value: data['refreshToken'],
      );
    }

    return {'message': 'Sign-in successful!', 'data': data};
  } catch (e) {
    debugPrint(e.toString());
    throw Exception(e);
  }
}

Future<Map<String, dynamic>?> _sendIdTokenToBackend(String idToken) async {
  try {
    final response = await _dio.post(
      '$_baseUrl/api/auth/google',
      data: {'idToken': idToken},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {}
  } catch (e) {
    debugPrint(e.toString());
    throw Exception(e);
    // Optionally log error
  }
  return null;
}
