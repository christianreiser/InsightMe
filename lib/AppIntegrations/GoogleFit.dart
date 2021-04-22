import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';

import '../navigation_helper.dart';
import 'package:health/health.dart';

class GoogleFitIntegration extends StatefulWidget {
  final DatabaseHelperEntry helperEntry = // error when static
      DatabaseHelperEntry();
  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  @override
  _GoogleFitState createState() => _GoogleFitState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _GoogleFitState extends State<GoogleFitIntegration> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    /// Get everything from midnight until now
    DateTime startDate = DateTime(2020, 11, 07, 0, 0, 0);
    DateTime endDate = DateTime(2025, 11, 07, 23, 59, 59);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      _healthDataList.forEach((x) {
        print("Data point: $x");
        steps += x.value.round();
      });

      print("Steps: $steps");

      /// Update the UI to display the results
      setState(() {
        _state =
        _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

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
          ElevatedButton(
            onPressed: () => {},
            child: Text('connect GFit'),
            //other properties
          ),
          Text(
            'output text',
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
