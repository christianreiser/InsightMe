import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';

import '../Core/functions/navigation_helper.dart';
import '../Database/entry.dart';
import '../Journal/searchOrCreateAttribute.dart' as soca;
import '../strings.dart';

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
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            NavigationHelper().navigateToFutureDesign(context); // refreshes
          },
        ),
        title: Text('Import'),
      ),
      body: SingleChildScrollView(
        child: Column(
            //mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
            children: <Widget>[
              _hintInImport(),
              ElevatedButton(
                child: Text(
                  'Pick \".csv\" file to import',
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  _importCSVFile();
                  _showAlertDialog('Status',
                      'Import started in the background. This might take a while.');
                },
              ),
            ]),
      ),
    ); // type lineChart
  }

  void _importCSVFile() async {
    ///  imports data from the picked file.
    /// adds attributes if new
    /// todo importing same data twice only updates and does not add again
    // todo important: when import and already exists, then update (see below)
    //  if (entry with same timestamp AND label exists) {
    //    if (oldValue != new value) {update value}
    //    else {skip}
    //  }

    FilePickerResult result = await (FilePicker.platform.pickFiles() as FutureOr<FilePickerResult>);

    File file = File(result.files.single.path!);
    //todo userXP: handle if user does not pick file

    debugPrint('file picked');

    /* ini */
    int lineCounter = -1;
    List<String> attributeNames = [];

    DateTime? dateTimeStamp;

    // get attribute list as a sting such that searching if new requires only one db query
    List<Attribute> _dBAttributeList =
        await databaseHelperAttribute.getAttributeList();
    debugPrint('got attribute list from db');

    // open file
    Stream<List> inputStream = file.openRead();
    debugPrint('file opened');

    // iterate through rows (days). The first line are the the labels
    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {
      List column = line.split(','); // split by comma
      lineCounter++;
      debugPrint('day: $lineCounter');

      // iterate through columns
      final int columnLength = column.length;
      for (int columnCount = 0; columnCount < columnLength; columnCount++) {
        String _cellContent = column[columnCount];

        if (lineCounter > 0 && columnCount > 0) {
          // filter entries
          if ((_cellContent).length > 0) {
            // skip empty cells in csv-file

            //debugPrint('and attributeName ${attributeNames[columnCount]}');

            Entry entry = Entry(attributeNames[columnCount], _cellContent,
                '$dateTimeStamp', 'csv import'); // title, value, time, comment

            _save(entry);
//            debugPrint(
//                'called _save for entry with dateTimeStamp $dateTimeStamp and attributeName ${attributeNames[columnCount]}');
          } else {
            //debugPrint('skip empty entry cell');
          }
        }

        // get dateTime stamps
        else if (lineCounter > 0 && columnCount == 0) {
          // temporarily store dateTime
          dateTimeStamp = DateTime.parse(_cellContent);
        }

        // get attribute names
        else if (lineCounter == 0 && columnCount > 0) {
          //debugPrint('_attributeName $_cellContent');
          attributeNames.add(_cellContent); // store attribute names

          _saveAttributeToDBIfNew(_cellContent, _dBAttributeList);
          //debugPrint('call _saveAttributeToDBIfNew with $_cellContent');
        }
        // skip dateTime label
        else if (lineCounter == 0 && columnCount == 0) {
          //debugPrint('skipping dateTime label $_cellContent');
          attributeNames.add(
              _cellContent); // store such that columnCount and attributeNames match
        } else {
          debugPrint('Error unknown: $_cellContent');
        }

        // TODO userXP: feedback if import was successful
      }
    }, onDone: () {
      debugPrint('Done!');
    }, onError: (e) {
      debugPrint('ERROR! ${e.toString()}');
    });
  }

// DIALOG
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message), actions: [
      TextButton(
        child: const Text("Close"),
        onPressed: () => Navigator.pop(context),
      ),
    ]
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

// SAVE
  Future<int?> _save(entry) async {
    // Update Operation: Update a to-do object and save it to database
    int? result;
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
  Future<bool> _saveAttributeToDBIfNew(_attribute, _dBAttributeList) async {
    bool addedNewAttributeToDB;
    bool _exactMatch = false;

    // go through all db attributes one by one and compare
    //debugPrint('_exactMatch before search: $_exactMatch');
    for (int i = 0; i < _dBAttributeList.length; i++) {
      // check if there is a exact attribute match
      if (_dBAttributeList[i]
              .title
              .toLowerCase()
              .compareTo(_attribute.toLowerCase()) ==
          0) {
        _exactMatch = true;
        //debugPrint('exact match: ${_dBAttributeList[i].title} vs $_attribute');
      }
    }

    // save attribute if new
    if (_exactMatch == false) {
      //debugPrint('create new attribute: $_attribute');

      // add to faster searchable list
      // todo important: ask user if additive or average
      _dBAttributeList.add(Attribute(
          _attribute, 'imported', defaultLabelColor, defaultAggregation));

      // save to db
      // todo important performance: await and result feedback
      soca.SearchOrCreateAttributeState().saveAttribute(Attribute(
          _attribute, 'imported', defaultLabelColor, defaultAggregation));

      addedNewAttributeToDB = true;
    } else {
      //debugPrint('not creating new attribute as there is a exact match: $_attribute exists in $_dBAttributeList');
      addedNewAttributeToDB = false;
    }
    return addedNewAttributeToDB;
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
              Column(children: [Text('Date / Time)')]),
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
