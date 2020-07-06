import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:insightme/Covid19/covid19_route.dart';
import 'package:insightme/Intro/first.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Visualize/visualize_route.dart';
import 'Import/import_from_json_route.dart';
import 'Journal/journal_route.dart';
import 'Journal/searchOrCreateAttribute.dart';
import './strings.dart' as strings;
import 'Recommend/recommendation_route.dart';


class ScaffoldRoute extends StatefulWidget {
  ScaffoldRoute();


  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return standardScaffold();
          case ConnectionState.waiting:
            return standardScaffold();
          default:
            if (!snapshot.hasError) {
        //@ToDo("Return a welcome screen")
        return snapshot.data.getBool("hideWelcome") != null
        ? standardScaffold()
            : IntroRoute();
        } else {
        return Text('error: ${snapshot.error}');
        }
      }
      },
    );
  }

  Scaffold standardScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.appTitle,
        ),
        leading: null,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // use below when more then one floatingActionButton and remove top block
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        children: [
          // NEW ENTRY
          SpeedDialChild(
              child: Icon(Icons.border_color),
              label: "New Entry",
              onTap: () {
                print("nav to add manually");
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false, // set to false
                    pageBuilder: (_, __, ___) => Container(
                      color: Colors.black.withOpacity(.6),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                        child: SearchOrCreateAttribute(),
                      ),
                    ),
                  ),
                );
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) {
//                    return SearchOrCreateAttribute();
//                  }),
//                );
              }),

          // import from CSV
          SpeedDialChild(
              backgroundColor: Colors.grey,
              child: Icon(Icons.input),
              label: "Import",
              onTap: () {
                print("DropDown");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Import()),
                ); // Navigate to newManualEntry route when tapped.
              }),

          // connect service
          SpeedDialChild(
              backgroundColor: Colors.grey,
              child: Icon(Icons.input),
              label: "Connect with Service (e.g. Apple Health, FitBit)",
              onTap: () {
                print("DropDown");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Import()),
                ); // Navigate to newManualEntry route when tapped.
              }),
        ],
      ),

      // bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        //showUnselectedLabels: true, // TODO fix theme/color
        //unselectedLabelStyle: TextStyle(color: Colors.black),
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
            icon: Icon(Icons.widgets),
            title: Text('Recommend'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('COVID-19'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            title: Text('Intro'),
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
    Recommend(),
    Covid19(), //IntroRoute(),
    IntroRoute(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('_selectedIndex= $_selectedIndex');
      // navigation for editing entry
    });
  }
}
