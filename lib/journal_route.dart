import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/Route/edit_entries.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';

class JournalRoute extends StatefulWidget {
  JournalRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _JournalRouteState createState() => _JournalRouteState();
}

class _JournalRouteState extends State<JournalRoute> {
  DatabaseHelperEntry helperEntry = DatabaseHelperEntry(); // probably needed?
  List<Entry> entryList;
  int countEntry = 0;
  int countAttribute = 0 ;

  @override
  Widget build(BuildContext context) {
    if (entryList == null) {
      entryList = List<Entry>();
      _updateEntryListView();
    }
    return RefreshIndicator(
      //key: refreshKey,
      onRefresh: () async {
        _updateEntryListView();
      },
      child: _getEntryListView(),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

// ENTRY LIST
  ListView _getEntryListView() {
    return ListView.builder(
      itemCount: countEntry,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            // YELLOW CIRCLE AVATAR
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.entryList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            // TITLE
            title: Text(this.entryList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),

            // SUBTITLE
            subtitle: Text(this.entryList[position].value),


            // Edit ICON
            trailing: Column(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(this.entryList[position].date),
                Text(this.entryList[position].comment),
              ],
            ),

            // onTAP TO EDIT
            onTap: () {
              debugPrint("ListTile Tapped");
              _navigateToEditEntry(this.entryList[position], 'Edit Entry');
            },
          ),
        );
      },
    );
  }



  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();
  List<Attribute> attributeList;


  // for yellow circle avatar
  getFirstLetter(String title) {
    return title.substring(0, 1);
  }

  // navigation for editing entry
  void _navigateToEditEntry(Entry entry, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditEntry(entry, title);
    }));

    if (result == true) {
      _updateEntryListView();
    }
  }

  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  // updateEntryListView depends on state
  void _updateEntryListView() {
    final Future<Database> dbFuture = databaseHelperEntry.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> entryListFuture = databaseHelperEntry.getEntryList();
      entryListFuture.then((entryList) {
        setState(() {
          this.entryList = entryList;
          this.countEntry = entryList.length;
        });
      });
    });
  }
}
