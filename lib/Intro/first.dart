import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import '../Database/Route/edit_entries.dart';
import '../Database/entry.dart';

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
      color: Colors.deepPurpleAccent,
      padding: EdgeInsets.all(15.0),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center, // max chart width
          children: <Widget>[
            Text(
              'Hi there,',
              style: GoogleFonts.handlee(fontSize: 40, color: Colors.white),
            ),
            Text(
              'I\'m InsightMe',
              style: GoogleFonts.handlee(fontSize: 40, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text('Your new personal journal.',
                style:
                    GoogleFonts.handlee(fontSize: 20, color: Colors.white70)),
            Text('I help to optimize your well-being and reach your goals. ',
                style:
                    GoogleFonts.handlee(fontSize: 20, color: Colors.white70)),
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
                });
                navigateToEditEntry(
                    // Entry(label, rating, ?, comment), routeTitle)
                    Entry('Productivity', '', '2', ''),
                    'Add Productivity Entry');
              },
            ),
//            Text('On a scale from one to 10, how did you feel yesterday?'
//                'How would you rate yesterdays productivity?'
//                'how is your productivity today?'
//                'how do you feel today?'
//                'Let\'s visualize that which might help your to find patterns.'
//                'I found a correlation of:'),
          ]),
    );
  }

  // navigation for editing entry
  void navigateToEditEntry(Entry entry, String title) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditEntry(entry, title);
      }),
    );
  }
}
