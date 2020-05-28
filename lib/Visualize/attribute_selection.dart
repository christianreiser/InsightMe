import 'package:flutter/material.dart';
import 'package:lifetracker4/Visualize/schedule.dart';
import 'package:provider/provider.dart';
import '../Database/attribute.dart';
import '../Database/database_helper_attribute.dart';

class DropDown extends StatefulWidget {
  final String defaultAttribute1;

  DropDown(this.defaultAttribute1) : super();

  @override
  DropDownState createState() => DropDownState(defaultAttribute1);
}

class DropDownState extends State<DropDown> {
  String selectedAttribute1;

  DropDownState(this.selectedAttribute1);

  List<DropdownMenuItem<String>> _dropdownMenuItems; // ini item list
  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();

  // get Attributes from DB into a future list
  Future<List<String>> _getAttributeListNew() async {
    // in the future there will be dbFuture
    List<Attribute> attributeList =
        await databaseHelperAttribute.getAttributeList();
    List<String> itemList = List(attributeList.length);
    for (int ele = 0; ele < attributeList.length; ele++) {
      itemList[ele] = attributeList[ele].title;
    }

    _dropdownMenuItems =
        buildDropdownMenuItems(itemList); // 3b. all items of list
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

//  onChangeDropdownItem(String selectedAttributeNew) {
//    setState(() {
//      selectedAttribute1 = selectedAttributeNew;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<MySchedule>(context); // send state up the tree
    return FutureBuilder(
      future: _getAttributeListNew(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
            // needed
            child: DropdownButton<String>(
              // isExpanded: true is needed due to flutter bug:
              // https://stackoverflow.com/questions/47032262/flutter-dropdownbutton-overflow
              isExpanded: true,
              //hint: Text('select label'), // widget shown before selection
              value: schedule.selectedAttribute1, // selected item
              items: _dropdownMenuItems, // 4. list of all items
              onChanged: (value) => schedule.selectedAttribute1 = value,// state
                  //onChangeDropdownItem, // setState new selected attribute
            ),
          );
        } else {
          return Expanded(
            child: CircularProgressIndicator(),
          ); // when Future doesn't get data
        } // snapshot is current state of future
      },
    );
  }
}
