import 'dart:ui';
import './../Database/attribute.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Database/Route/edit_attributes.dart';
import '../Database/Route/edit_entries.dart';
import '../Database/attribute.dart';
import '../Database/database_helper_attribute.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import '../scaffold_route.dart';
import 'journal_route.dart';
import './../globals.dart' as globals;

// Define SearchOrCreateAttribute widget.
class SearchOrCreateAttribute extends StatefulWidget {
  @override
  SearchOrCreateAttributeState createState() => SearchOrCreateAttributeState();
}

// Define a corresponding State class, which holds data related to the Form.
class SearchOrCreateAttributeState extends State<SearchOrCreateAttribute> {
  List _attributesToDisplay = List<Attribute>();
  bool _createButtonVisible = true;
  var _attributeInputController = TextEditingController();
  List<Attribute> _attributeList;
  List<bool> _isSelected = []; // true if long pressed
  List<Entry> _entryList;
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  @override
  Widget build(BuildContext context) {
    if (_attributeList == null) {
      _attributeList = List<Attribute>();
      updateAttributeListView();
    }

    return Scaffold(
      // APP BAR with MULTIPLE SELECTION DELETION capeability
      appBar: _actionBarWithActionBarCapability(),

      // FRAGMENT
      // Input field search create attribute
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                //height: ,
                child: // Input text field for search or create attribute
                    // TEXT FIELD
                    TextField(
                  decoration: InputDecoration(
                    isDense: true, // for smaller height
                    border: OutlineInputBorder(),
                    labelText: 'search or create new label',
                    suffixIcon: IconButton(
                      onPressed: () => _attributeInputController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  controller: _attributeInputController,
                  onChanged: (value) {
                    debugPrint(
                        "Something changed search or create new attribute:"
                        " ${_attributeInputController.text}");
                    getAttributesToDisplay();
                    setState(() {});
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(3.0),
              ),

              // "CREATE" button
              Visibility(
                visible: _createButtonVisible,
                replacement: Container(), // don't occupy space if hidden
                child: ButtonTheme(
                  minWidth: 0,
                  height: 48, // should be same height as TextField
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Create',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        saveAttribute(
                          Attribute(_attributeInputController.text),
                        );
                        debugPrint("Create button clicked");
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          // spacing between boxes
          SizedBox(height: 4),

          // ATTRIBUTE LIST
          _getAttributeListView(),
        ]),
      ),
    );
  } // widget

  // MULTIPLE SELECTION DELETION BAR
  AppBar _actionBarWithActionBarCapability() {
    return _isSelected.contains(true)
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
                    _showAlertDialogWithDelete();
                    setState(() {
                      debugPrint("Delete button clicked");
                    });
                  },
                )
              ],
            ),
            backgroundColor: Colors.grey,
          )
        : AppBar(
            title: Text("Select a label"),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                _navigateToScaffoldRoute(); // refreshes
              },
            ),
          );
  }

  // Attribute LIST
  Flexible _getAttributeListView() {
    return Flexible(
      // pull to refresh
      child: RefreshIndicator(
        onRefresh: () async {
          updateAttributeListView();
        },

        // if typed into search field only show matches
        child: ListView.builder(
          itemCount: _attributesToDisplay.length,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              color: _isSelected[position] == false
                  ? Colors.white
                  : Colors.grey, //  select
              child: ListTile(
                onLongPress: () {
                  setState(
                    () {
                      _isSelected[position] = true;
                    },
                  );
                },
                // YELLOW CIRCLE AVATAR
                leading: CircleAvatar(
                  //backgroundColor: Colors.amber,
                  child: Text(
                    JournalRouteState().getFirstLetter(
                        this._attributesToDisplay[position].title),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // TITLE
                title: Text(
                  _attributesToDisplay[position].title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                // EDIT ICON
                trailing: GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    _navigateToEditAttribute(
                        // todo such that no 2 _attributesToDisplay needed as input. (rename attribute)
                        _attributesToDisplay[position],
                        _attributesToDisplay[position].title);
                  },
                ),

                // onTAP for entry
                onTap: () {
                  setState(() {
                    debugPrint("One Attribute selected");

                    if (_isSelected.contains(true)) {
                      _isSelected[position] = !_isSelected[position];
                    } else {
                      _navigateToEditEntry(
                          // title, value, time, comment
                          Entry(this._attributesToDisplay[position].title, '',
                              '${DateTime.now()}', ''));
                    }
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void moveToLastRoute() {
    Navigator.pop(context, true);
  }

  // navigation back to journal and refresh to show new entry
  void _navigateToScaffoldRoute() async {
    // don't use pop because it doesn't refresh the page
    // RemoveUntil is needed to remove the old outdated journal route
    bool result =
        await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
      context,
    ) {
      return ScaffoldRoute();
    }), (Route<dynamic> route) => false);

    if (result == true) {
      _updateEntryListView();
    }
  }

  // navigation for editing entry
  void _navigateToEditAttribute(Attribute attribute, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditAttribute(attribute, title);
    }));

    if (result == true) {
      updateAttributeListView();
    }
  }

  // navigation for editing entry
  // function exists also in journal_route.dart but when using it from there:
  // state error
  void _navigateToEditEntry(Entry entry) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditEntry(entry);
      }),
    );
  }

  // updateAttributeListView depends on state
  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  void updateAttributeListView() async {
    _attributeList = await databaseHelperAttribute.getAttributeList();
    setState(() {
      this._attributeList = _attributeList;
      getAttributesToDisplay();
    });
  }

  // updateEntryListView depends on state
  // functions also in journal_route but using it from there breaks it
  void _updateEntryListView() async {
    _entryList = await databaseHelperEntry.getEntryList();
    setState(() {
      this._entryList = _entryList;
    });
  }

  List _searchOperation() {
    /*
    * SEARCH OPERATION
    * Search attributes that match string.
    * returns:
    * searchResults, and bool indicators if userInput, match, or exactMatch
    */
    List _searchResult = List<Attribute>();

    bool userInput = _attributeInputController.text.isNotEmpty;
    bool match = false;
    bool exactMatch = false;

    // go through all attributes one by one
    if (userInput) {
      for (int i = 0; i < _attributeList.length; i++) {
        // PARTIAL OR EXACT SEARCH MATCH
        // search for attributes that contain input
        if (_attributeList[i]
            .title
            .toLowerCase()
            .contains(_attributeInputController.text.toLowerCase())) {
          _searchResult.add(_attributeList[i]); // list of results
          match = true;
          userInput = true;

          // hide create button if EXACT search match
          if (_attributeList[i]
                  .title
                  .toLowerCase()
                  .compareTo(_attributeInputController.text.toLowerCase()) ==
              0) {
            exactMatch = true;
          }
        }
      }
    }
    return [_searchResult, userInput, match, exactMatch];
  }

  List getAttributesToDisplay() {
    // LOGIC OF WHEN TO SHOW BUTTON AND SEARCH RESULTS
    // exact match: no button but results
    // no input: no button no results
    // no match: button but no results
    // partial match: button and results

    List output = _searchOperation();
    List _searchResult = output[0];
    bool userInput = output[1];
    bool match = output[2];
    bool exactMatch = output[3];

    if (userInput) {
      if (match) {
        if (exactMatch) {
          // exact match
          _createButtonVisible = false;
          _attributesToDisplay =
              _searchResult; // show results and not all attributes
        } else {
          // partial match
          _createButtonVisible = true;
          _attributesToDisplay =
              _searchResult; // show results and not all attributes
        }
      } else {
        // no match
        _createButtonVisible = true;
        _attributesToDisplay = _searchResult;
      }
    } else {
      // no input
      _attributesToDisplay = _attributeList;
      _createButtonVisible = false;
    }
    _isSelected = List.filled(_attributesToDisplay.length, false);
    return [_attributesToDisplay, _createButtonVisible, _createButtonVisible];
  }

  void saveAttribute(attribute) async {
    final DatabaseHelperAttribute helper = DatabaseHelperAttribute();

    // Update Operation: Update a attribute object and save it to database
    int result;
    if (attribute.id != null) {
      // Case 1: Update operation
      result = await helper.updateAttribute(attribute);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertAttribute(attribute);
    }

    // update after creation
    if (context != null) { // todo check if it works
      updateAttributeListView(); // update from db
    }
    _searchOperation(); // search after update from db
    globals.Global().updateAttributeList();

    // SUCCESS FAILURE STATUS DIALOG
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Attribute Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Attribute');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    if (context != null) {
      // catch error when user closes context
      showDialog(context: context, builder: (_) => alertDialog);
    }
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

// DELETE
  void _delete(_isSelected) async {
    List<int> _resultList = [];

    for (int position = 0; position < _isSelected.length; position++) {
      if (_isSelected[position] == true) {
        // Deletion of entries
        List<Entry> filteredEntryList = await databaseHelperEntry
            .getFilteredEntryList(_attributesToDisplay[position].title);
        for (int i = 0; i < filteredEntryList.length; i++) {
          _resultList.add(
            await databaseHelperEntry.deleteEntry(filteredEntryList[i].id),
          );
        }

        // Deletion in Attribute DB
        _resultList.add(
          await databaseHelperAttribute // todo feedback with: int result =
              .deleteAttribute(_attributesToDisplay[position].id),
        );
      }
    }
    // Success Failure evaluation
    if (_resultList.contains(0)) {
      _showAlertDialog('Status', 'Error occurred while Deleting Attribute');
    } else {
      _showAlertDialog('Status', 'Successful deletion');
    }
    if (context != null) {
      // catch error when user closes context
      updateAttributeListView();
    }
  }

  void _showAlertDialogWithDelete() {
    AlertDialog alertDialog = AlertDialog(
      actions: [
        FlatButton(
          child: Row(
            children: [Icon(Icons.arrow_back_ios), Text('Back')],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Row(
            children: [Icon(Icons.delete), Text('Yes')],
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _delete(_isSelected);
          },
        ),
      ],
      title: Text('Delete?'),
      content:
          Text('All selected Labels AND all it\'s entries will be deleted, '
              'forever.'),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  _deselectAll() {
    setState(() {
      _isSelected = List.filled(_attributesToDisplay.length, false);
    });
  }
} // class
