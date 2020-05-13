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
  List<DropdownMenuItem<Attribute>> _dropdownMenuItems;  // ini item list
  Attribute _selectedCompany;


  int countAttribute = 0;
  //List<Attribute> attributeList;
  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();






    // updateEntryListView depends on state
  Future<List<DropdownMenuItem<Attribute>>> _getAttributeListNew(userSelection) async {
      // TODO unnecessarily complicated from db to chart:
      // TODO from map(db) to list(helper) to other list(here)
      // TODO refactoring

      // in the future there will be dbFuture
      final Database dbFuture = await databaseHelperAttribute.initializeDatabase();
      final Database database = dbFuture;  // when dbFuture exists database is returned and do
      List<Attribute> attributeListFuture = await databaseHelperAttribute.getAttributeList();
      List<Attribute> attributeList = attributeListFuture;
          //this.attributeList = attributeList;

      // init state
      _dropdownMenuItems = buildDropdownMenuItems(attributeList); // 3b. all items of list
      _selectedCompany = _dropdownMenuItems[0].value; // 4a. default company (apple)
      debugPrint('userSelection $userSelection');
//      if (userSelection == false) {
//        _selectedCompany = _dropdownMenuItems[0].value; // 4a. default company (apple)
//      }
      //debugPrint('future done!');
      //debugPrint('_selectedCompany bad ${_dropdownMenuItems[0].value}');

      return _dropdownMenuItems;

  }









  // 3a. all items in list
  List<DropdownMenuItem<Attribute>> buildDropdownMenuItems(List attributes) {
    List<DropdownMenuItem<Attribute>> items = List();
    for (Attribute attribute in attributes) {
      debugPrint('attribute ${attribute.title}');
      items.add(
        DropdownMenuItem(
          value: attribute, // The value to return if selected by user
          child: Text(attribute.title), // one item
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Attribute selectedCompany) {
    setState(() {
      debugPrint('_selectedCompany good ${selectedCompany.title}');
      _selectedCompany = selectedCompany;
    });
    userSelection = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAttributeListNew(userSelection),
      builder: (context, snapshot) {
        //debugPrint('snapshot.connectionState ${snapshot.connectionState}');

        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Select a company"),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton(
                value: _selectedCompany,  // selected item
                items: _dropdownMenuItems,  // 4. list of all items
                onChanged: onChangeDropdownItem,  // setState new selected company
              ),
              SizedBox(
                height: 20.0,
              ),
              Text('Selected: ${_selectedCompany.title}'),
            ],
          );

        } else {
          return CircularProgressIndicator();
        } // snapshot is current state of future
      },
    );
  }
}

