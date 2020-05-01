//import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:flutter/material.dart';
import 'package:lifetracker4/visualize.dart';
import 'journal_route.dart';
import 'searchOrCreateAttribute.dart';

class ScaffoldRoute extends StatefulWidget {
  ScaffoldRoute({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the ScaffoldRoute object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Life Tracker"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: SpeedDial(
        //floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        //tooltip: 'Increment',
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          // first speed dial button for new entry
          SpeedDialChild(
              child: Icon(Icons.border_color),
              label: "New Entry",
              onTap: () {
                print("nav to add manually");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchOrCreateAttribute();
                }));
              }),

          // second speed dial button - no function yet
          SpeedDialChild(
              backgroundColor: Colors.grey,
              child: Icon(Icons.timer),
              label: "-not implemented-",
              onTap: () {
                print("not implemented yet");
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttributeList()),
                ); // Navigate to newManualEntry route when tapped.*/
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('Journal'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text('Visualize'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.device_hub),
            title: Text('Correlate'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColorDark,
        onTap: _onItemTapped,
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }


  // bottom navigation bar:

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    JournalRoute(),
    Visualize(),
    JournalRoute(), // TODO set Correlate() here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('_selectedIndex= $_selectedIndex');
      // navigation for editing entry
    });
  }





}
