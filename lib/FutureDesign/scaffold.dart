import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/AppIntegrations/overview_route.dart';
import 'package:insightme/Intro/first.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './../Import/import_from_json_route.dart';
import './../Journal/searchOrCreateAttribute.dart';
import './../globals.dart' as globals;
import './../strings.dart' as strings;
import './data_route.dart';
import './home_route.dart';
import './optimize_route.dart';
import '../Statistics/Functions/computeCorrelations.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

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
      appBar: AppBar(
        title: Text(
          strings.appTitle,
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          _popupMenu(),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: _floatingActionButton(),
      bottomNavigationBar:
          _ffBottomNavigationBarPlugin(),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        print("nav to add manually");
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
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
          iconData: Icons.add,
          label: 'Add',
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

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeRoute(),
    DataRoute(),
    OptimizeRoute(),
    IntroRoute(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('_selectedIndex= $_selectedIndex');
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
          /// todo AppIntegrations:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppIntegrationsOverview()),
          );
        } else if (result == Choice.deleteAllData) {
          // todo deleteAllData
          // DatabaseHelperEntry().deleteDb();
          // DatabaseHelperAttribute().deleteDb();
        } else if (result == Choice.tmpFunction) {
          //tmpFunction();
          // DatabaseHelperEntry().deleteDb();
          // DatabaseHelperAttribute().deleteDb();
        }

        setState(() {
          debugPrint('result $result');
          Choice _selection = result; // check if needed
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
          value: Choice.appIntegrations,
          child: Row(
            children: [
              Icon(
                Icons.exit_to_app,
                color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Other app integrations'),
            ],
          ),
        ),
        PopupMenuItem<Choice>(
          value: Choice.exportDailySummaries,
          child: Row(
            children: [
              Icon(
                Icons.file_upload,
                color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Export daily summaries'),
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
        PopupMenuItem<Choice>(
          value: Choice.deleteAllData,
          child: Row(
            children: [
              Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Delete all data'),
            ],
          ),
        ),
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
