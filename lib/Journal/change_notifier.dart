import 'package:flutter/foundation.dart';

// ChangeNotifier adds listening capabilities
class JournalChangeNotifier with ChangeNotifier {
  String? _selectedAttribute1;

  String? get selectedAttribute1 => _selectedAttribute1; // set default value

  set selectedAttribute1(String? newValue) {
    _selectedAttribute1 = newValue;
    notifyListeners();
  }

  String? _selectedAttribute2;

  String? get selectedAttribute2 => _selectedAttribute2; // set default value

  set selectedAttribute2(String? newValue) {
    _selectedAttribute2 = newValue;
    notifyListeners();
  }
}