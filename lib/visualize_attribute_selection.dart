import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "DropDown Demo";

  @override
  DropDownState createState() => DropDownState();
}

class Attribute {
  int id;
  String name;

  Attribute(this.id, this.name);

  static List<Attribute> getCompanies() {
    return <Attribute>[
      Attribute(1, 'Apple'),
      Attribute(2, 'Google'),
      Attribute(3, 'Samsung'),
      Attribute(4, 'Sony'),
      Attribute(5, 'LG'),
    ];
  }
}

class DropDownState extends State<DropDown> {
  //
  List<Attribute> _companies = Attribute.getCompanies();
  List<DropdownMenuItem<Attribute>> _dropdownMenuItems;
  Attribute _selectedAttribute;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedAttribute = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Attribute>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Attribute>> items = List();
    for (Attribute attribute in companies) {
      items.add(
        DropdownMenuItem(
          value: attribute,
          child: Text(attribute.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Attribute selectedAttribute) {
    setState(() {
      _selectedAttribute = selectedAttribute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Select a attribute"),
        SizedBox(
          height: 20.0,
        ),
        DropdownButton(
          value: _selectedAttribute,
          items: _dropdownMenuItems,
          onChanged: onChangeDropdownItem,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Selected: ${_selectedAttribute.name}'),
      ],
    );
  }
}
