import 'package:dio/dio.dart';
import '../services/letter_format_services.dart';
import '../models/letter_format.dart';

class LetterController {
  final dio = Dio(BaseOptions(baseUrl: "http://127.0.0.1:8000/api"));

  Future<Response> createLetter(Map<String, dynamic> data) async {
    return await dio.post('/api/letters', data: data);
  }

  Future<List<LetterFormat>> fetchLetterFormats() async {
    return await LetterFormatService.fetchLetterFormats();
  }

  Future<LetterFormat> createLetterFormat(Map<String, dynamic> data) async {
    return await LetterFormatService.createLetterFormat(data);
  }

  Future<LetterFormat> updateLetterFormat(int id, Map<String, dynamic> data) async {
    return await LetterFormatService.updateLetterFormat(id, data);
  }

  Future<void> deleteLetterFormat(int id) async {
    return await LetterFormatService.deleteLetterFormat(id);
  }

  String pdfUrl(int id) {
    return "http://127.0.0.1:8000/api/letters/$id/pdf";
  }
}
