import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import '../Database/Route/edit_entries.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import './../globals.dart' as globals;
import 'package:intl/intl.dart'; // for date time formatting

class JournalRoute extends StatefulWidget {
  JournalRoute();

  @override
  JournalRouteState createState() => JournalRouteState();
}

class JournalRouteState extends State<JournalRoute> {
  List<Entry> _entryList;
  int _countEntry = 0;

  @override
  Widget build(BuildContext context) {
    if (_entryList == null) {
      _entryList = List<Entry>();
      updateEntryListView();
    }
    return RefreshIndicator(
      //key: refreshKey,
      onRefresh: () async {
        updateEntryListView();
      },
      child: _getEntryListView(),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

// ENTRY LIST
  ListView _getEntryListView() {
    return ListView.builder(
      itemCount: _countEntry,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          color: Theme.of(context).backgroundColor,
          child: Card(
            //color: Colors.white,
            //shadowColor: Colors.black,
            //elevation: 3.0,
            child: ListTile(
              // YELLOW CIRCLE AVATAR
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  getFirstLetter(this._entryList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              // Label
              title: Text(
                this._entryList[position].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Value
              subtitle: Text(this._entryList[position].value),

              // Time and comment
              trailing: Column(
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // DateFormat formats DateFormat to better readable format but
                  // needs type DateTime as input. DB doesn't support this type,
                  // that's why the workaround with DateTime.parse from string
                  Text(DateFormat.yMMMMd('en_US')
                      .add_Hm()
                      .format(DateTime.parse(this._entryList[position].date))),
                  Text(this._entryList[position].comment),
                ],
              ),

              // onTAP TO EDIT
              onTap: () {
                debugPrint("ListTile Tapped");
                _navigateToEditEntry(this._entryList[position], 'Edit Entry');
              },
            ),
          ),
        );
      },
    );
  }

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
      updateEntryListView();
    }
  }

  // updateEntryListView depends on state
  // function also in createAttribute.dart but using it from there breaks it
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();
  void updateEntryListView() async {
    Future<List<Entry>> _entryListFuture = databaseHelperEntry.getEntryList();
    _entryList = await _entryListFuture;
    setState(() {
      this._entryList = _entryList;
      this._countEntry = _entryList.length;
    });

    // take two most recent entries as defaults for visualization
    globals.mostRecentAddedEntryName = _entryList[0].title;
    globals.secondMostRecentAddedEntryName = _entryList[1].title;
  }
}
