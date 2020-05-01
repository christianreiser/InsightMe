import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:lifetracker4/visualize.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/Route/edit_entries.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
import 'searchOrCreateAttribute.dart';

class JournalRoute extends StatefulWidget {
  JournalRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  JournalRouteState createState() => JournalRouteState();
}

class JournalRouteState extends State<JournalRoute> {
  DatabaseHelperEntry helperEntry = DatabaseHelperEntry(); // probably needed?
  List<Entry> entryList;
  int countEntry = 0;
  int countAttribute = 0 ;

  @override
  Widget build(BuildContext context) {
    if (entryList == null) {
      entryList = List<Entry>();
      updateEntryListView();
    }
    return RefreshIndicator(
      //key: refreshKey,
      onRefresh: () async {
        updateEntryListView();
      },
      child: getEntryListView(),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

// ENTRY LIST
  ListView getEntryListView() {
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
              navigateToEditEntry(this.entryList[position], 'Edit Entry');
            },
          ),
        );
      },
    );
  }


  void navigateToVisualize() async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Visualize();
    }));

    if (result == true) {
      updateAttributeListView();
    }
  }


  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();
  List<Attribute> attributeList;

  // updateAttributeListView depends on state
  void updateAttributeListView() {
    final Future<Database> dbFuture = databaseHelperAttribute.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Attribute>> attributeListFuture =
      databaseHelperAttribute.getAttributeList();
      attributeListFuture.then((attributeList) {
        setState(() {
          this.attributeList = attributeList;
          this.countAttribute = attributeList.length;
        });
      });
    });
  }

  // navigation for editing entry
  void navigateToSearchOrCreateAttribute() async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchOrCreateAttribute();
    }));
    if (result == true) {
      updateAttributeListView();
    }
  }


  // for yellow circle avatar
  getFirstLetter(String title) {
    return title.substring(0, 1);
  }

  // navigation for editing entry
  void navigateToEditEntry(Entry entry, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditEntry(entry, title);
    }));

    if (result == true) {
      updateEntryListView();
    }
  }

  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  // updateEntryListView depends on state
  void updateEntryListView() {
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
