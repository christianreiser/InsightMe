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
import 'package:intl/intl.dart'; // DateFormat.yMMMd().add_Hms().format(DateTime.now())

// Define SearchOrCreateAttribute widget.
class SearchOrCreateAttribute extends StatefulWidget {
  @override
  SearchOrCreateAttributeState createState() => SearchOrCreateAttributeState();
}

// Define a corresponding State class, which holds data related to the Form.
class SearchOrCreateAttributeState extends State<SearchOrCreateAttribute> {
  List _searchResult = List<Attribute>();
  List _attributesToDisplay = List<Attribute>();
  bool createButtonVisible = true;
  var _attributeInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (attributeList == null) {
      attributeList = List<Attribute>();
      _updateAttributeListView();
    }

    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: Text("Add Entry"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            _navigateToScaffoldRoute(); // refreshes
          },
          //child: _getAttributeListView(),

//              {
//                moveToLastRoute();
//                _updateEntryListView();
//              },
        ),
      ),

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
                    _searchOperation();
                    _updateAttributeListView(); // update after search
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(4.0),
              ),

              // "CREATE" button
              Container(
                child: Visibility(
                  visible: createButtonVisible,
                  replacement: Container(), // don't occupy space if hidden
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Create',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        _save(Attribute(_attributeInputController.text, ''));
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

          // List of previously used attributes
          _getAttributeListView(),
        ]),
      ),
    );
  } // widget

  // Attribute LIST
  Flexible _getAttributeListView() {
    _searchOperation(); // one search operation to get attributes to display
    return Flexible(
      // pull to refresh
      child: RefreshIndicator(
        onRefresh: () async {
          _updateAttributeListView();
        },

        // if typed into search field only show matches
        child: ListView.builder(
          itemCount: _attributesToDisplay.length,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              //color: Colors.white,
              elevation: 2.0,
              child: ListTile(
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        debugPrint("ListTile Tapped");
                        _navigateToEditAttribute(
                            _attributesToDisplay[position], 'Edit Attribute');
                      },
                    ),
                  ],
                ),

                // onTAP for entry
                onTap: () {
                  setState(() {
                    debugPrint("One Attribute selected");
                  });

                  _navigateToEditEntry(
                      // title, value, time, comment
                      Entry(this._attributesToDisplay[position].title, '',
                          '${DateTime.now()}', ''),
                      'Add ${this._attributesToDisplay[position].title} Entry');
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
      _updateAttributeListView();
    }
  }

  // navigation for editing entry
  // function exists also in journal_route.dart but when using it from there:
  // state error
  void _navigateToEditEntry(Entry entry, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditEntry(entry, title);
      }),
    );

    if (result == true) {
      _updateEntryListView();
    }
  }

  // updateAttributeListView depends on state
  List<Attribute> attributeList; // todo check if _
  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  void _updateAttributeListView() async {
    Future<List> attributeListFuture =
        databaseHelperAttribute.getAttributeList();
    attributeList = await attributeListFuture;
    setState(() {
      this.attributeList = attributeList;
    });
  }

  List<Entry> _entryList;
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();
  // updateEntryListView depends on state
  // functions also in journal_route but using it from there breaks it
  void _updateEntryListView() async {
    Future<List<Entry>> entryListFuture = databaseHelperEntry.getEntryList();
    _entryList = await entryListFuture;
    setState(() {
      this._entryList = _entryList;
    });
  }

  // SEARCH OPERATION
  void _searchOperation() {
    createButtonVisible = true;
    debugPrint('_searchResult1 $_searchResult');
    _searchResult.clear();

    // go through all attributes one by one
    for (int i = 0; i < attributeList.length; i++) {
      // search for attributes that contain input
      if (attributeList[i]
          .title
          .toLowerCase()
          .contains(_attributeInputController.text.toLowerCase())) {
        _searchResult.add(attributeList[i]); // list of results

        // hide create button if exact search match
        if (attributeList[i]
                .title
                .toLowerCase()
                .compareTo(_attributeInputController.text.toLowerCase()) ==
            0) {
          createButtonVisible = false;
        }
      }
    }

    // show search results if user input and results available
    if (_searchResult.length != 0 ||
        _attributeInputController.text.isNotEmpty) {
      _attributesToDisplay =
          _searchResult; // show results and not all attributes

      // show all attributes if no user input
    } else {
      _attributesToDisplay = attributeList;
    }
  }

  void _save(attribute) async {
    final DatabaseHelperAttribute helper = DatabaseHelperAttribute();
    // TIMESTAMP
    attribute.date = DateFormat.yMMMd().add_Hms().format(DateTime.now());

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
    _updateAttributeListView(); // update from db
    _searchOperation(); // search after update from db

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
    showDialog(context: context, builder: (_) => alertDialog);
  }
} // class
