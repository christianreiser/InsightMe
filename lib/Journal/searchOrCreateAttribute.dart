import 'package:flutter/material.dart';
import 'package:insightme/Core/functions/misc.dart';

import './../globals.dart' as globals;
import '../Core/functions/navigation_helper.dart';
import '../Database/attribute.dart';
import '../Database/database_helper_attribute.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import '../strings.dart';

// Define SearchOrCreateAttribute widget.
class SearchOrCreateAttribute extends StatefulWidget {
  @override
  SearchOrCreateAttributeState createState() => SearchOrCreateAttributeState();
}

// Define a corresponding State class, which holds data related to the Form.
class SearchOrCreateAttributeState extends State<SearchOrCreateAttribute> {
  // ini _attributesToDisplay
  List<Attribute>? _attributesToDisplay = globals.attributeList;

  // ini _isSelected
  //debugPrint('globals.attributeList.length: ${globals.attributeList.length}');
  List<bool> _isSelected =
      List.filled(globals.attributeListLength!, false); // true if long pressed
  bool _createButtonVisible = false; // initially don't show create button
  var _attributeInputController = TextEditingController();

  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  // updateAttributeListView depends on state
  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();
  final DatabaseHelperAttribute helper = DatabaseHelperAttribute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      * This scaffold contains everything which is shown in this route
      */

      // APP BAR with MULTIPLE SELECTION DELETION capability
      appBar: _appBarWithLongPressActionCapability(),

      // FRAGMENT
      // Input field search create attribute
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              _searchOrCreateInputTextField(),
              SizedBox(width: 6),
              _createButton(),
            ],
          ),

          // spacing between boxes
          SizedBox(height: 4),
          _refreshableAttributeListViewWithConditionalHint(),
        ]),
      ),
    );
  } // widget

  AppBar _appBarWithLongPressActionCapability() {
    /*
    * App Bar which morphs into a action bar to delete item after long press
    */
    return _isSelected.contains(true)
        ? AppBar(
            leading: TextButton(
              onPressed: () {
                _deselectAll();
              },
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
            title: Row(
              children: [
                Text('${_countSelected()}',
                    style: TextStyle(color: Colors.black)),
                TextButton(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _showAlertDialogWithDelete();
                    setState(() {
                      debugPrint("Delete button clicked");
                    });
                  },
                ),
                TextButton(
                  child: Icon(
                    Icons.select_all,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _isSelected =
                        List.filled(_attributesToDisplay!.length, true);
                    setState(() {
                      debugPrint("Select all button clicked");
                    });
                  },
                )
              ],
            ),
            backgroundColor:
                Theme.of(context).backgroundColor, //looks better than default
          )
        : AppBar(
            title: Text("What to track?"),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                NavigationHelper().navigateToFutureDesign(context); // refreshes
              },
            ),
          );
  }

  Widget _searchOrCreateInputTextField() {
    /*
    * Input text field which allows to create new labels or search for labels
    */
    return Expanded(
      // eliminates E: TextField cannot have an unbounded width
      child: TextField(
        decoration: InputDecoration(
          isDense: true, // for smaller height
          border: OutlineInputBorder(),
          labelText: 'search or create new label',
          suffixIcon: IconButton(
            onPressed: () {
              _attributeInputController.clear();
              _getAttributesToDisplay(); // needed to refresh
              setState(() {}); // needed to refresh
            },
            icon: Icon(Icons.clear),
          ),
        ),
        controller: _attributeInputController,
        onChanged: (value) {
          _getAttributesToDisplay();
          setState(() {});
        },
      ),
    );
  }

  Visibility _createButton() {
    /*
    * "CREATE" button to save new labels
    */
    return Visibility(
      visible: _createButtonVisible,
      replacement: Container(), // don't occupy space if hidden
      child: ButtonTheme(
        minWidth: 0,
        height: 48, // should be same height as TextField
        child: ElevatedButton(
          child: Text(
            'Create',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            debugPrint("Create button clicked");
            _saveAttributeAndRefreshView(
              Attribute(
                  _attributeInputController.text,
                  'optional: write a note',
                  defaultLabelColor,
                  defaultAggregation),
            );
            //setState(() {});
          },
        ),
      ),
    );
  }

  Flexible _refreshableAttributeListViewWithConditionalHint() {
    /*
    * make attribute list view REFRESHABLE and SHOW and HIDE hint
    */
    return Flexible(
      // w/o flexible items noy shown, not sure why
      child: RefreshIndicator(
        onRefresh: () async {
          globals.attributeList =
              await databaseHelperAttribute.getAttributeList();
          globals.attributeListLength = globals.attributeList!.length;
          _getAttributesToDisplay();
          setState(() {});
        },
        child:
            // LOGIC FOR CONDITIONAL HINT
            // if _attributesToDisplay == null show hint
            _attributesToDisplay == null
                ? _createAttributeHint()
                // if _attributesToDisplay is empty show hint
                : _attributesToDisplay!.isEmpty
                    ? _createAttributeHint()
                    // if ATTRIBUTE LIST is not empty
                    : globals.attributeListLength! < 3
                        ? ListView(
                            children: [
                              _getAttributeListView(),
                              _attributeHint()
                            ],
                          )
                        : _getAttributeListView(),
      ),
    );
  }

  Widget _getAttributeListView() {
    /// ATTRIBUTE LIST
    return ListView.builder(
      shrinkWrap: true, // needed to give space for entry hint
      itemCount: _attributesToDisplay!.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: _isSelected[position] == false
              ? Color(this._attributesToDisplay![position].color!)
              : Colors.grey, //  select
          child: ListTile(
            onLongPress: () {
              setState(() {
                _isSelected[position] = true;
              });
            },
            // YELLOW CIRCLE AVATAR
            leading: CircleAvatar(
              //backgroundColor: Colors.amber,
              child: Text(
                getFirstLetter(this._attributesToDisplay![position].title),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // TITLE
            title: Text(
              _attributesToDisplay![position].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // EDIT ICON
            trailing: SizedBox(
              height: 45,
              width: 45,
              child: GestureDetector(
                child: Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
                onTap: () {
                  debugPrint("ListTile Tapped");
                  NavigationHelper().navigateToEditAttribute(
                      _attributesToDisplay![position],
                      _attributesToDisplay![position].title,
                      context);
                },
              ),
            ),

            // onTAP for entry
            onTap: () {
              setState(() {
                debugPrint("One Attribute selected");

                if (_isSelected.contains(true)) {
                  _isSelected[position] = !_isSelected[position];
                } else {
                  NavigationHelper().navigateToEditEntry(
                      // title, value, time, comment
                      Entry(this._attributesToDisplay![position].title, '',
                          '${DateTime.now()}', ''),
                      context,
                      true);
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget _attributeHint() {
    /*
    * SECOND HINT: explains how to write entries or create new labels
    * */
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.black45,
                ),
                Text(
                  'Tab a label to write an entry to your journal.\n'
                  'Or create more labels like \'Mood\', \'Productivity\','
                  ' habits, medications, symptoms and emotions.',
                  style: TextStyle(color: Colors.black45, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _createAttributeHint() {
    /*
    * FIRST HINT: explains how to create a Attribute
    * */
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.black45,
                ),

                Text(
                  'Type to create labels you want to track. '
                  'For example \'Mood\' for how you are feeling today, '
                  '\'Productivity\' to track the progress on your goals.'
                  ' Other ideas are habits, medications, symptoms, '
                  'emotions.',
                  style: TextStyle(color: Colors.black45, fontSize: 20),
                ),
                //Expanded(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List _searchOperation() {
    /*
    * SEARCH OPERATION
    * Search attributes that match string.
    * returns:
    * searchResults, and bool indicators if userInput, match, or exactMatch
    */
    List<Attribute> _searchResult = [];

    bool userInput = _attributeInputController.text.isNotEmpty;
    bool match = false;
    bool exactMatch = false;

    // go through all attributes one by one
    if (userInput) {
      for (int i = 0; i < globals.attributeListLength!; i++) {
        // PARTIAL OR EXACT SEARCH MATCH
        // search for attributes that contain input
        if (globals.attributeList![i].title
            .toLowerCase()
            .contains(_attributeInputController.text.toLowerCase())) {
          _searchResult.add(globals.attributeList![i]); // list of results
          match = true;
          userInput = true;

          // hide create button if EXACT search match
          if (globals.attributeList![i].title
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

  List _getAttributesToDisplay() {
    /*
    calls: _searchOperation()
    sets: _isSelected to all false
    returns: _attributesToDisplay, _createButtonVisible, _createButtonVisible

    * LOGIC OF WHEN TO SHOW BUTTON AND SEARCH RESULTS
    * exact match: no button but results
    * no input: no button no results
    * no match: button but no results
    * partial match: button and results
    *
    */
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
              _searchResult as List<Attribute>?; // show results and not all attributes
        } else {
          // partial match
          _createButtonVisible = true;
          _attributesToDisplay =
              _searchResult as List<Attribute>?; // show results and not all attributes
        }
      } else {
        // no match
        _createButtonVisible = true;
        _attributesToDisplay = _searchResult as List<Attribute>?;
      }
    } else {
      // no input
      _attributesToDisplay = globals.attributeList;
      _createButtonVisible = false;
    }
    _isSelected = List.filled(_attributesToDisplay!.length, false);
    return [_attributesToDisplay, _createButtonVisible, _createButtonVisible];
  }

  Future<int?> saveAttribute(attribute) async {
    // not private as used elsewhere
    /*
    * Update Operation: Update a attribute object and save it to database
    */
    int? result;
    if (attribute.id != null) {
      // Case 1: Update operation
      result = await helper.updateAttribute(attribute);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertAttribute(attribute);
    }

    globals.attributeList = await databaseHelperAttribute.getAttributeList();
    globals.attributeListLength = globals.attributeList!.length;

    // SUCCESS FAILURE STATUS DIALOG
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Attribute Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Attribute');
    }
    return result;
  }

  void _saveAttributeAndRefreshView(attribute) async {
    await saveAttribute(attribute);
    _getAttributesToDisplay();
    setState(() {});
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message), actions: [
      TextButton(
        child: const Text("Close"),
        onPressed: () => Navigator.pop(context),
      ),
    ]
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
    /*
    * Delete Operation: Delete a attribute from database
    */
    List<int?> _resultList = [];

    for (int position = 0; position < _isSelected.length; position++) {
      if (_isSelected[position] == true) {
        // Deletion of entries
        List<Entry> filteredEntryList = await databaseHelperEntry
            .getFilteredEntryList(_attributesToDisplay![position].title);
        for (int i = 0; i < filteredEntryList.length; i++) {
          _resultList.add(
            await databaseHelperEntry.deleteEntry(filteredEntryList[i].id),
          );
        }

        // Deletion in Attribute DB
        _resultList.add(
          await databaseHelperAttribute
              .deleteAttribute(_attributesToDisplay![position].id),
        );
      }
    }

    if (context != null) {
      // catch error when user closes context
      globals.attributeList = await databaseHelperAttribute.getAttributeList();
      globals.attributeListLength = globals.attributeList!.length;
      _getAttributesToDisplay();
      setState(() {});
    }

    // Success Failure evaluation
    if (_resultList.contains(0)) {
      _showAlertDialog('Status', 'Error occurred while Deleting Attribute');
    } else {
      _showAlertDialog('Status', 'Successful deletion');
    }
  }

  void _showAlertDialogWithDelete() {
    AlertDialog alertDialog = AlertDialog(
      actions: [
        TextButton(
          child: Row(
            children: [Icon(Icons.arrow_back_ios), Text('Back')],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.delete,
              ),
              Text('Yes')
            ],
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
      _isSelected = List.filled(_attributesToDisplay!.length, false);
    });
  }
} // class
