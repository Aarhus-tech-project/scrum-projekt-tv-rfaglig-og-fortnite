import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:classroom_finder_app/Storage/StorageKey.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5126/api/auth';

  static Future<void> _postRequest(
      String endpoint, Map<String, String> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
        StorageKey.saveApiToken(response.body);
      } else {
        print('Failed to send data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to send data');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> register(
      String name, String email, String password) async {
    await _postRequest('Register', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  static Future<void> login(String email, String password) async {
    await _postRequest('Login', {
      'email': email,
      'password': password,
    });
  }
}
