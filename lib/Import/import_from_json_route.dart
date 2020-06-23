import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// for import csv
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:insightme/Database/database_helper_entry.dart';
import '../Database/entry.dart';

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

      // iterate through columns
      for (int columnCount = 0; columnCount < column.length; columnCount++) {
        // get attribute names
        if (lineCounter == 0) {
          attributeNames.add(column[columnCount]);
        } else {
          // skip empty cells in csv-file
          if ((column[columnCount]).length > 0) {
            // get DateTime which is in first column
            if (columnCount == 0) {
              dateTimeStamp = DateTime.parse(column[0]);

              // add entry to db
            } else {
              // title, value, time, comment
              Entry entry = Entry(attributeNames[columnCount],
                  column[columnCount], '$dateTimeStamp', 'csv import');

              _save(entry);
            }
          }
        }
      }

      lineCounter += 1;
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
}
