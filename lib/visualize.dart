import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


class Visualize extends StatefulWidget {
  Visualize({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VisualizeState createState() => _VisualizeState();
}

class _VisualizeState extends State<Visualize> {
  DatabaseHelperEntry helperEntry = DatabaseHelperEntry();

  List<Entry> filteredEntryList;
  int countEntryFiltered = 0;
  int countAttribute = 0 ;

  @override
  Widget build(BuildContext context) {
    if (filteredEntryList == null) {
      filteredEntryList = List<Entry>();
    }
    return SingleChildScrollView(
        child:
            mychart1Items('Title', 'priceval','subtitle'),

    );// This trailing comma makes auto-formatting nicer for build methods.
  }



  List<double> getValueList() {
    List<double>  valueList = [];
    List<String>  dateList = [];
    _updateFilteredEntryListView();
    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    for (int i = 0; i < countEntryFiltered; i++) {
      valueList.add(double.parse(this.filteredEntryList[i].value));
      // TODO parsing to date type needed?
      dateList.add((this.filteredEntryList[i].date));
    }
    print('valueList: $valueList');
    print('data $data');
    return valueList;
  }


  List<double>  data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0]; // replace with db data


  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();
  List<Attribute> attributeList;

  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  // updateEntryListView depends on state
  void _updateFilteredEntryListView() {
    final Future<Database> dbFuture = databaseHelperEntry.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> entryListFuture = databaseHelperEntry.getFilteredEntryList('Productivity');
      entryListFuture.then((filteredEntryList) {
        setState(() {
          this.filteredEntryList = filteredEntryList;
          this.countEntryFiltered = filteredEntryList.length;
        });
      });
    });
  }





  //////////////////////
  Widget mychart1Items(String title, String priceVal,String subtitle) {
    return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(1.0),
        child: Sparkline(
          data: getValueList(), //getValueList(), // TODO give pointer
          //lineColor: Color(0xffff6101),
          //pointsMode: PointsMode.all,
          //pointSize: 8.0,

        ),
      ),
      Text('$data'),
      Text('${getValueList()}'),
    ]
    );
  }
}