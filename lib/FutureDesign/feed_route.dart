import 'package:flutter/cupertino.dart';

class FeedRoute extends StatefulWidget {
  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0), //EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Morning, \nChristoph', style: TextStyle(fontSize: 35)),
                ],
              ),
            ],
          )
          /*
          Column(
            children: <Widget>[
              Text('Deliver features faster'),
              Text('Craft beautiful UIs')
            ],
          )
           */
        ],
      ),
    );
  }
}
