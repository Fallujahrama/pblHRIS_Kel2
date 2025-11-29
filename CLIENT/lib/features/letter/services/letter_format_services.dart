import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/letter_format.dart';

class LetterFormatService {
  static const String baseUrl = "https://d2b93066964c.ngrok-free.app/api";

  // GET all templates
  static Future<List<LetterFormat>> fetchLetterFormats() async {
    final url = Uri.parse("$baseUrl/letter-formats");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((e) => LetterFormat.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  // POST create template
  static Future<LetterFormat> createLetterFormat(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/letter-formats");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return LetterFormat.fromJson(body['data']);
    } else {
      throw Exception("Failed to create template");
    }
  }

  // PUT update template
  static Future<LetterFormat> updateLetterFormat(int id, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/letter-formats/$id");
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return LetterFormat.fromJson(body['data']);
    } else {
      throw Exception("Failed to update template");
    }
  }

  // DELETE template
  static Future<void> deleteLetterFormat(int id) async {
    final url = Uri.parse("$baseUrl/letter-formats/$id");
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to delete template");
    }
  }
}
