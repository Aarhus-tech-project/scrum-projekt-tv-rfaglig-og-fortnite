import 'dart:convert';
import 'dart:io';
import 'package:classroom_finder_app/Models/Room.dart';
import 'package:http/http.dart' as http;
import 'package:classroom_finder_app/Services/ApiKeyStorageService.dart';

class ApiService {
  static const String prodBaseUrl = 'https://GAY_AZURE.com/api';
  
  // Detect platform and set base URL accordingly
  static final String baseUrl = getBaseUrl();

  static String ApiKey = "";

  static String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5126/api'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5126/api'; // iOS simulator
    } else {
      return prodBaseUrl; // Default to production
    }
  }

  /// Helper method for sending HTTP requests (GET, POST, etc.)
  static Future<http.Response> sendRequest(
      String endpoint, {
      String method = 'GET',
      Map<String, String>? body,
      bool requiresAuth = false,
    }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      http.Response response;
      if (method == 'POST') {
        response = await http.post(url, headers: headers, body: jsonEncode(body));
      } else if (method == 'GET') {
        response = await http.get(url, headers: headers);
      } else {
        throw Exception('Unsupported HTTP method: $method');
      }

      return handleResponse(response);
    } catch (e) {
      print('HTTP Error: $e');
      throw Exception('Request failed: $e');
    }
  }

  /// Handles HTTP responses and throws exceptions on failure
  static http.Response handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }

  /// Registers a new user
  static Future<void> register(String name, String email, String password) async {
    final response = await sendRequest(
      'auth/Register',
      method: 'POST',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  /// Logs in an existing user
  static Future<String> login(String email, String password) async {
    final response = await sendRequest(
      'auth/Login',
      method: 'POST',
      body: {
        'email': email,
        'password': password,
      },
    );

    return response.body;
  }

  /// Fetches classrooms with optional keyword and limit
  static Future<List<Room>> searchClassrooms({String keyword = '', int limit = 5}) async {
    final response = await sendRequest(
      'searchclassrooms?keyword=$keyword&limit=$limit',
      requiresAuth: true,
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Room.fromJson(json)).toList();
  }
}
