import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    //createExampleAttributes();
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
                    // TODO GoogleFonts.handlee instead of TextStyle leads to Error:
                    //  google_fonts was unable to load font Handlee-Regular because
                    //  the following exception occurred:
                    //  I/flutter (10551): Exception: Failed to load font with url:
                    //  https://fonts.gstatic.com/s/a/10f3e83c9fcbcd234b04cde9d1f8001a0255ea2bf3be48eb39ba87a44ff27fac.ttf
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
                            setHideWelcomeToTrue(); // set flag to hide Welcome screen from now on
                          });
                          //NavigationHelper().navigateTo
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlatButton(
                        onPressed: () {
                          NavigationHelper().navigateToScaffoldRoute(context);
                          setHideWelcomeToTrue(); // set flag to hide Welcome screen from now on
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

  void setHideWelcomeToTrue() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setBool('hideWelcome', true);
  }

  void setFirstAppRunToFalse() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setBool('firstAppRun', false);
  }

//  void createExampleAttributes() async {
//    // Update Operation: Update a attribute object and save it to database
//    final prefs = await SharedPreferences.getInstance();
//    // Try reading data from the counter key. If it doesn't exist, return true.
//
//    final firstAppRun = prefs.getBool('firstAppRun') ?? true;
//
//    if (firstAppRun) {
//      int _result;
//      List<Attribute> attributeList = [
//        Attribute('Mood'),
//        Attribute('Headache'),
//        Attribute('Milk')
//      ];
//      List<int> _resultList;
//      for (int i = 0; i < attributeList.length; i++) {
//        Attribute attribute = attributeList[i];
//
//        // Insert Operation
//        _result = await DatabaseHelperAttribute().insertAttribute(attribute);
//      }
//    }
//  }
}
