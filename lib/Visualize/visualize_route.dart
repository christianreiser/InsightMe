import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './attribute_selection.dart';
import './change_notifier.dart';
import 'package:provider/provider.dart';
import 'chart.dart';
import './../globals.dart' as globals;

class Visualize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return globals.entryListLength > 0
        ? _attributeSelectionAndChart
        : _makeEntryHint(); // type lineChart
  }

  Widget _attributeSelectionAndChart() {
    return Container(
      margin: EdgeInsets.all(10),
      // ChangeNotifierProvider for state management
      child: ChangeNotifierProvider(
        create: (context) => VisualizationChangeNotifier(), // builder -> create
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
            children: <Widget>[
              Row(
                // start: child as close to the start of the main axis as possible
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropDown(true),
                  // true/false do discriminate first and second
                  //Padding(padding: EdgeInsets.all(4.0)),
                  DropDown(false),
                  // true/false do discriminate first and second
                ],
              ),
              SizedBox(height: 20.0), // spacing between dropdown and chart
              Chart(),
              //Statistics(), // todo
            ]),
      ), // type lineChart
    );
  }

  Column _makeEntryHint() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              color: Colors.tealAccent,
              child: Row(
                children: [
                  Text(
                    'You have no entries to visualize.\n '
                        'To create new entries tab here ',
                    textScaleFactor: 1.2,
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),

        SizedBox(
          height: 27, // height of button
        )
      ],
    );
  }
}
