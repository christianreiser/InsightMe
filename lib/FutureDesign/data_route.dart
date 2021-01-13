import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/widgets/chart.dart';

import '../globals.dart' as globals;
import '../navigation_helper.dart';

class DataRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('globals.attributeList: ${globals.attributeList}');

    return ListView.builder(
      //shrinkWrap: true, /// todo true is way more expensive. why used it in journal and searchOrCreate?
      itemCount: globals.attributeListLength,
      itemBuilder: (BuildContext context, int position) {
        return oneAttributeNameAndChart(
            globals.attributeList[position].title, context);
      },
    );
  }

  Widget oneAttributeNameAndChart(attributeName, context) {
    // creates chart widget of one Attribute with name as heading
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // max chart width
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  attributeName,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    NavigationHelper()
                        .navigateToScaffoldRoute(context); // refreshes
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: futureAnimatedLineChart(attributeName),
            )
          ]),
    );
  }
}
