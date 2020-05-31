import 'package:flutter/material.dart';


class IntroRoute extends StatefulWidget {
  IntroRoute({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IntroRouteState createState() => _IntroRouteState();
}

class _IntroRouteState extends State<IntroRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome to InsightMe, use me as your personal journal '
            'and I help to optimize your well-being and reach your goals. And'
            ' don\'t worry about privacy, all data is stored on your device, '
            'only.'
            'Let me show how I can help you:'
            'How how was your productivity yesterday?'
            'How was your mood yesterday yesterday?'
            'how is your productivity today?'
            'how do you feel today?'
            'let\'s visualize that'
            'I found a correlation of:'),
      ),




    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

}
