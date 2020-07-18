import 'package:flutter/foundation.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import './../globals.dart' as globals;

// ChangeNotifier adds listening capabilities 
class VisualizationChangeNotifier with ChangeNotifier {
  static DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();

  Future<String> getDefaultVisualizationAttribute() async {
    String defaultVisualizationAttribute;
    List<Attribute> attributeList = await databaseHelperAttribute.getAttributeList();
    for (int i = 0; i < attributeList.length; i++) {
      if (attributeList[i].title == globals.Global().mostRecentAddedEntryName) {
        defaultVisualizationAttribute = globals.Global().mostRecentAddedEntryName;
      }
    }
    return defaultVisualizationAttribute;
  }
  String _selectedAttribute1 = globals.Global().mostRecentAddedEntryName; // default value
  String get selectedAttribute1 => _selectedAttribute1;

  set selectedAttribute1(String newValue) {
    _selectedAttribute1 = newValue;
    notifyListeners();
  }

  String _selectedAttribute2 = globals.Global().secondMostRecentAddedEntryName; // default value

  String get selectedAttribute2 => _selectedAttribute2;

  set selectedAttribute2(String newValue) {
    _selectedAttribute2 = newValue;
    notifyListeners();
  }
}