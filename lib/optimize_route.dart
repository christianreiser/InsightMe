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
import 'Statistics/Functions/readCorrelation.dart';
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
          optimizeListView(),
          // oneOptimizeNameAndChart('productive_min', 'mood'),
          //'Happiness', 'Resting Heart Rate'
          //oneOptimizeNameAndChart('Body weight', 'Calories in'),
        ]),
      ),
    );
  }

  Widget optimizeListView() {
    return Consumer<OptimizationChangeNotifier>(
        builder: (context, schedule, _) {
      var att1 = schedule.selectedAttribute1;
      return FutureBuilder(
          future: readCorrelationCoefficientsOfOneAttribute(att1),
          builder: (context, snapshot) {
            // chart data arrived && data found
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              Map<String, double> coeffsMap = snapshot.data;
              return SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: coeffsMap.length,
                  itemBuilder: (BuildContext context, int position) {
                    final String att2 =
                        coeffsMap.entries.toList()[position].key;
                    final double corrCoeff =
                        coeffsMap.entries.toList()[position].value;

                    return oneOptimizeNameAndChart(att1, att2, corrCoeff);
                  },
                ),
              );
            }

            // chart data arrived but no data found
            else if (snapshot.connectionState == ConnectionState.done &&
                (snapshot.data == null)) {
              return Text('No data found for this label');

              // else: i.e. data didn't arrive
            } else {
              return CircularProgressIndicator(); // when Future doesn't get data
            } // snapshot is current state of future
          });
    });
  }

  Widget oneOptimizeNameAndChart(att1, att2, corrCoeff) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          /// visualize chart
          SizedBox(
            height: 350, // todo check if good

            /// height constraint
            child: SizedBox.expand(
              /// for max width
              child: futureTwoAttributeScatterPlot(att2, att1),
            ),
          ),

          /// statistics: correlation and confidence
          statistics(context, corrCoeff, 0.02) // todo pvalue not hardcoded
        ]),
      ),
      greyLineSeparator(),
    ]);
  }
}
