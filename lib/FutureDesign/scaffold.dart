import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Intro/first.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './../Database/correlations.dart';
import './../Import/import_from_json_route.dart';
import './../Journal/searchOrCreateAttribute.dart';
import './../strings.dart' as strings;
import './data_route.dart';
import './home_route.dart';
import './optimize_route.dart';
//import 'package:starflut/starflut.dart';

enum Choice {
  exportDailySummaries,
  computeCorrelations,
  importFromCSV,
  appIntegrations,
  futureDesign,
  deleteAllData
}

class ScaffoldRouteDesign extends StatefulWidget {
  ScaffoldRouteDesign();

  @override
  _ScaffoldRouteDesignState createState() => _ScaffoldRouteDesignState();
}

class _ScaffoldRouteDesignState extends State<ScaffoldRouteDesign> {
  @override
  Widget build(BuildContext context) {
    return standardScaffold(); //welcomeOrStandardScaffold(); // todo intro back in
  }

  FutureBuilder welcomeOrStandardScaffold() {
    /*
    * decides if standard scaffold or welcome screen should be shown
    * Logic:
    * Welcome if:
    *   1. hideWelcome == null (as not shown before)
    *   2. hideWelcome == false
    * StandardScaffold if:
    *   1. problems with connection state (i.e. none, waiting)
    *   2. hide == true
    * */
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
              return snapshot.data.getBool("hideWelcome") == null
                  ? IntroRoute()
                  : snapshot.data.getBool("hideWelcome") == false
                      ? IntroRoute()
                      : standardScaffold();
            } else {
              return Text('error: ${snapshot.error}');
            }
        }
      },
    );
  }

  Scaffold standardScaffold() {
    /*
    * standard scaffold with bottom navigation bar and floating action button
    * */
    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.appTitle,
        ),
        automaticallyImplyLeading: false, // hide back button
        actions: <Widget>[
          // action button
          PopupMenuButton<Choice>(
            onSelected: (Choice result) {
              if (result == Choice.exportDailySummaries) {
//                exportDailySummaries();// todo permission handler iOS privacy
              } else if (result == Choice.computeCorrelations) {
                ComputeCorrelations().computeCorrelations();
              } else if (result == Choice.importFromCSV) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Import()),
                );
              } else if (result == Choice.appIntegrations) {
                // todo AppIntegrations:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => AppIntegrations()),
                // );
              } else if (result == Choice.deleteAllData) {
                // todo deleteAllData
                // DatabaseHelperEntry().deleteDb();
                // DatabaseHelperAttribute().deleteDb();
              }

              setState(() {
                debugPrint('result $result');
                Choice _selection = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
              PopupMenuItem<Choice>(
                value: Choice.exportDailySummaries,
                child: Text('Export daily summaries'),
              ),
              PopupMenuItem<Choice>(
                value: Choice.computeCorrelations,
                child: Text('Compute correlations'),
              ),
              PopupMenuItem<Choice>(
                value: Choice.importFromCSV,
                child: Text('Import data from file'),
              ),
              PopupMenuItem<Choice>(
                value: Choice.appIntegrations,
                child: Text('Other app integrations'),
              ),
             PopupMenuItem<Choice>(
               value: Choice.deleteAllData,
               child: Text('Delete all data'),
             ),
            ],
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // use below when more then one floatingActionButton and remove top block
      floatingActionButton: _floatingActionButton(), //_speedDial(),

      // bottom navigation bar
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  // SPEED DIAL IF MORE THAN ONE FAB (TOO MANY CLICKS :( )

  // Widget _speedDial() {
  //   /*
  //   * floating action button with speed dial to add entries or import data
  //   */
  //   return SpeedDial(
  //     animatedIcon: AnimatedIcons.add_event,
  //     children: [
  //       // NEW ENTRY
  //       SpeedDialChild(
  //           child: Icon(Icons.border_color),
  //           label: "New Entry",
  //           onTap: () {
  //             print("nav to add manually");
  //             Navigator.of(context).push(
  //               PageRouteBuilder(
  //                 opaque: false, // set to false
  //                 pageBuilder: (_, __, ___) => Container(
  //                   color: Colors.black.withOpacity(.7),
  //                   child: Padding(
  //                     padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
  //                     child: SearchOrCreateAttribute(),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //
  //       // import from CSV
  //       SpeedDialChild(
  //           backgroundColor: Colors.grey,
  //           child: Icon(Icons.input),
  //           label: "Import Data",
  //           onTap: () {
  //             debugPrint("pressed Import Data");
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => Import()),
  //             ); // Navigate to newManualEntry route when tapped.
  //           }),
  //
  //       // connect service
//        SpeedDialChild(
//            backgroundColor: Colors.grey,
//            child: Icon(Icons.input),
//            label: "Connect with Service (e.g. Apple Health, FitBit)",
//            onTap: () {
//              print("DropDown");
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(builder: (context) => Tmp()),
////                ); // Navigate to newManualEntry route when tapped.
//            }),
//       ],
//     );
//   }

  Widget _floatingActionButton() {
    /*
    * floating action button to add entries
    */
    return FloatingActionButton(
      child: Icon(Icons.add),//Icons.border_color
      //label: "New Entry",
      onPressed: () {
        print("nav to add manually");
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => Container(
              color: Colors.black.withOpacity(.7),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                child: SearchOrCreateAttribute(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar() {
    /*
    * bottom navigation bar to changes tabs
    */
    return BottomNavigationBar(
      unselectedIconTheme: IconThemeData(color: Colors.grey),

      //showUnselectedLabels: true, // TODO fix theme/color
      //unselectedLabelStyle: TextStyle(color: Colors.black),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          title: Text('Data'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          title: Text('Optimize'),
        ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.local_hospital),
//            title: Text('COVID-19'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.arrow_downward),
//            title: Text('Intro'),
//          ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).primaryColorDark,

      onTap: _onItemTapped,
    );
  }

  // bottom navigation bar:
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeRoute(),
    DataRoute(),
    OptimizeRoute(),
    //Covid19(), //IntroRoute(),
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