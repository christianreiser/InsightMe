import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health/health.dart';
import 'package:insightme/Core/functions/misc.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';
import 'package:path_provider/path_provider.dart';

import '../../Database/entry.dart';

class GFit extends StatefulWidget {
  @override
  _GFitState createState() => _GFitState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _GFitState extends State<GFit> {
  final DatabaseHelperEntry helperEntry = // error when static
  DatabaseHelperEntry();

  static DatabaseHelperAttribute databaseHelperAttribute =
  DatabaseHelperAttribute();

  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _dateToLogFile(String filename) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final path = '${appDocDir.path}/$filename';
    final file = File(path);
    print("_log file saved to: $path");

    DateTime currentDate = DateTime.now();
    DateTime dateTwoWeeksAgo = currentDate.subtract(const Duration(days: 14));
    await file.writeAsString(currentDate.toString() + "\n" + dateTwoWeeksAgo.toString());
  }

  void _readDateFromLogFile(String filename) async {
    String content;
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final file = File('${appDocDir.path}/$filename');
      content = await file.readAsString();
    } catch (e) {
      print("Error reading the file.");
    }

    print("_date from log file: $content");
  }

  Future fetchData() async {
    /// Get everything from midnight until now
    /*
    DateTime startDate = DateTime.now();
    DateTime endDate = new DateTime(startDate.year, startDate.month, startDate.day - 14);
    */

    DateTime startDate = DateTime(2020, 10, 01, 0, 0, 0);
    DateTime endDate = DateTime(2025, 10, 02, 23, 59, 59);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      /*
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.BODY_TEMPERATURE,
       */
      // HealthDataType.HEART_RATE,
      // HealthDataType.HEIGHT,
      // HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      /*
      HealthDataType.MOVE_MINUTES,
      HealthDataType.WATER
       */
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);
    print('accessWasGranted: $accessWasGranted');

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// add all the new data points
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
          case HealthDataType.HEART_RATE:
            label = "heart rate";
            break;
          case HealthDataType.HEIGHT:
            label = "height";
            break;
          case HealthDataType.STEPS:
            label = "steps";
            break;
          case HealthDataType.WEIGHT:
            label = "weight";
            break;
          case HealthDataType.MOVE_MINUTES:
            label = "move minutes";
            break;
          case HealthDataType.WATER:
            label = "water";
            break;
          default:
            label = "n.A.";
            break;
        }

        /// save Attribute To DB If its New
        saveAttributeToDBIfNew(label, _dBAttributeList);

        /// save to DB
        final DatabaseHelperEntry helperEntry = // error when static
        DatabaseHelperEntry();

        Entry entry = Entry(
            label, _healthData.value.toString(),
            _healthData.dateFrom.toString(), 'Google API import'); // title, value, time, comment
        // save(entry, context);
        helperEntry.saveOrUpdateEntry(entry, context);
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
              heroTag: "btn1",
              onPressed: () {
                print('GFit connect button pressed');
                fetchData();
                final cron = Cron();
                cron.schedule(Schedule.parse('* * * * *'), () async {
                  print('Cron triggered GFit pull at: ${DateTime.now()}');
                  fetchData();
                });

              },
              icon: const Icon(Icons.add),
              label: Text('connect')),
          SizedBox(height: 20),
          FloatingActionButton.extended(
              heroTag: "btn2",
              onPressed: () {
                //TODO: save log file
                _dateToLogFile("lastPulledGFitDate.txt");
              },
              icon: const Icon(Icons.add),
              label: Text('Save date data (DEBUG)')),
          SizedBox(height: 20),
          FloatingActionButton.extended(
              onPressed: () {
                //TODO: read log file
                _readDateFromLogFile("lastPulledGFitDate.txt");
              },
              icon: const Icon(Icons.add),
              label: Text('Read date data (DEBUG)'))
        ]),
      ),
    ); // type lineChart
  }
}
