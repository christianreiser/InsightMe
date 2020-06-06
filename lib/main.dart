import 'package:flutter/material.dart';

import 'scaffold_route.dart';

void main() => runApp(LifeTrackerApp());

class LifeTrackerApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _LifeTrackerAppState createState() => _LifeTrackerAppState();
}

class _LifeTrackerAppState extends State<LifeTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'insightMe',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal,
        accentColor: Colors.tealAccent,
        //bottomNavigationBarTheme: Theme.of(context).primaryColor,
        backgroundColor: Colors.grey[300]


      ),
      home: ScaffoldRoute(),
    );
  }
}
