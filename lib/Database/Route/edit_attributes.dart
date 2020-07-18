import 'package:flutter/material.dart';
import 'package:insightme/navigation_helper.dart';
import '../attribute.dart';
import '../database_helper_attribute.dart';
import '../database_helper_entry.dart';
import './../entry.dart';
import './../../globals.dart' as globals;


/*
* SEARCH OR CREATE NEW ATTRIBUTE FILE: TEXT INPUT
* creating another route to add attributes to Enter attributes to the database.
* */

class EditAttribute extends StatefulWidget {
  final String oldAttributeTitle;
  final Attribute attribute;

  EditAttribute(this.attribute, this.oldAttributeTitle);

  @override
  State<StatefulWidget> createState() {
    return EditAttributeState(this.attribute, this.oldAttributeTitle);
  }
}

class EditAttributeState extends State<EditAttribute> {
  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  Attribute attribute;
  final String oldAttributeTitle;

  TextEditingController titleController = TextEditingController();

  EditAttributeState(this.attribute,
      this.oldAttributeTitle); //todo oldAttributeTitle not a state

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = attribute.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attribute'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationHelper().navigateToSearchOrCreateAttributeRoute(context);
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // TITLE

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                //controller: TextEditingController(text: attributeInputController.text),
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Name of Label',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),

              // SAVE BUTTON

              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        debugPrint("Save button clicked");
                        _save();
                      },
                    ),
                  ),

                  Container(
                    width: 5.0,
                  ),

                  // DELETE BUTTON

                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        debugPrint("Delete button clicked");
                        _showAlertDialogWithDelete('Delete?',
                            'This Label AND all it\'s entries will be deleted, '
                                'forever.');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the title of attribute object
  void updateTitle() {
    attribute.title = titleController.text;
  }

  // Save data to database

  void _save() async {
    // Update Operation: Update a attribute object and save it to database
    int _result;
    List<int> _resultList;
    if (attribute.id != null) {
      // Case 1: Update operation
      _resultList = await databaseHelperEntry.renameEntry(
          attribute.title, oldAttributeTitle);
      _result = await databaseHelperAttribute.updateAttribute(attribute);

      // if result == 0 then s.th. went wrong
      _resultList.add(_result);
      if (_resultList.contains(0)) {
        _result = 0;
      }
    } else {
      // Case 2: Insert Operation
      _result = await databaseHelperAttribute.insertAttribute(attribute);
    }

    // navigate and rebuild
    NavigationHelper().navigateToSearchOrCreateAttributeRoute(context);

    // SUCCESS FAILURE STATUS DIALOG
    if (_result != 0) {
      // Success
      _showAlertDialog('Status', 'Attribute Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Attribute');
    }
  }

  // DELETE

  void _delete() async {
    List<int> _resultList = [];

    // found no attribute to delete

    if (attribute.id == null) {
      _showAlertDialog('Status', 'No Attribute was deleted');
      return;

      // found attribute to delete
    } else {
      // Deletion of entries
      List<Entry> filteredEntryList =
          await databaseHelperEntry.getFilteredEntryList(oldAttributeTitle);
      for (int i = 0; i < filteredEntryList.length; i++) {
        _resultList.add(
          await databaseHelperEntry.deleteEntry(filteredEntryList[i].id),
        );
      }

      // Deletion in Attribute DB
      _resultList.add(
        await databaseHelperAttribute.deleteAttribute(attribute.id),
      );

      // update gloabls // needed otherwise not working
      globals.Global().attributeList = await databaseHelperAttribute.getAttributeList();
      globals.Global().attributeListLength = globals.Global().attributeList.length;

      // Navigate back and update
      NavigationHelper().navigateToSearchOrCreateAttributeRoute(context);

      // Success Failure evaluation
      if (_resultList.contains(0)) {
        _showAlertDialog('Status', 'Error occurred while Deleting Attribute');
      } else {
        _showAlertDialog('Status', 'Attribute Deleted Successfully');
      }
    }
  }

  void _showAlertDialogWithDelete(String title, String message) {
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
            _delete();
            Navigator.of(context).pop();
          },
        ),
      ],
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }


}
