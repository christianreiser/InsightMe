import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// for import csv
import 'dart:io';
import 'dart:async';
import 'dart:convert';


class Import extends StatefulWidget {
  @override
  _ImportState createState() => _ImportState();
}

class _ImportState extends State<Import> {
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
              'Import \"import_file.csv\"',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              setState(() {
                debugPrint("Create button clicked");
                importCSVFile();
                _showAlertDialog('Import status','status');
              });
            },
          ),
        ],
      ),
    ); // type lineChart
  }

  String importCSVFile() {
    String successString;

    final File file = new File("~/Downloads/import_file.csv");

    Stream<List> inputStream = file.openRead();

    inputStream
        .transform(utf8.decoder)       // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {        // Process results.

      List row = line.split(','); // split by comma

      String id = row[0];
      String symbol = row[1];
      String open = row[2];
      String low = row[3];
      String high = row[4];
      String close = row[5];
      String volume = row[6];
      String exchange = row[7];
      String timestamp = row[8];
      String date = row[9];

      debugPrint('$id, $symbol, $open');

    },
        onDone: () { print('File is now closed.'); },
        onError: (e) { print(e.toString()); });


    return successString;
  }


  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

