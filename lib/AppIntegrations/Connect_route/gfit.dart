import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';

import 'fit_kit.dart';

class GFit extends StatefulWidget {
  @override
  _GFitState createState() => _GFitState();
}

class _GFitState extends State<GFit> {
  final DatabaseHelperEntry helperEntry = // error when static
      DatabaseHelperEntry();

  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

  String result = '';
  Map<DataType, List<FitData>> results = Map();
  bool permissions;

  RangeValues _dateRange = RangeValues(1, 8);

  // ignore: deprecated_member_use
  List<DateTime> _dates = List<DateTime>();
  double _limitRange = 0;

  DateTime get _dateFrom => _dates[_dateRange.start.round()];

  DateTime get _dateTo => _dates[_dateRange.end.round()];

  int get _limit => _limitRange == 0.0 ? null : _limitRange.round();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _dates.add(null);
    for (int i = 7; i >= 0; i--) {
      _dates.add(DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i)));
    }
    _dates.add(null);

    hasPermissions();
  }

  Future<void> read() async {
    results.clear();

    try {
      permissions = await FitKit.requestPermissions(DataType.values);
      if (!permissions) {
        result = 'requestPermissions: failed';
      } else {
        for (DataType type in DataType.values) {
          try {
            results[type] = await FitKit.read(
              type,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              limit: 0,
            );
          } on UnsupportedException catch (e) {
            results[e.dataType] = [];
          }
        }

        result = 'readAll: success';
      }
    } catch (e) {
      result = 'readAll: $e';
    }

    setState(() {});
  }

  Future<void> revokePermissions() async {
    results.clear();

    try {
      await FitKit.revokePermissions();
      permissions = await FitKit.hasPermissions(DataType.values);
      result = 'revokePermissions: success';
    } catch (e) {
      result = 'revokePermissions: $e';
    }

    setState(() {});
  }

  Future<void> hasPermissions() async {
    try {
      permissions = await FitKit.hasPermissions(DataType.values);
    } catch (e) {
      result = 'hasPermissions: $e';
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items =
    results.entries.expand((entry) => [entry.key, ...entry.value]).toList();

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
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text('connect'))
        ]),
      ),
    ); // type lineChart
  }

  _generateCsvFile(List<Object> list) {
    print('$list');
    print('----------');
    List<String> csvHeaders = [];
    int headerCount = 0;

    csvHeaders.add('Date');
    for (var type in list) {
      if (type is DataType) {
        csvHeaders.add(type.toString());
        headerCount++;
      }
    }
    csvHeaders.add('UserEntered');
    print('$csvHeaders');
    print('Header count: $headerCount');

    for (var data in list) {
      //TODO
      if (data is FitData) {
        print('$data');
      }
    }
  }
}
