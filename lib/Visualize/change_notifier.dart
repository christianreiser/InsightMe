import 'package:flutter/foundation.dart';
import './../globals.dart' as globals;

// ChangeNotifier adds listening capabilities 
class VisualizationChangeNotifier with ChangeNotifier {
  String _selectedAttribute1 = globals.mostRecentAddedEntryName; // default value
  String get selectedAttribute1 => _selectedAttribute1;

  set selectedAttribute1(String newValue) {
    _selectedAttribute1 = newValue;
    notifyListeners();
  }

  String _selectedAttribute2 = globals.secondMostRecentAddedEntryName; // default value

  String get selectedAttribute2 => _selectedAttribute2;

  set selectedAttribute2(String newValue) {
    _selectedAttribute2 = newValue;
    notifyListeners();
  }
}