import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:lifetracker4/Visualize/visualize_route.dart';
import 'Intro/first.dart';
import 'Jounal/journal_route.dart';
import 'Jounal/searchOrCreateAttribute.dart';

class ScaffoldRoute extends StatefulWidget {
  ScaffoldRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InsightMe"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

        // use this block for only one floatingActionButton
        floatingActionButton: FloatingActionButton(
          onPressed: () {
                print("nav to add manually");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SearchOrCreateAttribute();
                  }),
                );          },
          child: Icon(Icons.border_color),
        ),

        // use below when more then one floatingActionButton and remove top block
//      floatingActionButton: SpeedDial(
//        animatedIcon: AnimatedIcons.menu_close,
//        children: [
//          // first speed dial button for new entry
//          SpeedDialChild(
//              child: Icon(Icons.border_color),
//              label: "New Entry",
//              onTap: () {
//                print("nav to add manually");
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) {
//                    return SearchOrCreateAttribute();
//                  }),
//                );
//              }),
//
//          // second speed dial button - no function yet
//          SpeedDialChild(
//              backgroundColor: Colors.grey,
//              child: Icon(Icons.timer),
//              label: "-DropDown-",
////              onTap: () {
////                print("DropDown");
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(builder: (context) => DropDown(defaultAttribute)),
////                ); // Navigate to newManualEntry route when tapped.
////              }
//              ),
//        ],
//      ),

      // bottom navigation bar
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
//          BottomNavigationBarItem(
//            icon: Icon(Icons.device_hub),
//            title: Text('Correlate'),
//          ),
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
    IntroRoute(), // TODO set Correlate() here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('_selectedIndex= $_selectedIndex');
      // navigation for editing entry
    });
  }
}
