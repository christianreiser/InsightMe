import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

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
            _hintInImport(),
            RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Theme.of(context).primaryColorLight,
              child: Text(
                'Pick \".csv\" file to import',
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                _showAlertDialog('Status',
                    'Import started in the background. This might take a while.');
                importCSVFile();
              },
            ),
          ]),
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

// add attributes to DB if new
  void _saveAttributeToDBIfNew(_attribute) async {
    List<Attribute> _dBAttributeList =
        await databaseHelperAttribute.getAttributeList();

    //if attribute list is empty then add no matter what
    if (_dBAttributeList.isEmpty) {
      debugPrint('_dBAttributeList.isEmpty -> create new attribute');
      soca.SearchOrCreateAttributeState().saveAttribute(Attribute(_attribute));
    }

    // go through all db attributes one by one and compare
    for (int i = 0; i < _dBAttributeList.length; i++) {
      // if there is no exact match -> create attribute in DB
      if (_dBAttributeList[i]
              .title
              .toLowerCase()
              .compareTo(_attribute.toLowerCase()) !=
          0) {
        soca.SearchOrCreateAttributeState()
            .saveAttribute(Attribute(_attribute));
      } else {
        debugPrint('not creating new attribute. attributes: '
            '${_dBAttributeList[i].title.toLowerCase()} '
            'vs '
            '${_attribute.toLowerCase()}');
      }
    }
  }

  Container _hintInImport() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      color: Colors.tealAccent,
      child: Column(children: [
        Text(
          'Hint: You can import data from spreadsheets.'
          'This might be useful if you already have Excel files of own data, '
          'or want to integrate data from other services like '
          'Google Fit, Apple Health, FitBit, My Fitness Pal, Garmin, etc.\n'
          'Important: The file has to be formatted in a special way:\n'
          '  1. the values must be separated by commas\n'
          '  2. the first cell of each column must be the name of the label\n'
          '  3. the first column represents the date and time in the format: yyyy-MM-dd hh-mm-ss,\n'
          '  4. all other cells can be filled with values. Here, only numbers are allowed and if decimals are needed, the decimal-separator must be a point (.).\n'
          'It sounds complicated, but is actually intuitive when you see it.',
          textScaleFactor: 1.2,
        ),
        SizedBox(height: 10),
        Text(
          'Example',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Column(children: [Text('Date (Time)')]),
              Column(children: [Text('Calories (kcal)')]),
              Column(children: [Text('Distance (m)')]),
            ]),
            TableRow(children: [
              Text('2019-06-16'),
              Text('2900.8'),
              Text('20578.4')
            ]),
            TableRow(children: [
              Text('2019-06-17 14:00'),
              Text('2054.2'),
              Text('9182.7')
            ]),
            TableRow(children: [
              Text('2019-06-18 14:00:00'),
              Text('2203.9'),
              Text('14346.8')
            ]),
          ],
        ),
      ]),
    );
  }
}
