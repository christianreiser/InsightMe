import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:insightme/Core/functions/misc.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';

import '../../Database/entry.dart';

class Health extends StatefulWidget {
  @override
  _HealthState createState() => _HealthState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _HealthState extends State<Health> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {
    /// Get everything from midnight until now
    DateTime startDate = DateTime(2020, 10, 01, 0, 0, 0);
    DateTime endDate = DateTime(2025, 11, 07, 23, 59, 59);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BASAL_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.ELECTRODERMAL_ACTIVITY,
      HealthDataType.HEART_RATE,
      HealthDataType.HEIGHT,
      HealthDataType.RESTING_HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.WAIST_CIRCUMFERENCE,
      HealthDataType.WALKING_HEART_RATE,
      HealthDataType.WEIGHT,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.FLIGHTS_CLIMBED,
      HealthDataType.MOVE_MINUTES,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.MINDFULNESS,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.WATER,
      HealthDataType.HIGH_HEART_RATE_EVENT,
      HealthDataType.LOW_HEART_RATE_EVENT,
      HealthDataType.IRREGULAR_HEART_RATE_EVENT,
      HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);
    print('accessWasGranted: $accessWasGranted');

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
      print("healthData: $_healthDataList");
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// get attribute title list
      List<String> attributeTitleList = List.filled(types.length + 1, null);
      attributeTitleList[0] = 'date';
      for (int attributeCount = 0;
      attributeCount < types.length;
      attributeCount++) {
        attributeTitleList[attributeCount + 1] =
            (types[attributeCount]).toString();
      }
      List<List<dynamic>> importList = [];
      importList.add(attributeTitleList);

      // get attribute list as a sting such that searching if new requires only one db query
      DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();
      List<Attribute> _dBAttributeList =
      await databaseHelperAttribute.getAttributeList();
      debugPrint('got attribute list from db');

      /// Print the results
      _healthDataList.forEach((_healthData) {
        final date = _healthData.dateFrom;

        List<dynamic> rowToAdd = List.filled(types.length + 1, null);
        rowToAdd[0] = date;

        String label = "";
        switch (_healthData.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            label = "active energy burned";
            break;
          case HealthDataType.BASAL_ENERGY_BURNED:
            label = "basal energy burned";
            break;
          case HealthDataType.BLOOD_GLUCOSE:
            label = "blood glucose";
            break;
          case HealthDataType.BLOOD_OXYGEN:
            label = "blood oxygen";
            break;
          case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
            label = "blood pressure diastolic";
            break;
          case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
            label = "blood pressure systolic";
            break;
          case HealthDataType.BODY_FAT_PERCENTAGE:
            label = "body fat percentage";
            break;
          case HealthDataType.BODY_MASS_INDEX:
            label = "body mass index";
            break;
          case HealthDataType.BODY_TEMPERATURE:
            label = "body temperature";
            break;
          case HealthDataType.ELECTRODERMAL_ACTIVITY:
            label = "electrodermal activity";
            break;
          case HealthDataType.HEART_RATE:
            label = "heart rate";
            break;
          case HealthDataType.HEIGHT:
            label = "height";
            break;
          case HealthDataType.RESTING_HEART_RATE:
            label = "resting heart rate";
            break;
          case HealthDataType.STEPS:
            label = "steps";
            break;
          case HealthDataType.WAIST_CIRCUMFERENCE:
            label = "waist circumference";
            break;
          case HealthDataType.WALKING_HEART_RATE:
            label = "walking heart rate";
            break;
          case HealthDataType.WEIGHT:
            label = "weight";
            break;
          case HealthDataType.DISTANCE_WALKING_RUNNING:
            label = "distance walking running";
            break;
          case HealthDataType.FLIGHTS_CLIMBED:
            label = "flights climbed";
            break;
          case HealthDataType.MOVE_MINUTES:
            label = "move minutes";
            break;
          case HealthDataType.DISTANCE_DELTA:
            label = "distance delta";
            break;
          case HealthDataType.MINDFULNESS:
            label = "mindfulness";
            break;
          case HealthDataType.SLEEP_IN_BED:
            label = "sleep in bed";
            break;
          case HealthDataType.SLEEP_ASLEEP:
            label = "sleep asleep";
            break;
          case HealthDataType.SLEEP_AWAKE:
            label = "sleep awake";
            break;
          case HealthDataType.WATER:
            label = "water";
            break;
          case HealthDataType.HIGH_HEART_RATE_EVENT:
            label = "high heart rate event";
            break;
          case HealthDataType.LOW_HEART_RATE_EVENT:
            label = "low heart rate event";
            break;
          case HealthDataType.IRREGULAR_HEART_RATE_EVENT:
            label = "irregular heart rate event";
            break;
          case HealthDataType.HEART_RATE_VARIABILITY_SDNN:
            label = "heart rate variability sdnn";
            break;
          default:
            label = "n.A.";
            break;
        }

        /// save Attribute To DB If its New
        saveAttributeToDBIfNew(label, _dBAttributeList);

        /// save to DB
        Entry entry = Entry(
            label, _healthData.value.toString(),
            _healthData.dateFrom.toString(), 'Google API import'); // title, value, time, comment
        save(entry, context);
      });

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

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Text('Press the download button to fetch data');
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {
                fetchData();
              },
            )
          ],
        ),
        body: Center(
          child: _content(),
        ));
  }
}
