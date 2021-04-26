import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedRoute extends StatefulWidget {
  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute> with SingleTickerProviderStateMixin{
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

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
              Spacer(),
              Image.asset('assets/weather/haze.png', height: 75, width: 75),
              Text('23°', style: TextStyle(fontSize: 60))
            ],
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey, indent: 20, endIndent: 20),
          SizedBox(height: 10),
          Container(
            decoration: new BoxDecoration(color: Colors.transparent),
            child: new TabBar(
              controller: _controller,
              indicatorColor: Colors.grey,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                new Tab(
                  text: 'Today',
                ),
                new Tab(
                  text: 'Sports',
                ),
                new Tab(
                  text: 'Health',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
