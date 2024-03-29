import 'package:flutter/material.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:provider/provider.dart';

import 'change_notifier.dart';

class DropDown extends StatefulWidget {
  final bool boolFirst;

  DropDown(this.boolFirst);

  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  List<DropdownMenuItem<String>> _dropdownMenuItems;

  @override
  Widget build(BuildContext context) {
    final changeNotifier = Provider.of<OptimizationChangeNotifier>(
        context); // send state up the tree
    return FutureBuilder(
      future: _getAttributeList(widget.boolFirst),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (widget.boolFirst == true) {
            // for first dropdown
            return Expanded(
              // needed

              child: DropdownButton<String>(
                dropdownColor: Colors.deepPurple[50],
                iconEnabledColor: Colors.deepPurple,
                focusColor: Colors.deepPurple,
                underline: Container(
                  color: Colors.deepPurple,
                  child: SizedBox(height: 1),
                ),
                // isExpanded: true is needed due to flutter bug:
                // https://stackoverflow.com/questions/47032262/flutter-dropdownbutton-overflow
                isExpanded: true,
                //hint: Text('select label'), // widget shown before selection
                value: changeNotifier.selectedAttribute1,
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
                // selected item
                items: _dropdownMenuItems,
                // list of all items
                onChanged: (value) =>
                    changeNotifier.selectedAttribute1 = value, // state
                //onChangeDropdownItem, // setState new selected attribute
              ),
            );
          } else {
            // for second dropdown
            return Expanded(
              // needed
              child: DropdownButton<String>(
                dropdownColor: Colors.blue[50],
                iconEnabledColor: Colors.blue,
                focusColor: Colors.blue,
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
                underline: Container(
                  color: Colors.blue,
                  child: SizedBox(height: 1),
                ),
                //underline: ,
                //isDense: true,
                // isExpanded: true is needed due to flutter bug:
                // https://stackoverflow.com/questions/47032262/flutter-dropdownbutton-overflow
                isExpanded: true,
                //hint: Text('select label'), // widget shown before selection
                value: changeNotifier.selectedAttribute2,
                // selected item
                items: _dropdownMenuItems,
                // 4. list of all items
                onChanged: (value) =>
                    changeNotifier.selectedAttribute2 = value, // state
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

  Future<List<String>> _getAttributeList(boolFirst) async {
    List<Attribute> attributeList =
        await DropDown.databaseHelperAttribute.getAttributeList();
    List<String> itemList = List.filled(attributeList.length + 1, null);

    /// +1 for 'all'
    itemList[0] = 'all';

    /// to correlate with everything
    for (int ele = 0; ele < attributeList.length; ele++) {
      itemList[ele + 1] = attributeList[ele].title; // +1 for 'all'
    }

    _dropdownMenuItems = _buildDropdownMenuItems(itemList);
    return itemList;
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List itemList) {
    List<DropdownMenuItem<String>> items = [];
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
}
