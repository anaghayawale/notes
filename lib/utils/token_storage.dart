import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const storage = FlutterSecureStorage();

  static Future<String?> retrieveToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  static Future<void> deleteToken(String token) async {
    await storage.delete(key: 'token');
  }
}
