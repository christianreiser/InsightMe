import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/AppIntegrations/overview_route.dart';
import 'package:insightme/FutureDesign/feed_route.dart';
import 'package:insightme/Intro/first.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './../Import/import_from_json_route.dart';
import './../globals.dart' as globals;
import './data_route.dart';
import './optimize_route.dart';
import '../Statistics/Functions/computeCorrelations.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

import 'add_import_route.dart';

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
    return standardScaffold(); //welcomeOrStandardScaffold(); // todo intro back in
  }

  static const Color iconColor = Colors.black87;

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
    initializeGlobals();
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
          _ffBottomNavigationBarPlugin(),
    );
  }

  // Github repo: https://github.com/55Builds/Flutter-FFNavigationBar
  Widget _ffBottomNavigationBarPlugin() {
    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: Colors.white,
        selectedItemBorderColor: Colors.white,
        selectedItemBackgroundColor: Colors.green,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.black,
        barHeight: 75,
      ),
      selectedIndex: _selectedIndex,
      onSelectTab: (index) {
        _onItemTapped(index);
      },
      items: [
        FFNavigationBarItem(
          iconData: Icons.home_outlined,
          label: 'Home',
        ),
        FFNavigationBarItem(
          iconData: Icons.book_outlined,
          label: 'Diary',
        ),
        FFNavigationBarItem(
          iconData: Icons.timeline_outlined,
          label: 'Data',
        ),
        FFNavigationBarItem(
          iconData: Icons.widgets_outlined,
          label: 'Optimize',
        )
      ],
    );
  }

  // @deprecated, not used so far
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          // ignore: deprecated_member_use
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          // ignore: deprecated_member_use
          title: Text('Data'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          // ignore: deprecated_member_use
          title: Text('Optimize'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).primaryColorDark,
      onTap: _onItemTapped,
    );
  }

  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = <Widget>[
    FeedRoute(),
    AddImportRoute(),
    DataRoute(),
    OptimizeRoute(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('_selectedIndex= $_selectedIndex');
    });
  }

  initializeGlobals() {
    // async update local attribute list if null to load for other routes later on
    if (globals.attributeListLength == null) {
      debugPrint('call updateAttributeList');
      globals.Global().updateAttributeList();
      debugPrint('attributeListLength ${globals.attributeListLength}');
      print('globals.attributeListLength ${globals.attributeListLength}');
    }
  }
}
