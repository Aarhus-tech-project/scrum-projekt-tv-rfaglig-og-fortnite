import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:classroom_finder_app/Models/AddEditSiteDTO.dart';
import 'package:classroom_finder_app/Models/Room.dart';
import 'package:classroom_finder_app/Models/Site.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:classroom_finder_app/Services/ApiKeyStorageService.dart';

class ApiService {
  static VoidCallback? onLogout;

  static const String prodBaseUrl = 'https://.com/api';

  static final String baseUrl = getBaseUrl();

  static String? ApiKey;

  static void setLogoutHandler(VoidCallback logoutFunction) {
    onLogout = logoutFunction;
  }

  static String getBaseUrl() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5126/api'; // Android emulator
      } else if (Platform.isIOS) {
        return 'http://localhost:5126/api'; // iOS simulator
      }
    }

    return prodBaseUrl;
  }

  static Future<http.Response> sendRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    ApiKey ??= await ApiKeyStorageService.getApiToken();

    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Api-Key': ApiKey ?? '',
    };

    try {
      http.Response response;
      if (method == 'POST') {
        response =
            await http.post(url, headers: headers, body: jsonEncode(body));
      } else if (method == 'PUT') {
        response =
            await http.put(url, headers: headers, body: jsonEncode(body));
      } else if (method == 'GET') {
        response = await http.get(url, headers: headers);
      } else if (method == 'DELETE') {
        response = await http.delete(url, headers: headers);
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
      throw Exception(response.body);
    }
  }

  static Future<void> deleteUser() async {
    await sendRequest('auth/DeleteAccount',
        method: 'DELETE', requiresAuth: true);
  }

  /// Registers a new user
  static Future<void> register(
      String name, String email, String password) async {
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
  static Future<void> login(String email, String password) async {
    final response = await sendRequest(
      'auth/Login',
      method: 'POST',
      body: {
        'email': email,
        'password': password,
      },
    );

    ApiKey = response.body;
    await ApiKeyStorageService.saveApiToken(response.body);
  }

  /// Fetches classrooms with optional keyword and limit
  static Future<List<Room>> searchClassrooms(
      {String keyword = '', int limit = 5}) async {
    final response = await sendRequest(
      'searchclassrooms?keyword=$keyword&limit=$limit',
      requiresAuth: true,
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Room.fromJson(json)).toList();
  }

  static Future<List<Site>> getUserSites() async {
    final response = await sendRequest(
      'GetUserSites',
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Site.fromJson(json)).toList();
  }

  static Future AddSite(AddEditSiteDTO site) async {
    await sendRequest('Site', method: 'POST', body: site.toJson());
  }

  static Future EditSite(AddEditSiteDTO site) async {
    await sendRequest(
      'Site',
      method: 'PUT',
      body: site.toJson(),
    );
  }

  static Future DeleteSite(String siteID) async {
    await sendRequest(
      'Site?siteID=$siteID',
      method: 'DELETE',
    );
  }

  static Future<AddEditSiteDTO> GetEditSite(String siteID) async {
    final response = await sendRequest('GetEditSite?siteID=$siteID');
    final Map<String, dynamic> data = json.decode(response.body);
    return AddEditSiteDTO.fromJson(data);
  }

  static Future<List<Site>> getNearbySites(
      {double lat = 0, double lon = 0}) async {
    final response = await sendRequest(
      'GetNearbySites?lat=$lat&lon=$lon',
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Site.fromJson(json)).toList();
  }
}
