import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import '../database_helper.dart';
import '../db_help_one_att.dart';
import '../entry.dart';


/*
* SEARCH OR CREATE NEW ATTRIBUTE FILE: TEXT INPUT
* creating another screen to add entries to Enter entries to the database.
* */

class EntryDetail extends StatefulWidget {

  final String appBarTitle;
  final Entry entry;

  EntryDetail(this.entry, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return EntryDetailState(this.entry, this.appBarTitle);
  }
}

class EntryDetailState extends State<EntryDetail> {

  //DatabaseHelper helperAttribute = DatabaseHelper();
  DbHelpOneAtt helperEntry = DbHelpOneAtt();


  String appBarTitle;
  Entry entry;

  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  EntryDetailState(this.entry, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = entry.title;
    valueController.text = entry.value;
    descriptionController.text = entry.description;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
        },


        // APPBAR

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

/*                // Attribute: text box with attribute name -> not needed due to app bar
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                  )
                ),*/


                // Value

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: valueController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Value Text Field');
                      updateValue();  // with valueController.text = entry.value
                    },
                    decoration: InputDecoration(
                        labelText: 'Value',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),


                // DESCRIPTION

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Time',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
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
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),


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
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of entry object
  void updateTitle(){
    entry.title = titleController.text;
  }

  // Update the value of entry object
  void updateValue(){
    entry.value = valueController.text;
  }

  // Update the description of entry object
  void updateDescription() {
    entry.description = descriptionController.text;
  }


  // Save data to database

  void _save() async {

    // NAVIGATE
    moveToLastScreen();

    // TIMESTAMP
    entry.date = DateFormat.yMMMd().format(DateTime.now()); // TODO default current but changeable

    // Update Operation: Update a to-do object and save it to database
    int result;
    if (entry.id != null) {  // Case 1: Update operation
      result = await helperEntry.updateEntry(entry);
    } else { // Case 2: Insert Operation
      result = await helperEntry.insertEntry(entry);
    }

    // SUCCESS FAILURE STATUS DIALOG
    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Entry Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Entry');
    }

  }


  // DELETE

  void _delete() async {

    moveToLastScreen();

    if (entry.id == null) {
      _showAlertDialog('Status', 'No Entry was deleted');
      return;
    }

    int result = await helperEntry.deleteEntry(entry.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Entry Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Entry');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}