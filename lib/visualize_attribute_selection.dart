import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';


class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "DropDown Demo";

  @override
  DropDownState createState() => DropDownState();
}



class DropDownState extends State<DropDown> {
  bool userSelection = false;
// List of companies interface for companies
  //List<Company> _companies = Company.getCompanies();  // 2. get company list
  List<DropdownMenuItem<String>> _dropdownMenuItems;  // ini item list
  String _selectedCompany;


  //int countAttribute = 0;
  //List<Attribute> attributeList;
  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();






    // updateEntryListView depends on state
  Future<List<String>> _getAttributeListNew() async {

      // TODO unnecessarily complicated from db to chart:
      // TODO from map(db) to list(helper) to other list(here)
      // TODO refactoring

      // in the future there will be dbFuture
      //final Database dbFuture = await databaseHelperAttribute.initializeDatabase();
      List<Attribute> attributeList = await databaseHelperAttribute.getAttributeList();
      List<String> itemList = List(attributeList.length);
      for (int ele = 0; ele < attributeList.length; ele++) {
        itemList[ele] = attributeList[ele].title;
      }
      debugPrint('itemList: $itemList');


      _dropdownMenuItems = buildDropdownMenuItems(itemList); // 3b. all items of list

      return itemList;

  }








  // 3a. all items in list.value
  List<DropdownMenuItem<String>> buildDropdownMenuItems(List itemList) {
    List<DropdownMenuItem<String>> items = List();
    for (String item in itemList) {
      debugPrint('item ${item}');
      items.add(
        DropdownMenuItem(
          value: item, // The value to return if selected by user
          child: Text(item), // one item
        ),
      );
    }
    debugPrint('2 items: $items');
    return items;
  }

  onChangeDropdownItem(String selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
      //debugPrint('selectedCompany.title good ${selectedCompany.title}');
      debugPrint('selectedCompany good ${selectedCompany}');
      //debugPrint('1_selectedCompany.title good ${_selectedCompany.title}');
      debugPrint('_selectedCompany good ${_selectedCompany}');
    });
    debugPrint('1');
    //debugPrint('2_selectedCompany.title good ${_selectedCompany.title}');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('3');
    return FutureBuilder(
      future: _getAttributeListNew(),
      builder: (context, snapshot) {
        debugPrint('snapshot.connectionState ${snapshot.connectionState}');
        //debugPrint('4 _selectedCompany $_selectedCompany');
        //debugPrint('4 _selectedCompany.title ${_selectedCompany.title}');
        if (snapshot.connectionState == ConnectionState.done) {

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Select a company"),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<String>(
                value: _selectedCompany,  // selected item
                items: _dropdownMenuItems,  // 4. list of all items
                onChanged: onChangeDropdownItem,  // setState new selected company
              ),
              SizedBox(
                height: 20.0,
              ),
              //Text('Selected: ${_selectedCompany.title}'),
            ],
          );

        } else {
          return CircularProgressIndicator();
        } // snapshot is current state of future
      },
    );
  }
}

