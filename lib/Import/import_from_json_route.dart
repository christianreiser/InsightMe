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

import 'package:path_provider/path_provider.dart';

class Import extends StatefulWidget {
  @override
  _ImportState createState() => _ImportState();
}

class _ImportState extends State<Import> {
  final DatabaseHelperEntry helperEntry = // error when static
      DatabaseHelperEntry();

  String file; // todo

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
          FutureBuilder(
              future: _getDir(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    file != null) {
                  return Text(file.toString());
                } else {
                  debugPrint(
                      'snapshot.connectionState ${snapshot.connectionState}; file: $file');
                  return CircularProgressIndicator(); // when Future doesn't get data
                }
              }),
          RaisedButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text(
              'Import \"import_file.csv\"',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              setState(() {
                debugPrint("Import button clicked");
                importCSVFile();
                //debugPrint('file: $file');
//                String exFilesDir = getExternalFilesDir();
//                debugPrint('getExternalFilesDir(): $exFilesDir')
                _showAlertDialog('Import status', 'status');
              });
            },
          ),
        ],
      ),
    ); // type lineChart
  }

  String importCSVFile() {
    String successString;
    int lineCounter = 0;
    int importCounter = 0;
    List<String> attributeNames = [];
    DateTime dateTimeStamp;

    final File file = new File("/storage/emulated/0/Download/import_file.csv");

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
            } else {
              // add entry to db


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
      print('File is now closed!');
    }, onError: (e) {
      print(e.toString());
    });

    return successString;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void listDir() {
    // Get the system temp directory.
    var systemTempDir = Directory.current;

    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    systemTempDir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      print(entity.path);
    });
  }

  Future<String> _getDir() async {
    file = await FilePicker.getFilePath();
    return file;
  }

  void _save(entry) async {
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
      // TODO better feedback with result
      _showAlertDialog('Status', 'Entry Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Entry');
    }
  }
}
