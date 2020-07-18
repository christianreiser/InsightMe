import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart'; // for date time formatting

import './../globals.dart' as globals;
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import '../navigation_helper.dart';

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
  bool _showHint = false;

  @override
  Widget build(BuildContext context) {
    // build entry list if null
    if (_entryList == null) {
      _entryList = List<Entry>();
      if (context != null) {
        // todo check if it works
        updateEntryListView();
      }
    }

    debugPrint(
        'globals.Global().attributeListLength == 0 ${globals.Global().attributeListLength}');
    // async update local attribute list if null to load for other routes later on
    if (globals.Global().attributeListLength == 0 ||
        globals.Global().attributeListLength == null) {
      // todo check if needed
      globals.Global().updateAttributeList();
      debugPrint('attributeListLength ${globals.Global().attributeListLength}');
    }

    return RefreshIndicator(
      onRefresh: () async {
        updateEntryListView();
      },
      child: journalHintVisibleLogic() == true
          // HINT
          ? _makeEntryHint() // _delayedHint() todo

          // ENTRY LIST
          : _getEntryListView(),
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

//  Widget _delayedHint() {
//    delayedChangState();
//    debugPrint('_showHint $_showHint');
//    return AnimatedCrossFade(
//      duration: const Duration(milliseconds: 600),
//      firstChild: Container(),
//      secondChild: _makeEntryHint(),
//      crossFadeState:
//          _showHint ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//    );
//  }

  Column _makeEntryHint() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              color: Colors.tealAccent,
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
    return _isSelected.contains(true)
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
                ),
                FlatButton(
                  child: Icon(Icons.select_all),
                  onPressed: () {
                    _isSelected = List.filled(_isSelected.length, true);
                    setState(() {
                      debugPrint("Select all button clicked");
                    });
                  },
                )
              ],
            ),
            backgroundColor: Colors.grey,
          )
        : Container();
  }

// ENTRY LIST
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
                      setState(
                        () {
                          if (_isSelected.contains(true)) {
                            _isSelected[position] = !_isSelected[position];
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

  // for yellow circle avatar
  getFirstLetter(String title) {
    return title.substring(0, 1);
  }

  void delayedChangState() {
    Timer(const Duration(milliseconds: 300), handleTimeout);
  }

  void handleTimeout() {
    setState(() {
      // todo
      _showHint = true;
    });
  }

  // updateEntryListView depends on state
  // function also in createAttribute.dart but using it from there breaks it
  void updateEntryListView() async {
    _entryList = await databaseHelperEntry.getEntryList();
    globals.Global().entryListLength = _entryList.length;

    if (context != null) {
      // todo check if good
      setState(() {
        this._entryList = _entryList;
        this._countEntry = globals.Global().entryListLength; // needed
      });
      _isSelected =
          List.filled(globals.Global().entryListLength, false); // needs also an update

      // take two most recent entries as defaults for visualization.
      _getDefaultVisAttributes();
    }
  }

  void _getDefaultVisAttributes() {
    // take two most recent entries as defaults for visualization.
    // if statements are needed to catch error if list is empty.
    if (globals.Global().entryListLength > 0) {
      globals.Global().mostRecentAddedEntryName = _entryList[0].title;
      if (globals.Global().entryListLength > 1) {
        globals.Global().secondMostRecentAddedEntryName = _entryList[1].title;
      } else {
        globals.Global().secondMostRecentAddedEntryName = null;
      }
    } else {
      globals.Global().mostRecentAddedEntryName = null;
    }
  }

  // DELETE
  void _delete(_isSelected) async {
    for (int position = 0; position < _isSelected.length; position++) {
      if (_isSelected[position] == true) {
        await databaseHelperEntry // todo int result = feedback
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
      _isSelected = List.filled(globals.Global().entryListLength, false);
    });
  }
}
