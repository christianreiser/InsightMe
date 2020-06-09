import 'package:flutter/material.dart';
import '../database_helper_entry.dart';
import '../entry.dart';

class EditEntry extends StatefulWidget {
  final String appBarTitle;
  final Entry entry;

  EditEntry(this.entry, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return EditEntryState(this.entry, this.appBarTitle);
  }
}

class EditEntryState extends State<EditEntry> {
  //DatabaseHelperAttribute helperAttribute = DatabaseHelperAttribute();
  DatabaseHelperEntry helperEntry = DatabaseHelperEntry();

  String appBarTitle;
  Entry entry;

  //TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  EditEntryState(this.entry, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    //titleController.text = entry.title;
    valueController.text = entry.value;
    commentController.text = entry.comment;
    dateController.text = entry.date;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () {
//                moveToLastScreen();
//              }),
      ),
      body: Builder(
        builder: (scaffoldContext) => Padding(
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
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: valueController,
                  style: textStyle,
                  validator: _validateValue,
                  autovalidate: true,
                  onChanged: (value) {
                    debugPrint('Something changed in Value Text Field');
                    updateValue(); // with valueController.text = entry.value
                  },
                  decoration: InputDecoration(
                    labelText: 'Value',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              // COMMENT
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: commentController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Comment Text Field');
                    updateComment();
                  },
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              // DATE TIME
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: dateController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint(
                        'Something changed in date Text Field. entry.date: ${entry.date}, dateController.text: ${dateController.text}');
                    updateDate();
                  },
                  decoration: InputDecoration(
                    labelText: 'Time [yyyy-MM-dd hh:mm]',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
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
                            _save(scaffoldContext);
                          });
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
      ),
    );
  }

  String _validateValue(String valueController) {
    if (valueController.isEmpty) {
      // The form is empty
      return "Enter value";
    }
    // This is just a regular expression for email addresses
    //final String p = "[0-9\.]{1,256}";
    // TODO RegExp input is all thats forbidden, better to input allowed characters: "[0-9\.]{1,256}"
    final RegExp regExp = RegExp(
        r'[¹²£¥¢©®™¿¡÷¦¬×§¶°$—⅛¼⅓⅔⅜⁴⅝ⁿ⅞—–¯≠≈‰„“«»”×ʼ‹‡†›÷¡¿±³€½¾{},!@#<>?":_`~;[\]\\|=+)(*&^%\s-]');
    Iterable iterableRegExp = regExp.allMatches(valueController);
    //debugPrint('iterableRegExp $iterableRegExp');

    if (iterableRegExp.every((n) => n == false)) {
      debugPrint('iterableRegExp true $iterableRegExp');
      // So, the value is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Invalid: Only digits (0-9) and point (.) as decimal are allowed.';
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

/*  // Update the title of entry object
  void updateTitle(){
    entry.title = titleController.text;
  }*/

  // Update the value of entry object
  void updateValue() {
    entry.value = valueController.text;
  }

  // Update the comment of entry object
  void updateComment() {
    entry.comment = commentController.text;
  }

  // Update the comment of entry object
  void updateDate() {
    entry.date = dateController.text;
  }

  // Save data to database

  void _save(scaffoldContext) async {
    // NAVIGATE
    moveToLastScreen();

    // Update Operation: Update a to-do object and save it to database
    int result;
    if (entry.id != null) {
      // Case 1: Update operation
      result = await helperEntry.updateEntry(entry);
    } else {
      // Case 2: Insert Operation
      result = await helperEntry.insertEntry(entry);
    }

    // SUCCESS FAILURE STATUS DIALOG
    if (result != 0) {
      // Success
      // TODO idk why it is not working. S.th. with context
      _showSnackBar('Entry Saved Successfully', scaffoldContext);
    } else {
      // Failure
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
    showDialog(context: context, builder: (_) => alertDialog);
  }

  // TODO idk why it is not working
  void _showSnackBar(String message, scaffoldContext) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
