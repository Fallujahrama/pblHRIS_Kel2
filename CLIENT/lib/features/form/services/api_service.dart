import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiService {
  // Choose appropriate base URL depending on platform/environment.
  static String get baseURL {
    if (kIsWeb) return "http://127.0.0.1:8000/api";
    try {
      if (Platform.isAndroid) return "http://10.0.2.2:8000/api";
      if (Platform.isIOS) return "http://127.0.0.1:8000/api";
    } catch (_) {}
    return "http://127.0.0.1:8000/api";
  }

  static Future<Map<String, dynamic>> createSurat(Map data) async {
    try {
      print('Sending request to: $baseURL/letters');
      print('Request body: ${jsonEncode(data)}');

      final res = await http.post(
        Uri.parse("$baseURL/letters"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Create Letter Status: ${res.statusCode}');
      print('Create Letter Response: ${res.body}');

      return {
        'success': res.statusCode == 200 || res.statusCode == 201,
        'statusCode': res.statusCode,
        'body': res.body,
      };
    } catch (e) {
      print('Create Letter Exception: $e');
      return {
        'success': false,
        'statusCode': -1,
        'body': 'Exception: $e',
      };
    }
  }

  static Future<List> getSurat() async {
    try {
      final res = await http.get(Uri.parse("$baseURL/letters"));

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
    } catch (e) {
      print('Get Letters Exception: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateStatus(
      dynamic id, String status) async {
    try {
      print('Updating status for letter $id to $status');

      final res = await http.put(
        Uri.parse("$baseURL/letters/$id/status"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"status": status}),
      );

      print('Update Status: ${res.statusCode}');
      print('Update Response: ${res.body}');

      return {
        'success': res.statusCode == 200,
        'statusCode': res.statusCode,
        'body': res.body,
      };
    } catch (e) {
      print('Update Status Exception: $e');
      return {
        'success': false,
        'statusCode': -1,
        'body': 'Exception: $e',
      };
    }
  }

  static Future<Uint8List?> downloadPdf(dynamic id) async {
    try {
      print('Downloading PDF for letter $id');

      final res = await http.get(
        Uri.parse("$baseURL/letters/$id/download"),
      );

      if (res.statusCode == 200) {
        print('PDF download successful');
        return res.bodyBytes;
      } else {
        print('PDF download failed: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      print('Download PDF Exception: $e');
      return null;
    }
  }
}
