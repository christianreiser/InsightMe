import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Covid19/covid19_route.dart';
import './Visualize/visualize_route.dart';
import 'Intro/first.dart';
import 'Journal/journal_route.dart';
import 'Journal/searchOrCreateAttribute.dart';
import './strings.dart' as strings;

class ScaffoldRoute extends StatefulWidget {
  ScaffoldRoute();

  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle,),
        leading: null,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // use this block for only one floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("nav to add manually");
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false, // set to false
              pageBuilder: (_, __, ___) => Container(
                color: Colors.black.withOpacity(.6),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20,25,20,20),

                  child: SearchOrCreateAttribute(),
                ),
              ),
            ),
          );
        },
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
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('COVID-19'),
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
    Covid19(),//IntroRoute(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('_selectedIndex= $_selectedIndex');
      // navigation for editing entry
    });
  }
}
