import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyStorageService {
  static final _storage = FlutterSecureStorage();

  static const _apiTokenKey = 'classroom_finder_api_token';

  // Save API token
  static Future<void> saveApiToken(String token) async {
    await _storage.write(key: _apiTokenKey, value: token);
  }

  // Retrieve API token
  static Future<String?> getApiToken() async {
    return await _storage.read(key: _apiTokenKey);
  }

  // Delete API token
  static Future<void> deleteApiToken() async {
    await _storage.delete(key: _apiTokenKey);
  }
}
