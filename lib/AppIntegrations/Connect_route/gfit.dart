import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';

import '../fit_kit.dart';

class GFit extends StatelessWidget {
  final DatabaseHelperEntry helperEntry = // error when static
      DatabaseHelperEntry();

  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {},
        ),
        title: Text('Google Fit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image(image: AssetImage('./assets/icon/logo_googlefit.png')),
          SizedBox(height: 50),
          Text(
            'How to connect',
            textScaleFactor: 2,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 10),
          Text(
            'Select your Google account and tap Allow to let InsightMe view your data',
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FitKitGHub(),
                  ), //HealthGHub()),
                );
              },
              icon: const Icon(Icons.add),
              label: Text('connect'))
        ]),
      ),
    ); // type lineChart
  }
}
