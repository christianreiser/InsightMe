/// everything that's on the optimize route
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/widgets/chart.dart';
import 'package:insightme/Core/widgets/design.dart';
import 'package:insightme/Statistics/Widgets/statistics.dart';
import 'package:insightme/Visualize/attribute_selection.dart';
import 'package:insightme/Visualize/change_notifier.dart';
import 'package:provider/provider.dart';

import 'Core/widgets/entryHint.dart';
import 'globals.dart' as globals;

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
        ? entryHint()
        : globals.entryListLength > 0
            ? _attributeSelectionAndChart()
            : entryHint(); // type lineChart
  }

  Widget _attributeSelectionAndChart() {
    return ChangeNotifierProvider(
      create: (context) => OptimizationChangeNotifier(), // builder -> create

      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                ]),
          ),
          optimizeNameAndChart(), //'Happiness', 'Resting Heart Rate'
          //optimizeNameAndChart('Body weight', 'Calories in'),
        ]),
      ),
    );
  }



  Widget optimizeNameAndChart() {
    return Consumer<OptimizationChangeNotifier>(
      builder: (context, schedule, _) => Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            /// SEPARATOR
            Text(
              '${schedule.selectedAttribute1} & ${schedule.selectedAttribute2}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20), // needed above chart

            /// visualize chart
            SizedBox(
              height: 250,

              /// height constraint
              child: SizedBox.expand(
                /// for max width
                child: futureTwoAttributeAnimatedLineChart(
                    schedule.selectedAttribute1, schedule.selectedAttribute2),
              ),
            ),

            /// statistics: correlation and confidence
            futureStatistics(
                schedule.selectedAttribute1, schedule.selectedAttribute2)
          ]),
        ),
        greyLineSeparator(),
      ]),
    );
  }
}
