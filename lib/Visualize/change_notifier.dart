import 'package:flutter/foundation.dart';
import 'package:insightme/Database/database_helper_attribute.dart';

// ChangeNotifier adds listening capabilities
class OptimizationChangeNotifier with ChangeNotifier {
  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  String _selectedAttribute1 = 'mood'; // default value
  String get selectedAttribute1 => _selectedAttribute1;

  set selectedAttribute1(String newValue) {
    _selectedAttribute1 = newValue;
    notifyListeners();
  }

  String _selectedAttribute2 = 'all'; // default value

  String get selectedAttribute2 => _selectedAttribute2;

  set selectedAttribute2(String newValue) {
    _selectedAttribute2 = newValue;
    notifyListeners();
  }
}
