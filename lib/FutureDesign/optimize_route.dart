import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/widgets/chart.dart';
import 'package:insightme/Core/widgets/design.dart';
import 'package:insightme/FutureDesign/Visualize/attribute_selection.dart';
import 'package:insightme/FutureDesign/Visualize/change_notifier.dart';
import 'package:insightme/Optimize/optimize.dart';
import 'package:provider/provider.dart';

import './../globals.dart' as globals;

class OptimizeRoute extends StatefulWidget {
  @override
  _OptimizeRouteState createState() => _OptimizeRouteState();
}

class _OptimizeRouteState extends State<OptimizeRoute> {
  @override
  Widget build(BuildContext context) {
    debugPrint('entryListLength ${globals.entryListLength}');
    if (globals.entryListLength == null || globals.entryListLength == 0) {
      // todo entryListLength == 0 needed?
      globals.Global().updateEntryList();
    }

    return globals.entryListLength == null
        ? _makeEntryHint()
        : globals.entryListLength > 0
            ? _attributeSelectionAndChart()
            : _makeEntryHint(); // type lineChart
  }

  Widget _attributeSelectionAndChart() {
    return Container(
      margin: EdgeInsets.all(10),
      // ChangeNotifierProvider for state management
      child: ChangeNotifierProvider(
        create: (context) => OptimizationChangeNotifier(), // builder -> create

        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // max chart width
                children: <Widget>[
                  Text(
                    /// HEADING
                    'What do you want to correlate?',
                    style:
                        TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),
                  ),
                  Row(

                      ///dropdown
                      // start: child as close to the start of the main axis as possible
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // true/false do discriminate first and second
                        DropDown(true),
                        SizedBox(width: 15),
                        DropDown(false),
                        // true/false do discriminate first and second
                      ]),
                  Text(
                    'Highest correlations:',
                    style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  optimizeNameAndChart('Body weight', 'Calories in'),
                  optimizeNameAndChart('Happiness', 'Resting Heart Rate')
                ]),
          ]),
        ),
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

  Column optimizeNameAndChart(attributeName1, attributeName2) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      /// SEPARATOR
      greyLineSeparator(),
      SizedBox(height: 20), // needed above chart
      Text(
        '$attributeName1 & $attributeName2',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 20), // needed above chart

      /// visualize chart
      SizedBox(
        height: 250,

        /// height contstraint
        child: SizedBox.expand(
          /// for max width
          child: futureTwoAttributeAnimatedLineChart(
              attributeName1, attributeName2),
        ),
      ),

      /// statistics: correlation and confidence
      Optimize().statistics(context, 0.92, 0.09),
      SizedBox(height: 10)
    ]);
  }
}
