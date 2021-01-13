import 'package:flutter/foundation.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:insightme/Database/database_helper_attribute.dart';

import './../../globals.dart' as globals;

// ChangeNotifier adds listening capabilities 
class OptimizationChangeNotifier with ChangeNotifier {
  static DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();

  Future<String> getDefaultVisualizationAttribute() async {
    String defaultVisualizationAttribute;
    List<Attribute> attributeList = await databaseHelperAttribute.getAttributeList();
    for (int i = 0; i < attributeList.length; i++) {
      if (attributeList[i].title == globals.mostRecentAddedEntryName) {
        defaultVisualizationAttribute = globals.mostRecentAddedEntryName;
      }
    }
    return defaultVisualizationAttribute;
  }
  // String _selectedAttribute1 = globals.mostRecentAddedEntryName; // default value
  String _selectedAttribute1 = 'all'; // default value
  String get selectedAttribute1 => _selectedAttribute1;

  set selectedAttribute1(String newValue) {
    _selectedAttribute1 = newValue;
    notifyListeners();
  }

  // String _selectedAttribute2 = globals.secondMostRecentAddedEntryName; // default value
  String _selectedAttribute2 = 'all'; // default value

  String get selectedAttribute2 => _selectedAttribute2;

  set selectedAttribute2(String newValue) {
    _selectedAttribute2 = newValue;
    notifyListeners();
  }
}