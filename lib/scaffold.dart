import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/AppIntegrations/overview_route.dart';
import 'package:insightme/Onboarding/first.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Import/import_from_json_route.dart';
import 'Journal/searchOrCreateAttribute.dart';
import 'Statistics/Functions/computeCorrelations.dart';
import 'data_route.dart';
import 'globals.dart' as globals;
import 'optimize_route.dart';
import 'strings.dart' as strings;
//import 'package:starflut/starflut.dart';

enum Choice {
  exportDailySummaries,
  computeCorrelations,
  importFromCSV,
  appIntegrations,
  futureDesign,
  deleteAllData,
  tmpFunction
}

class ScaffoldRouteDesign extends StatefulWidget {
  ScaffoldRouteDesign();

  @override
  _ScaffoldRouteDesignState createState() => _ScaffoldRouteDesignState();
}

class _ScaffoldRouteDesignState extends State<ScaffoldRouteDesign> {
  @override
  Widget build(BuildContext context) {
    return _standardScaffold(); //welcomeOrStandardScaffold(); // todo Onboarding back in
  }

  static const Color iconColor = Colors.black87;



  FutureBuilder _welcomeOrStandardScaffold() {
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
            return _standardScaffold();
          case ConnectionState.waiting:
            return _standardScaffold();
          default:
            if (!snapshot.hasError) {
              //@ToDo("Return a welcome screen")
              return snapshot.data.getBool("hideWelcome") == null
                  ? OnboardingRoute()
                  : snapshot.data.getBool("hideWelcome") == false
                      ? OnboardingRoute()
                      : _standardScaffold();
            } else {
              return Text('error: ${snapshot.error}');
            }
        }
      },
    );
  }

  Scaffold _standardScaffold() {
    /*
    * standard scaffold with bottom navigation bar and floating action button
    * */
    _initializeGlobals();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.appTitle,
        ),
        automaticallyImplyLeading: false, // hide back button
        actions: <Widget>[
          /// three dots on the top right corner for settings
          _popupMenu(),
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
      child: Icon(Icons.add), //Icons.border_color
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
    /// bottom navigation
    return BottomNavigationBar(
      unselectedIconTheme: IconThemeData(color: Colors.grey),

      //showUnselectedLabels: true, // TODO fix theme/color
      //unselectedLabelStyle: TextStyle(color: Colors.black),
      items: const <BottomNavigationBarItem>[
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.view_list),
        //   label: 'Home',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Data',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          label: 'Optimize',
        ),

//          BottomNavigationBarItem(
//            icon: Icon(Icons.arrow_downward),
//            label: 'Onboarding',
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
    // HomeRoute(), // TODO feature
    DataRoute(),
    OptimizeRoute(),
    //OnboardingRoute(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('_selectedIndex= $_selectedIndex');
      // navigation for editing entry
    });
  }

  Widget _popupMenu() {
    return PopupMenuButton<Choice>(
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppIntegrationsOverview()),
          );
        } else if (result == Choice.deleteAllData) {
          //todo deleteAllData
          // DatabaseHelperEntry().deleteDb();
          // DatabaseHelperAttribute().deleteDb();
        } else if (result == Choice.tmpFunction) {
          _tmpFunction();
          // DatabaseHelperEntry().deleteDb();
          // DatabaseHelperAttribute().deleteDb();
        }

        setState(() {
          debugPrint('result $result');
          Choice _selection = result; // Todo check if needed
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
        PopupMenuItem<Choice>(
          value: Choice.computeCorrelations,
          child: Row(
            children: [
              Icon(
                Icons.compare_arrows,
                color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Compute correlations'),
            ],
          ),
        ),
        PopupMenuItem<Choice>(
          value: Choice.importFromCSV,
          child: Row(
            children: [
              Icon(
                Icons.file_download,
                color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Import data from file'),
            ],
          ),
        ),
        // PopupMenuItem<Choice>(
        //   value: Choice.appIntegrations,
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.exit_to_app,
        //         color: iconColor,
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Text('Other app integrations'),
        //     ],
        //   ),
        // ),
        // PopupMenuItem<Choice>(
        //   value: Choice.exportDailySummaries,
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.file_upload,
        //         color: iconColor,
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Text('Export daily summaries'),
        //     ],
        //   ),
        // ),
        // PopupMenuItem<Choice>(
        //   value: Choice.deleteAllData,
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.delete_forever,
        //         color: Colors.red,
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Text('Delete all data'),
        //     ],
        //   ),
        // ),
        PopupMenuItem<Choice>(
          value: Choice.tmpFunction,
          child: Row(
            children: [
              Icon(
                Icons.directions_run,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Text('tmpFunction'),
            ],
          ),
        ),
      ],
    );

  }

  _initializeGlobals() {
    // async update local attribute list if null to load for other routes later on
    if (globals.attributeListLength == null) {
      debugPrint('call updateAttributeList');
      globals.Global().updateAttributeList();
      debugPrint('attributeListLength ${globals.attributeListLength}');
      print('globals.attributeListLength ${globals.attributeListLength}');
    }
  }

  _tmpFunction() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TmpRoute()),
    // );

  }
}
