import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/letter_format.dart';

class LetterFormatService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // GET all templates
  static Future<List<LetterFormat>> fetchLetterFormats() async {
    try {
      final url = Uri.parse("$baseUrl/letter-formats");
      print('Fetching from: $url'); // Debug
      
      final response = await http.get(url);
      print('Status Code: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        
        // Cek apakah response memiliki key 'data'
        if (body is Map && body.containsKey('data')) {
          final List data = body['data'];
          return data.map((e) => LetterFormat.fromJson(e)).toList();
        }
        
        // Jika response langsung array
        if (body is List) {
          return body.map((e) => LetterFormat.fromJson(e)).toList();
        }
        
        return [];
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }

  // POST create template
  static Future<LetterFormat> createLetterFormat(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse("$baseUrl/letter-formats");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Create Status: ${response.statusCode}');
      print('Create Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = jsonDecode(response.body);
        
        if (body is Map && body.containsKey('data')) {
          return LetterFormat.fromJson(body['data']);
        }
        
        return LetterFormat.fromJson(body);
      } else {
        throw Exception("Failed to create template: ${response.statusCode}");
      }
    } catch (e) {
      print('Create Exception: $e');
      rethrow;
    }
  }

  // PUT update template
  static Future<LetterFormat> updateLetterFormat(int id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse("$baseUrl/letter-formats/$id");
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Update Status: ${response.statusCode}');
      print('Update Response: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        
        if (body is Map && body.containsKey('data')) {
          return LetterFormat.fromJson(body['data']);
        }
        
        return LetterFormat.fromJson(body);
      } else {
        throw Exception("Failed to update template: ${response.statusCode}");
      }
    } catch (e) {
      print('Update Exception: $e');
      rethrow;
    }
  }

  // DELETE template
  static Future<void> deleteLetterFormat(int id) async {
    try {
      final url = Uri.parse("$baseUrl/letter-formats/$id");
      final response = await http.delete(url);

      print('Delete Status: ${response.statusCode}');
      print('Delete Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete template: ${response.statusCode}");
      }
    } catch (e) {
      print('Delete Exception: $e');
      rethrow;
    }
  }
}
