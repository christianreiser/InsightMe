import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart'; // for date time formatting

import '../../Core/functions/navigation_helper.dart';
import '../../globals.dart' as globals;
import '../database_helper_entry.dart';
import '../entry.dart';

class EditEntry extends StatefulWidget {
  final Entry entry;
  final bool thisIsANewEntry; // in contrast to edit existing entry

  EditEntry(this.entry, this.thisIsANewEntry);

  @override
  State<StatefulWidget> createState() {
    return EditEntryState(this.entry, this.thisIsANewEntry);
  }
}

class EditEntryState extends State<EditEntry> {
  final DatabaseHelperEntry databaseHelperEntry = // error when static
      DatabaseHelperEntry();

  Entry entry;
  bool thisIsANewEntry;
  bool _validValue;

  TextEditingController valueController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  EditEntryState(this.entry, this.thisIsANewEntry);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    //titleController.text = entry.title;
    valueController.text = entry.value;
    commentController.text = entry.comment;
    dateController.text = entry.date;
    DateTime _dateTime = DateTime.parse(entry.date); // ini datePicker value

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${entry.title} entry'),
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () {
//                Navigator.pop(context, true);
//              }),
      ),
      body: Builder(
        builder: (scaffoldContext) => Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(children: <Widget>[
/*                // Attribute: text box with attribute name -> not needed due to app bar
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: titleController,
                    )
                  ),*/

            SizedBox(height: 5),

            // Value
            TextFormField(
              keyboardType: TextInputType.number,
              controller: valueController,
              style: textStyle,
              validator: _validateValue,
              autovalidateMode: AutovalidateMode.always,
              onChanged: (value) {
                debugPrint('Something changed in Value Text Field');
                debugPrint('_validateValue: $_validateValue');
                _updateValue(); // with valueController.text = entry.value
              },
              decoration: InputDecoration(
                labelText: 'Value',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),

            SizedBox(height: 15),

            // COMMENT
            TextField(
              controller: commentController,
              style: textStyle,
              onChanged: (value) {
                debugPrint('Something changed in Comment Text Field');
                _updateComment();
              },
              decoration: InputDecoration(
                labelText: 'Comment',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),

            SizedBox(height: 15),

            // DATE TIME
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime.now(), onChanged: (_dateTime) {
                    debugPrint('Text Field change: entry.date: ${entry.date}, '
                        'dateController.text: ${dateController.text}');
                    debugPrint('change $_dateTime');
                  }, onConfirm: (dateTime) {
                    _updateDate(dateTime);
                    debugPrint('confirm $dateTime');
                    setState(() {
                      _dateTime = dateTime;
                    });
                  }, currentTime: _dateTime, locale: LocaleType.en);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat.yMMMMd('en_US').add_Hm().format(_dateTime),
                    style: textStyle,
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),

            // SAVE BUTTON
            Row(children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Text(
                    'Save',
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    setState(() {
                      debugPrint(
                          "Save button clicked. _validValue= $_validValue");
                      _save(scaffoldContext);
                    });
                  },
                ),
              ),

              SizedBox(width: 15),

              // DELETE BUTTON
              // hide delete if entry doesn't exist
              thisIsANewEntry == false
                  ? Expanded(
                      child: ElevatedButton(
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
                    )
                  : Container(),
            ]),

            SizedBox(height: 15),

            _hintInEditEntry(),
          ]),
        ),
      ),
    );
  }

  Container _hintInEditEntry() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      color: Colors.tealAccent,
      child: Text(
        'Hint: Set a value for your rating. '
        'You can choose your own scale/unit and don\'t have to tell the app,'
        ' but it must be consistent with all future entries for this label. '
        'For example, you can: \n'
        '  - rate your feeling or symptoms and decide a scale from 1 to 10,\n'
        '  - enter medication-dosage in milligrams,\n'
        '  - track Yes/No with 1 and 0.\n'
        'The comment is an optional note for you.',
        textScaleFactor: 1.2,
      ),
    );
  }

  // validate value user input for allowed characters
  String _validateValue(String valueController) {
    _validValue = false;
    if (valueController.isEmpty) {
      // The form is empty
      return "Enter value";
    }
    // This is just a regular expression for email addresses
    //final String p = "[0-9\.]{1,256}";
    // TODO minor: RegExp input is all that's forbidden, better to input allowed characters: "[0-9\.]{1,256}"
    final RegExp regExp = RegExp(
        r'[üäöÜÄÖqwertyuiopasdfghjklzxcvbnm¹²£¥¢©®™¿¡÷¦¬×§¶°$—⅛¼⅓⅔⅜⁴⅝ⁿ⅞—¯≠≈‰„“«»”×ʼ‹‡†›÷¡¿±³€½¾{},!@#<>?":_`~;[\]\\|=+)(*&^%\s-]');
    Iterable iterableRegExp = regExp.allMatches(valueController);

    if (iterableRegExp.every((n) => n == false)) {
      debugPrint('iterableRegExp true $iterableRegExp');
      // value is valid
      _validValue = true;
      return null;
    } else {
      _validValue = false;
    }
    debugPrint('_validValueCHRI: $_validValue');
    // Message to user if the pattern didn't match the regex above.
    return 'Invalid: Only digits (0-9) and point (.) as decimal are allowed.';
  }

  // Update the value of entry object
  void _updateValue() {
    entry.value = valueController.text;
  }

  // Update the comment of entry object
  void _updateComment() {
    entry.comment = commentController.text;
  }

  // Update the comment of entry object
  void _updateDate(_dateTime) {
    entry.date = _dateTime.toString(); //dateController.text;
  }

  // Save data to database

  void _save(scaffoldContext) async {
    if (_validValue) {
      // don't save if character not allowed
      int result;

      // NAVIGATE
      if (thisIsANewEntry == true) {
        Navigator.pop(context, true);
        result = await databaseHelperEntry.insertEntry(entry);
      } else {
        result = await databaseHelperEntry.updateEntry(entry);
        NavigationHelper().navigateToJournalRoute(context, entry.title);
      }

      // SUCCESS FAILURE STATUS DIALOG
      if (result != 0) {
        // Success
        _showSnackBar('Entry Saved Successfully', scaffoldContext);
        globals.Global().updateEntryList();

      } else {
        // Failure
        _showAlertDialog('Status', 'Problem Saving Entry');
      }
    } else {
      debugPrint('Value not valid!');
    }
  }

  // DELETE
  void _delete() async {
    if (entry.id == null) {
      _showAlertDialog('Status', 'No Entry was deleted');
      return;
    }

    // navigate and rebuild
    NavigationHelper().navigateToJournalRoute(context, entry.title);

    int result = await databaseHelperEntry.deleteEntry(entry.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Entry Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occurred while Deleting Entry');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _showSnackBar(String message, scaffoldContext) {
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
