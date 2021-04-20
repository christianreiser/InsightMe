import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';

import '../navigation_helper.dart';

class GoogleFitIntegration extends StatelessWidget {
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
            ]),
      ),
    ); // type lineChart
  }

  Container _hintInImport() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODO',
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
