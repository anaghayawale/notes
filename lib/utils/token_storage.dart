import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _tokenKey = 'token';
  static const _storage = FlutterSecureStorage();

  static Future<String?> retrieveToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      ('Error retrieving token: $e');
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      ('Error saving token: $e');
    }
  }

  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      ('Error deleting token: $e');
    }
  }
}
