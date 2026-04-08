import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import 'storage_service.dart';

class AuthService {
  final Dio _dio;
  final StorageService _storage;

  AuthService(this._dio, this._storage);

  Future<AuthResponse> login({
    required String userName,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConfig.login,
      data: {'userName': userName, 'password': password},
    );
    final authResponse = AuthResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    await _storage.saveToken(authResponse.token);
    await _storage.saveUserData(jsonEncode(authResponse.user.toJson()));
    return authResponse;
  }

  Future<void> register({
    required String userName,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    await _dio.post(
      ApiConfig.register,
      data: {
        'userName': userName,
        'password': password,
        'confirmPassword': confirmPassword,
        'role': role,
      },
    );
  }

  Future<User?> getStoredUser() async {
    final jsonStr = await _storage.getUserData();
    if (jsonStr == null) return null;
    try {
      return User.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getStoredToken() async {
    return await _storage.getToken();
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }
}
