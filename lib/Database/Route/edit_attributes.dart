import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:insightme/navigation_helper.dart';

import './../../globals.dart' as globals;
import './../entry.dart';
import '../attribute.dart';
import '../database_helper_attribute.dart';
import '../database_helper_entry.dart';

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
  TextEditingController noteController = TextEditingController();
  Color currentColor;
  bool aggregationIsAdditive;

  EditAttributeState(this.attribute,
      this.oldAttributeTitle); //todo performance: oldAttributeTitle not a state

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = attribute.title;
    noteController.text = attribute.note;
    debugPrint('attribute.color ${attribute.color}');
    currentColor = Color(attribute.color);
    if (attribute.aggregation == 1) {
      aggregationIsAdditive = true;
    } else if (attribute.aggregation == 0) {
      aggregationIsAdditive = false;
    } else {
      debugPrint('ERROR: attribute.aggregation = ${attribute.aggregation} '
          'but must be 0 or 1');
    }

    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        title: Text('Edit Attribute'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationHelper()
                  .navigateToSearchOrCreateAttributeRoute(context);
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              // TITLE
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
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

            // Aggregation switch
            aggregationSwitch(), // todo design: back in

            Padding(
              // Note
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: noteController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in note Text Field');
                  updateNote();
                },
                decoration: InputDecoration(
                    labelText: 'Note',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // color picker
            colorPicker(context),

            Padding(
              /*
              * Buttons
              * */
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    // SAVE BUTTON
                    child: ElevatedButton(
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
                  Expanded(
                    // DELETE BUTTON
                    child: ElevatedButton(
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        debugPrint("Delete button clicked");
                        _showAlertDialogWithDelete(
                            'Delete?',
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

  Widget aggregationSwitch() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(children: [
        SizedBox(width: 10),
        Text('Average'),
        Switch(
          value: aggregationIsAdditive,
          onChanged: (value) {
            setState(() {
              aggregationIsAdditive = value;

              if (aggregationIsAdditive) {
                attribute.aggregation = 1;
              } else {
                attribute.aggregation = 0;
              }
              debugPrint(
                  'aggregationIsAdditive switched to $aggregationIsAdditive');
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
        Text('Additive'),
        TextButton(
          /* info note for additive/average */
          // to reduce height of relationship info? button
          child: Icon(Icons.info, color: Colors.grey),
          onPressed: () {
            debugPrint('info pressed');
            _showAggregationInfo();
          },
        )
      ]),
    );
  }

  void _showAggregationInfo() {
    String title = 'Aggregation';
    String message =
        'Should multiple entries during one day be aggregated for a '
        'daily summary by addition or averaging?\n\n'
        'Examples\n'
        'Addition: Suppose you drank two times one liter of water during the day.'
        ' Then the daily summary should show the sum which are two liters. '
        'The average which would be one liter does not make sense.\n'
        'Average: Suppose you rated your mood twice during the day. '
        'Once with a 4 and once with a 6. '
        'Then the daily summary should show the average which is 5. '
        'The sum which would be 10 does not make sense.';
    AlertDialog alertDialog = AlertDialog(
      actions: [
        TextButton(
          child: Text('Got it'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget colorPicker(BuildContext context) {
    debugPrint('currentColor $currentColor');
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select a color'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: currentColor,
                  onColorChanged: changeColor,
                  availableColors: [
                    Colors.white,
                    Colors.greenAccent,
                    Colors.green,
                    Colors.lightGreenAccent,
                    Colors.lime,
                    Colors.limeAccent,
                    Colors.yellowAccent,
                    Colors.yellow,
                    Colors.amberAccent,
                    Colors.orange,
                    Colors.deepOrangeAccent,
                    Colors.deepOrange,
                    Colors.redAccent,
                    Colors.red,
                    Colors.purpleAccent,
                    Colors.purple,
                    Colors.deepPurple,
                    Colors.deepPurpleAccent,
                    Colors.indigoAccent,
                    Colors.blueAccent,
                    Colors.blue,
                    Colors.lightBlue,
                    Colors.lightBlueAccent,
                    Colors.cyanAccent,
                    Colors.tealAccent,
                    Colors.brown
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Looks good'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text(
        'Color',
        textScaleFactor: 1.5,
      ),
    );
  }

  void changeColor(Color color) => setState(() {
        debugPrint('currentColor.toString(): ${currentColor.toString()}');
        currentColor = color;
        debugPrint(
            'int color: ${int.parse(currentColor.toString().split('(0x')[1].split(')')[0], radix: 16)}');
        attribute.color = int.parse(
            currentColor.toString().split('(0x')[1].split(')')[0],
            radix: 16);
      });

  // Update the title of attribute object
  void updateTitle() {
    attribute.title = titleController.text;
  }

  // Update the note of attribute object
  void updateNote() {
    attribute.note = noteController.text;
  }

  // Update the color of attribute object
//  void updateColor() {
//    attribute.color = '$currentColor';
//  }

  // Update the aggregation of attribute object with bool to int conversion
//  void updateAggregation() {
//    if (aggregationIsAdditive) {
//      attribute.aggregation = 1;
//    } else {
//      attribute.aggregation = 0;
//    }
//  }

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
      globals.attributeList = await databaseHelperAttribute.getAttributeList();
      globals.attributeListLength = globals.attributeList.length;

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
