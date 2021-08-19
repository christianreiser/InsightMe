import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';

List<Attribute> attributeList; // list to avoid async db operations
List<Entry> entryList; // list to avoid async db operations
int entryListLength;
int attributeListLength;

class Global {
  Future<List<Attribute>> updateAttributeList() async {
    attributeList = await DatabaseHelperAttribute().getAttributeList();
    attributeListLength = attributeList.length;
    return attributeList;
  }

  Future<List<Entry>> updateEntryList() async {
    entryList = await DatabaseHelperEntry().getEntryList();
    entryListLength = entryList.length;
    return entryList;
  }
}
