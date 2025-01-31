import 'dart:convert';
import 'package:http/http.dart' as http;
import '../RoomLocation.dart';

class ClassroomService {
  static const String _baseUrl = 'http://localhost:5126';

  static Future<List<RoomLocation>> fetchClassrooms(
      {String keyword = '', int limit = 5}) async {
    try {
      final queryParameters = {
        'keyword': keyword,
        'limit': limit.toString(),
      };
      final uri = Uri.parse('$_baseUrl/api/classrooms')
          .replace(queryParameters: queryParameters);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => RoomLocation.fromJson(json)).toList();
      } else {
        print('Failed to load classrooms: ${response.statusCode}');
        throw Exception('Failed to load classrooms');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load classrooms');
    }
  }
}
