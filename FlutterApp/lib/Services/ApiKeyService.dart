import 'dart:convert';

class ApiKeyService {
  static Map<String, dynamic>? validateApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty || !apiKey.contains('.')) return null;

    List<String> parts = apiKey.split('.');
    if (parts.length != 2) return null;

    String payloadBase64 = parts[0];

    // Decode Base64 (URL-safe)
    String payloadJson;
    try {
      payloadJson =
          utf8.decode(base64Url.decode(base64Url.normalize(payloadBase64)));
    } catch (e) {
      return null; // Invalid Base64 encoding
    }

    // Parse JSON
    Map<String, dynamic> tokenData;
    try {
      tokenData = jsonDecode(payloadJson);
    } catch (e) {
      return null; // Invalid JSON
    }

    // Verify expiration
    if (!tokenData.containsKey('exp')) return null;
    int expTime = tokenData['exp'];
    if (expTime < DateTime.now().millisecondsSinceEpoch ~/ 1000)
      return null; // Expired

    // Extract name and email
    if (!tokenData.containsKey('sub')) return null;
    String email = tokenData['sub'];

    return {
      'sub': email,
      'exp': expTime,
    };
  }
}
