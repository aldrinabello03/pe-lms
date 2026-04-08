import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _consentKey = 'consent_agreed';

  final FlutterSecureStorage _storage;

  StorageService() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveUserData(String jsonStr) async {
    await _storage.write(key: _userKey, value: jsonStr);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }

  Future<void> deleteUserData() async {
    await _storage.delete(key: _userKey);
  }

  Future<void> setConsentAgreed(bool agreed) async {
    await _storage.write(key: _consentKey, value: agreed.toString());
  }

  Future<bool> hasConsentAgreed() async {
    final val = await _storage.read(key: _consentKey);
    return val == 'true';
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
