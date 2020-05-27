import 'package:flutter/material.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';

class DropDown extends StatefulWidget {
  final String defaultAttribute1;

  DropDown(this.defaultAttribute1) : super();

  @override
  DropDownState createState() => DropDownState(defaultAttribute1);
}



class DropDownState extends State<DropDown> {
  String selectedAttribute;

  DropDownState(this.selectedAttribute);

  List<DropdownMenuItem<String>> _dropdownMenuItems; // ini item list
  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();


  // get Attributes from DB into a future list
  Future<List<String>> _getAttributeListNew() async {
    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    // TODO refactoring

    // in the future there will be dbFuture
    List<Attribute> attributeList =
        await databaseHelperAttribute.getAttributeList();
    List<String> itemList = List(attributeList.length);
    for (int ele = 0; ele < attributeList.length; ele++) {
      itemList[ele] = attributeList[ele].title;
    }

    _dropdownMenuItems =
        buildDropdownMenuItems(itemList); // 3b. all items of list
    debugPrint('selectedAttribute ${selectedAttribute}');
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

  onChangeDropdownItem(String selectedAttributeNew) {
    setState(() {
      selectedAttribute = selectedAttributeNew;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAttributeListNew(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              DropdownButton<String>(
                hint: Text('select label'), // widget shown before selection
                value: selectedAttribute, // selected item
                items: _dropdownMenuItems, // 4. list of all items
                onChanged:
                    onChangeDropdownItem, // setState new selected attribute
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          );
        } else {
          return CircularProgressIndicator(); // when Future doesn't get data
        } // snapshot is current state of future
      },
    );
  }
}
