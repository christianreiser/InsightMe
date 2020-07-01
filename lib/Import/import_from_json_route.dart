import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// for import csv
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';
import '../Database/entry.dart';
import '../Journal/searchOrCreateAttribute.dart' as soca;

class Import extends StatefulWidget {
  @override
  _ImportState createState() => _ImportState();
}

class _ImportState extends State<Import> {
  final DatabaseHelperEntry helperEntry = // error when static
      DatabaseHelperEntry();

//  int importSuccessCounter = 0;
//  int importFailureCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
        children: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text(
              'Pick \"import file\"',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              importCSVFile();
            },
          ),
        ],
      ),
    ); // type lineChart
  }

  // IMPORT
  void importCSVFile() async {
    int lineCounter = 0;
    List<String> attributeNames = [];
    DateTime dateTimeStamp;

    // file picker
    final File file = new File(await FilePicker.getFilePath());

    Stream<List> inputStream = file.openRead();

    // iterate through lines
    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {
      List column = line.split(','); // split by comma

      debugPrint('lineCounter: $lineCounter');

      // iterate through columns
      for (int columnCount = 0; columnCount < column.length; columnCount++) {
        // get attribute names
        String _attributeName = column[columnCount];
        if (lineCounter == 0) {
          attributeNames.add(_attributeName);
          _saveAttributeToDBIfNew(_attributeName);
        } else {
          // skip empty cells in csv-file
          if ((_attributeName).length > 0) {
            // get DateTime which is in first column
            if (columnCount == 0) {
              dateTimeStamp = DateTime.parse(column[0]);

              // add entry to db
            } else {
              // title, value, time, comment
              Entry entry = Entry(attributeNames[columnCount], _attributeName,
                  '$dateTimeStamp', 'csv import');

              _save(entry);
            }
          }
        }
      }

      lineCounter++;

      // TODO feedback if import was successful
    }, onDone: () {
      _showAlertDialog('Status', 'Import started in the background');
      print('File is now closed!');
    }, onError: (e) {
      print(e.toString());
    });
  }

  // DIALOG
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  // SAVE
  Future<int> _save(entry) async {
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
    // Success
    if (result != 0) {
      //importSuccessCounter++;
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Entry. Title: ${entry.title}');
      //importFailureCounter++;
    }
    return result;
  }

  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

// add attributes to DB if new
  void _saveAttributeToDBIfNew(_attribute) async {
    debugPrint('_attribute $_attribute');
    List<Attribute> _dBAttributeList =
        await databaseHelperAttribute.getAttributeList();

    debugPrint('_dBAttributeList $_dBAttributeList');

    //if attribute list is empty then add no matter what
    if (_dBAttributeList.isEmpty) {
      soca.SearchOrCreateAttributeState()
          .saveAttribute(Attribute(_attribute));
    }

    // go through all db attributes one by one and compare
    for (int i = 0; i < _dBAttributeList.length; i++) {
      // if there is no exact match -> create attribute in DB
      if (_dBAttributeList[i]
              .title
              .toLowerCase()
              .compareTo(_attribute.toLowerCase()) !=
          0) {
        debugPrint('create new attribute!');

      } else {
        debugPrint(
            'not creating new attribute. attributes: '
                '${_dBAttributeList[i].title.toLowerCase()} '
                'vs '
                '${_attribute.toLowerCase()}');
      }
    }

    // todo whats that below?
//    // show search results if user input and results available
//    if (_searchResult.length != 0 ||
//        _attributeInputController.text.isNotEmpty) {
//      _attributesToDisplay =
//          _searchResult; // show results and not all attributes
//
//      // show all attributes if no user input
//    } else {
//      _attributesToDisplay = attributeList;
//    }
  }
}
