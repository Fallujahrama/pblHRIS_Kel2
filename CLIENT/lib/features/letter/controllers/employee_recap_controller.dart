import 'package:flutter/material.dart';
import '../models/employee_recap.dart';
import '../services/employee_recap_service.dart';

class EmployeeRecapController extends ChangeNotifier {
  List<EmployeeRecap> employees = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchEmployeeRecap() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      employees = await EmployeeRecapService.fetchEmployeeRecap();
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
