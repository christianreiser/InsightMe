import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/widgets/chart.dart';

import 'Core/functions/navigation_helper.dart';
import 'Core/widgets/entryHint.dart';
import 'globals.dart' as globals;

class DataRoute extends StatefulWidget {
  @override
  _DataRouteState createState() => _DataRouteState();
}

class _DataRouteState extends State<DataRoute> {
  @override
  Widget build(BuildContext context) {
    if (globals.entryListLength == null || globals.entryListLength == 0) {
      globals.Global().updateEntryList();
      globals.Global().updateAttributeList();
    }

    return FutureBuilder(
      future: globals.Global().updateAttributeList(),
      builder: (context, snapshot) {
        // chart data arrived && data found
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return globals.entryListLength == 0
              ? entryHint() // type lineChart;
              : globals.entryListLength == 1
                  ? Column(
                      children: [
                        Expanded(child: (_dataListView(snapshot.data))),
                        entryHint()
                      ],
                    )
                  : globals.entryListLength > 1
                      ? _dataListView(snapshot.data)
                      : Text('?');
        }

        // chart data arrived but no data found
        else if (snapshot.connectionState == ConnectionState.done &&
            (globals.attributeList == null || snapshot.data == null)) {
          return Text('No data found for this label');

          // else: i.e. data didn't arrive
        } else {
          return CircularProgressIndicator(); // when Future doesn't get data
        } // snapshot is current state of future
      },
    );
  }

  Widget _dataListView(attributeList) {
    return ListView.builder(
      itemCount: globals.attributeListLength,
      itemBuilder: (BuildContext context, int position) {
        return _oneAttributeNameAndChart(
            attributeList[position].title, context);
      },
    );
  }

  Widget _oneAttributeNameAndChart(attributeName, context) {
    // creates chart widget of one Attribute with name as heading
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // max chart width
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 16),
                    Text(
                      attributeName,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    NavigationHelper().navigateToJournalRoute(
                        context, attributeName); // refreshes
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: futureOneAttributeScatterPlot(attributeName),
            )
          ]),
    );
  }
}
