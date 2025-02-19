import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyStorageService {
  static final storage = FlutterSecureStorage();

  static const apiTokenKey = 'classroom_finder_api_token';

  // Save API token
  static Future<void> saveApiToken(String token) async {
    await storage.write(key: apiTokenKey, value: token);
  }

  // Retrieve API token
  static Future<String?> getApiToken() async {
    return await storage.read(key: apiTokenKey);
  }

  // Delete API token
  static Future<void> deleteApiToken() async {
    await storage.delete(key: apiTokenKey);
  }
}
