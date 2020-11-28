import 'package:flutter/material.dart';

import './strings.dart' as strings;
import 'scaffold_route.dart';

void main() => runApp(LifeTrackerApp());

class LifeTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appTitle,
      theme: ThemeData(

        //brightness: Brightness.dark,
         primarySwatch: Colors.teal,
        //primaryColor: Colors.teal,
        accentColor: Colors.tealAccent,
        //bottomNavigationBarTheme: Theme.of(context).primaryColor,
        //backgroundColor: Colors.grey[300]


      ),
      home: ScaffoldRoute(),
    );
  }
}
