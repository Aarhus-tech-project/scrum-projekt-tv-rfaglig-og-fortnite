import 'dart:convert';

class Apikeyservice {
  static bool validateApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty || !apiKey.contains('.')) return false;

    List<String> parts = apiKey.split('.');
    if (parts.length != 2) return false;

    String payloadBase64 = parts[0];

    // Decode Base64 (URL-safe)
    String payloadJson;
    try {
      payloadJson =
          utf8.decode(base64Url.decode(base64Url.normalize(payloadBase64)));
    } catch (e) {
      return false; // Invalid Base64 encoding
    }

    // Parse JSON
    Map<String, dynamic> tokenData;
    try {
      tokenData = jsonDecode(payloadJson);
    } catch (e) {
      return false; // Invalid JSON
    }

    // Verify expiration
    if (!tokenData.containsKey('exp')) return false;
    int expTime = tokenData['exp'];
    if (expTime < DateTime.now().millisecondsSinceEpoch ~/ 1000)
      return false; // Expired

    return true; // API key is valid
  }
}
