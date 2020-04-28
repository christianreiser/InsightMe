//import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database/Route/entry_detail.dart';
import 'Database/attribute.dart';
import 'Database/database_helper.dart';
import 'Database/db_help_one_att.dart';
import 'Database/entry.dart';
import 'searchOrCreateAttribute.dart';




class JournalRoute extends StatefulWidget {
  JournalRoute({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _JournalRouteState createState() => _JournalRouteState();
}

class _JournalRouteState extends State<JournalRoute> {
  DbHelpOneAtt helperEntry = DbHelpOneAtt(); // probably needed?
  List<Entry> entryList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (entryList == null) {
      entryList = List<Entry>();
      updateEntryListView();
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the JournalRoute object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Journal"),
      ),
      body: getEntryListView(),
      floatingActionButton: SpeedDial(
        //floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        //tooltip: 'Increment',
        animatedIcon: AnimatedIcons.menu_close,
        children: [

          // first speed dial button for new entry
          SpeedDialChild(
              child: Icon(Icons.border_color),
              label: "New Entry",
              onTap: () {
                print("nav to add manually");
                navigateToSearchOrCreateAttribute();

              }
          ),


          // second speed dial button - no function yet
          SpeedDialChild(
              backgroundColor: Colors.grey,
              child: Icon(Icons.timer),
              label: "-not implemented-",
              onTap: () {
                print("not implemented yet");
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttributeList()),
                ); // Navigate to newManualEntry route when tapped.*/
              }
          )
        ],
      )
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Attribute> attributeList;

  // updateAttributeListView depends on state
  void updateAttributeListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Attribute>> attributeListFuture = databaseHelper.getAttributeList();
      attributeListFuture.then((attributeList) {
        setState(() {
          this.attributeList = attributeList;
          this.count = attributeList.length;
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
      updateAttributeListView();  // TODO
    }
  }

  // ENTRY LIST
  ListView getEntryListView() {
    return ListView.builder(
      itemCount: count,
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
            subtitle: Text(this.entryList[position].description),

            // Edit ICON
/*            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.edit,color: Colors.grey,),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    navigateToEntryDetail(this.entryList[position], 'Edit Attribute');
                  },
                ),
              ],
            ),*/

            // onTAP TO EDIT
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToEntryDetail(this.entryList[position], 'Edit Entry');
            },
          ),
        );
      },
    );
  }

  // for yellow circle avatar
  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  // navigation for editing entry
  void navigateToEntryDetail(Entry entry, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EntryDetail(entry, title);
    }));

    if (result == true) {
      updateEntryListView();
    }
  }

  DbHelpOneAtt dbHelpOneAtt = DbHelpOneAtt();

  // updateEntryListView depends on state
  void updateEntryListView() {
    final Future<Database> dbFuture = dbHelpOneAtt.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> entryListFuture = dbHelpOneAtt.getEntryList();
      entryListFuture.then((entryList) {
        setState(() {
          this.entryList = entryList;
          this.count = entryList.length;
        });
      });
    });
  }

}

