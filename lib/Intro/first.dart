import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Database/Route/edit_entries.dart';
import '../Database/entry.dart';
import '../navigation_helper.dart';

class IntroRoute extends StatefulWidget {
  IntroRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IntroRouteState createState() => _IntroRouteState();
}

class _IntroRouteState extends State<IntroRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // max chart width
        children: [
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                // max chart width
                children: <Widget>[
                  Text(
                    'Hi there,',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  Text(
                    'I\'m InsightMe',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your new personal journal.',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  Text(
                    'I help to optimize your well-being and reach your goals. ',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'WHAT CAN YOU DO?',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("What can you do? button clicked");
                            hideWelcomeFunction(); // set flag to hide Welcome screen from now on
                          });
                          navigateToEditEntry(
                            // Entry(label, rating, ?, comment), routeTitle)
                            Entry('Productivity', '', '2', ''),
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlatButton(
                        onPressed: () {
                          NavigationHelper().navigateToScaffoldRoute(context);
                        },
                        child: Row(
                          children: [Text('Skip Intro')],
                        ),
                      ),
                    ],
                  ),
//            Text('On a scale from one to 10, how did you feel yesterday?'
//                'How would you rate yesterdays productivity?'
//                'how is your productivity today?'
//                'how do you feel today?'
//                'Let\'s visualize that which might help your to find patterns.'
//                'I found a correlation of:'),
                ]),
          ),
        ],
      ),
    );
  }

  void hideWelcomeFunction() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    // set value
    prefs.setBool('hideWelcome', true);
  }

  // navigation for editing entry
  void navigateToEditEntry(Entry entry) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditEntry(entry);
      }),
    );
  }
}
