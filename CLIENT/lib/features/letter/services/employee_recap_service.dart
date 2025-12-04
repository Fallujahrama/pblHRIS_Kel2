import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/employee_recap.dart';

class EmployeeRecapService {
  static Future<List<EmployeeRecap>> fetchEmployeeRecap() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/employee-recap'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'];
      return list.map((e) => EmployeeRecap.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employee recap');
    }
  }
}
