import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseURL = "http://10.0.2.2:8000/api";

  static Future<bool> createSurat(Map data) async {
    final res = await http.post(Uri.parse("$baseURL/surat"), body: data);
    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<List> getSurat() async {
    final res = await http.get(Uri.parse("$baseURL/surat"));

    if (res.statusCode == 200) {
      final decode = jsonDecode(res.body);

      if (decode is Map && decode.containsKey('data')) {
        return decode['data'];
      }

      if (decode is List) {
        return decode;
      }
    }
    return [];
  }

  static Future<bool> updateStatus(dynamic id, String status) async {
    final res = await http.put(
      Uri.parse("$baseURL/surat/$id"),
      body: {"status": status},
    );
    return res.statusCode == 200;
  }
}
