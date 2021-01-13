import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart'; // for date time formatting

import './../globals.dart' as globals;
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import '../navigation_helper.dart';

class JournalRoute extends StatefulWidget {
  final String attributeName;

  JournalRoute(this.attributeName);

  @override
  JournalRouteState createState() => JournalRouteState();
}

class JournalRouteState extends State<JournalRoute> {
  List<Entry> _entryList;

  List<bool> _isSelectedList = []; // which entries are selected
  bool _multiEntrySelectionActive =
      false; // true if long pressed and any selected

  final DatabaseHelperEntry databaseHelperEntry = // error when static
      DatabaseHelperEntry();

  int _countEntry = 0;

  //bool _showHint = false;

  @override
  Widget build(BuildContext context) {
    // build entry list if null
    if (_entryList == null) {
      _entryList = List<Entry>();
      if (context != null) {
        updateEntryListView();
      }
    }

    // async update local attribute list if null to load for other routes later on
    if (globals.attributeListLength == null) {
      debugPrint('call updateAttributeList');
      globals.Global().updateAttributeList();
      debugPrint('attributeListLength ${globals.attributeListLength}');
      print('globals.attributeListLength ${globals.attributeListLength}');
    }

    return RefreshIndicator(
      onRefresh: () async {
        updateEntryListView();
      },
      child: journalHintVisibleLogic() == true
          // HINT
          ? _makeEntryHint()

          // ENTRY LIST
          : _getEntryListView(), //_entryListFutureBuilder(),
    );
  }

  bool journalHintVisibleLogic() {
    /*
    * hint visible if entry list is not empty
    * not visible if list == null
    * */
    bool entryListEmpty;
    if (_entryList == null) {
      entryListEmpty = false;
    } else {
      if (_entryList.isEmpty) {
        entryListEmpty = true;
      } else {
        entryListEmpty = false;
      }
    }
    return entryListEmpty;
  }


  Column _makeEntryHint() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              color: Theme.of(context).accentColor,
              child: Row(
                children: [
                  Text(
                    'To create new entries tab here ',
                    textScaleFactor: 1.2,
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
        SizedBox(
          height: 27, // height of button
        )
      ],
    );
  }

  // MULTIPLE SELECTION DELETION BAR
  Widget _actionBarWithActionBarCapability() {
    return _multiEntrySelectionActive
        ? AppBar(
            leading: FlatButton(
              onPressed: () {
                _deselectAll();
              },
              child: Icon(Icons.close),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${_countSelected()}',
                  style: TextStyle(color: Colors.black),
                ),
                FlatButton(
                  child: Icon(Icons.delete),
                  onPressed: () {
                    _showAlertDialogWithDelete('Delete?', '');
                    setState(() {
                      debugPrint("Delete button clicked");
                    });
                  },
                ),
                FlatButton(
                  child: Icon(Icons.select_all),
                  onPressed: () {
                    _isSelectedList = List.filled(_isSelectedList.length, true);
                    setState(() {
                      debugPrint("Select all button clicked");
                    });
                  },
                )
              ],
            ),
            backgroundColor: Theme.of(context).accentColor,
          )
        : Container();
  }


  Widget _getEntryListView() {
    return Column(
      children: [
        // APP BAR with MULTIPLE SELECTION DELETION capability
        _actionBarWithActionBarCapability(),

        Flexible(
          // flexible needed to avoid unbounded height error
          child: ListView.builder(
            itemCount: _countEntry,
            itemBuilder: (BuildContext context, int position) {
              return Container(
                padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                color: Theme.of(context).backgroundColor,
                child: Card(
                  // gives monotone tiles a card shape
                  // color:
                  //     _multiEntrySelectionActive // when multi selected, check each
                  //         ? _isSelectedList[position] == false
                  //             ? Theme.of(context).backgroundColor
                  //             : Theme.of(context).accentColor
                  //         : Theme.of(context).backgroundColor, // when none selected always white
                  child: ListTile(
                    onLongPress: () {
                      setState(
                        () {
                          _isSelectedList = List.filled(globals.entryListLength,
                              false); // might be first ini
                          _isSelectedList[position] = true;
                          _multiEntrySelectionActive = true;
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
                      setState(
                        () {
                          if (_multiEntrySelectionActive) {
                            _isSelectedList[position] =
                                !_isSelectedList[position];
                            if (!_isSelectedList.contains(true)) {
                              _multiEntrySelectionActive = false;
                            }
                          } else {
                            NavigationHelper().navigateToEditEntry(
                                this._entryList[position], context, false);
                          }
                          debugPrint("ListTile Tapped");
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  getFirstLetter(String title) {
    /* get first letter for yellow circle avatar */
    if (title.length > 0) {
      // to avoid error when title.length == 0
      return title.substring(0, 1);
    } else {
      return ' ';
    }
  }


  // updateEntryListView depends on state
  // function also in createAttribute.dart but using it from there breaks it
  void updateEntryListView() async {
    _entryList = await databaseHelperEntry.getEntryList();
    globals.entryListLength = _entryList.length;

    if (context != null) {
      setState(() {
        this._entryList = _entryList;
        this._countEntry = globals.entryListLength; // needed
      });

      // if multi selection was active then deactivate
      if (_multiEntrySelectionActive) {
        _multiEntrySelectionActive = false;
        _isSelectedList = null;
      }

      // take two most recent entries as defaults for visualization.
      _getDefaultVisAttributes();
    }
  }

  void _getDefaultVisAttributes() {
    // take two most recent entries as defaults for visualization.
    // if statements are needed to catch error if list is empty.
    if (globals.entryListLength == null) {
      globals.mostRecentAddedEntryName = null;
      globals.secondMostRecentAddedEntryName = null;
    } else if (globals.entryListLength > 0) {
      globals.mostRecentAddedEntryName = _entryList[0].title;
      if (globals.entryListLength > 1) {
        globals.secondMostRecentAddedEntryName = _entryList[1].title;
      } else {
        globals.secondMostRecentAddedEntryName = null;
      }
    } else {
      globals.mostRecentAddedEntryName = null;
    }
  }

  // DELETE
  void _delete(_isSelectedList) async {
    for (int position = 0; position < _isSelectedList.length; position++) {
      if (_isSelectedList[position] == true) {
        await databaseHelperEntry
            .deleteEntry(_entryList[position].id);
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
            _delete(_isSelectedList);
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
    if (_isSelectedList == null || _isSelectedList.isEmpty) {
      return 0;
    }

    int count = 0;
    for (int i = 0; i < _isSelectedList.length; i++) {
      if (_isSelectedList[i] == true) {
        count++;
      }
    }
    return count;
  }

  _deselectAll() {
    setState(() {
      _isSelectedList = List.filled(globals.entryListLength, false);
      _multiEntrySelectionActive = false;
    });
  }
}
