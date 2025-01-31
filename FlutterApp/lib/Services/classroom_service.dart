import 'dart:convert';
import 'package:http/http.dart' as http;
import '../RoomLocation.dart';

class ClassroomService {
  static const String _baseUrl = 'http://localhost:5126';

  Future<List<RoomLocation>> fetchClassrooms() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/classrooms'));

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
