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
  List<bool> _isSelected = []; // true if long pressed
  final DatabaseHelperEntry databaseHelperEntry = // error when static
      DatabaseHelperEntry();

  int _countEntry = 0;

  @override
  Widget build(BuildContext context) {
    // build entry list if null
    if (_entryList == null) {
      _entryList = List<Entry>();
      updateEntryListView();
    }

    // update local attribute list if null
    if (globals.attributeList == null) {
      debugPrint('globals.attributeListEmpty? ${globals.attributeList}');
      globals.Global().updateAttributeList();
    }

    return RefreshIndicator(
      //key: refreshKey,
      onRefresh: () async {
        updateEntryListView();
      },
      child: _getEntryListView(),
    );
  }

// ENTRY LIST
  Widget _getEntryListView() {
    return Column(children: [
      _isSelected.contains(true)
          ? AppBar(
              leading: FlatButton(
                onPressed: () {
                  _deselectAll();
                },
                child: Icon(Icons.close),
              ),
              title: Row(
                children: [
                  Text('${_countSelected()}',
                      style: TextStyle(color: Colors.black)),
                  FlatButton(
                    child: Icon(Icons.delete),
                    onPressed: () {
                      _showAlertDialogWithDelete('Delete?', '');
                      setState(() {
                        debugPrint("Delete button clicked");
                      });
                    },
                  )
                ],
              ),
              backgroundColor: Colors.grey,
            )
          : Container(),
      Expanded(
        child: ListView.builder(
          itemCount: _countEntry,
          itemBuilder: (BuildContext context, int position) {
            return Container(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              color: Theme.of(context).backgroundColor,
              child: Card(
                // gives monoton tiles a card shape
                color: _isSelected[position] == false
                    ? Colors.white
                    : Colors.grey, // when selected
                child: ListTile(
                    onLongPress: () {
                      setState(
                        () {
                          _isSelected[position] = true;
                        },
                      );
                    },
                    // CIRCLE AVATAR
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .primaryColor, //looks better than default
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
                        Text(DateFormat.yMMMMd('en_US').add_Hm().format(
                            DateTime.parse(this._entryList[position].date))),
                        Text(this._entryList[position].comment),
                      ],
                    ),

                    // onTAP TO EDIT
                    onTap: () {
                      setState(() {
                        if (_isSelected.contains(true)) {
                          _isSelected[position] = !_isSelected[position];
                        } else {
                          _navigateToEditEntry(
                              this._entryList[position]);
                        }
                        debugPrint("ListTile Tapped");
                      });
                    }),
              ),
            );
          },
        ),
      ),
    ]);
  }

  // for yellow circle avatar
  getFirstLetter(String title) {
    return title.substring(0, 1);
  }

  // navigation for editing entry
  void _navigateToEditEntry(Entry entry) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditEntry(entry);
    }));
  }

  // updateEntryListView depends on state
  // function also in createAttribute.dart but using it from there breaks it
  void updateEntryListView() async {
    _entryList = await databaseHelperEntry.getEntryList();
    setState(() {
      this._entryList = _entryList;
      this._countEntry = _entryList.length; // needed
      _isSelected = List.filled(_entryList.length, false); // todo select
    });

    // take two most recent entries as defaults for visualization.
    _getDefaultVisAttributes();
  }

  void _getDefaultVisAttributes() {
    // take two most recent entries as defaults for visualization.
    // if statements are needed to catch error if list is empty.
    if (_entryList.length > 0) {
      globals.mostRecentAddedEntryName = _entryList[0].title;
      if (_entryList.length > 1) {
        globals.secondMostRecentAddedEntryName = _entryList[1].title;
      } else {
        globals.secondMostRecentAddedEntryName = null;
      }
    } else {
      globals.mostRecentAddedEntryName = null;
    }
  }

  // DELETE
  void _delete(_isSelected) async {
    for (int position = 0; position < _isSelected.length; position++) {
      if (_isSelected[position] == true) {
        int result = // todo
            await databaseHelperEntry.deleteEntry(_entryList[position].id);
      }
    }
    updateEntryListView();
//_showAlertDialog('Deleted', 'Pull to Refresh');
  }

  void _showAlertDialogWithDelete(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      actions: [
        FlatButton(
          child: Row(
            children: [Icon(Icons.delete), Text('Yes')],
          ),
          onPressed: () {
            _delete(_isSelected);
            Navigator.of(context).pop();
          },
        ),
      ],
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  int _countSelected() {
    if (_isSelected == null || _isSelected.isEmpty) {
      return 0;
    }

    int count = 0;
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected[i] == true) {
        count++;
      }
    }
    return count;
  }

  _deselectAll() {
    setState(() {
      _isSelected = List.filled(_entryList.length, false);
    });

  }
}
