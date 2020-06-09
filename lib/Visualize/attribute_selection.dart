import 'package:flutter/material.dart';
import './change_notifier.dart';
import 'package:provider/provider.dart';
import '../Database/attribute.dart';
import '../Database/database_helper_attribute.dart';

class DropDown extends StatelessWidget {
  final bool boolFirst;

  DropDown(this.boolFirst);


  List<DropdownMenuItem<String>> _dropdownMenuItems; // ini item list
  static DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();

  // get Attributes from DB into a future list
  Future<List<String>> _getAttributeListNew() async {
    List<Attribute> attributeList =
        await databaseHelperAttribute.getAttributeList();
    List<String> itemList = List(attributeList.length);
    for (int ele = 0; ele < attributeList.length; ele++) {
      itemList[ele] = attributeList[ele].title;
    }

    _dropdownMenuItems =
        buildDropdownMenuItems(itemList);
    return itemList;
  }

  // build Dropdown Menu Items
  List<DropdownMenuItem<String>> buildDropdownMenuItems(List itemList) {
    List<DropdownMenuItem<String>> items = List();
    for (String item in itemList) {
      items.add(
        DropdownMenuItem(
          value: item, // The value to return if selected by user
          child: Text(item), // one item
        ),
      );
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<VisualizationChangeNotifier>(context); // send state up the tree
    return FutureBuilder(
      future: _getAttributeListNew(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (boolFirst == true) { // for first dropdown
            return Expanded( // needed

            child: DropdownButton<String>(
                // isExpanded: true is needed due to flutter bug:
                // https://stackoverflow.com/questions/47032262/flutter-dropdownbutton-overflow
                isExpanded: true,
                //hint: Text('select label'), // widget shown before selection
                value: schedule.selectedAttribute1, // selected item
                items: _dropdownMenuItems, // 4. list of all items
                onChanged: (value) =>
                schedule.selectedAttribute1 = value, // state
                //onChangeDropdownItem, // setState new selected attribute
              ),
            );
          }
          else { // for second dropdown
            return Expanded( // needed
              child: DropdownButton<String>(
                // isExpanded: true is needed due to flutter bug:
                // https://stackoverflow.com/questions/47032262/flutter-dropdownbutton-overflow
                isExpanded: true,
                //hint: Text('select label'), // widget shown before selection
                value: schedule.selectedAttribute2, // selected item
                items: _dropdownMenuItems, // 4. list of all items
                onChanged: (value) =>
                schedule.selectedAttribute2 = value, // state
                //onChangeDropdownItem, // setState new selected attribute
              ),
            );
          }
        } else {
          return Expanded(
            child: CircularProgressIndicator(),
          ); // when Future doesn't get data
        } // snapshot is current state of future
      },
    );
  }
}
