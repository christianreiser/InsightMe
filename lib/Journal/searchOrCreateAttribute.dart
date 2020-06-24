import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../Database/Route/edit_attributes.dart';
import '../Database/Route/edit_entries.dart';
import '../Database/attribute.dart';
import '../Database/database_helper_attribute.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import '../scaffold_route.dart';
import 'journal_route.dart';
//import 'package:intl/intl.dart'; // DateFormat.yMMMd().add_Hms().format(DateTime.now())

// Define SearchOrCreateAttribute widget.
class SearchOrCreateAttribute extends StatefulWidget {
  @override
  SearchOrCreateAttributeState createState() => SearchOrCreateAttributeState();
}

// Define a corresponding State class, which holds data related to the Form.
class SearchOrCreateAttributeState extends State<SearchOrCreateAttribute> {
  List _searchResult = new List();
  var _attributeInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_attributeList == null) {
      _attributeList = List<Attribute>();
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
                    TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'create new label',
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

              // Save button search create attribute
              Container(
                child: RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text(
                    'Create',
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    setState(() {
                      debugPrint("Create button clicked");
                    });
                    _navigateToEditAttribute( // TODO don't navigate but create directly
                        // _attributeInputController.text is the Label
                        // name which is automatically put in in add
                        // attribute filed.
                        // 'Add Attribute' is the App Bar name
                        Attribute(_attributeInputController.text, ''),
                        'Add Attribute');
                  },
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
    return Flexible(
      // pull to refresh
      child: RefreshIndicator(
          onRefresh: () async {
            _updateAttributeListView();
          },

          // if typed into search field only show matches
          child: _searchResult.length != 0 ||
                  _attributeInputController.text.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResult.length,
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
                                this._searchResult[position]),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        // TITLE
                        title: Text(
                          _searchResult[position].toString(),
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
                                    this._attributeList[position],
                                    'Edit Attribute');
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
                              Entry(this._attributeList[position].title, '',
                                  '${DateTime.now()}', ''),
                              'Add ${this._attributeList[position].title} Entry');
                        },
                      ),
                    );
                  },
                )
              : ListView.builder( // TODO don't copy and paste
                  itemCount: _countAttribute,
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
                                this._attributeList[position].title),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        // TITLE
                        title: Text(
                          this._attributeList[position].title,
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
                                    this._attributeList[position],
                                    'Edit Attribute');
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
                              Entry(this._attributeList[position].title, '',
                                  '${DateTime.now()}', ''),
                              'Add ${this._attributeList[position].title} Entry');
                        },
                      ),
                    );
                  },
                )),
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
  int _countAttribute = 0;
  List<Attribute> _attributeList;
  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  void _updateAttributeListView() {
    final Future<Database> dbFuture =
        databaseHelperAttribute.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Attribute>> attributeListFuture =
          databaseHelperAttribute.getAttributeList();
      attributeListFuture.then((attributeList) {
        setState(() {
          this._attributeList = attributeList;
          this._countAttribute = attributeList.length;
        });
      });
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
  // _searchResult = remaining tiles
  // searchText = user input = _attributeInputController.text
  // _list = _attributeList.title
  void _searchOperation() { // TODO _?
    _searchResult.clear(); // should be names of tiles
    //if (_isSearching != null) {
    for (int i = 0; i < _attributeList.length; i++) {
      String data = _attributeList[i]
          .title; // data will be compared against input (search-text)
      if (data
          .toLowerCase()
          .contains(_attributeInputController.text.toLowerCase())) {
        _searchResult.add(data); // list of results
      }
    }
    //}
  }
} // class
