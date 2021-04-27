import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedRoute extends StatefulWidget {
  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List items = getDummyList();

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  static List getDummyList() {
    List list = List.generate(5, (i) {
      return "Item ${i + 1}";
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
      //EdgeInsets.all(10),
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
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: Container(
                    height: 100.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5)
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("https://i.pinimg.com/originals/3d/8b/df/3d8bdfb670978ee2ee15028cc31c37aa.jpg")
                              )
                          ),
                        ),
                        Container(
                          height: 100.0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                        color: Colors.lightGreen
                                    ),
                                    child: Text("Health", textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Container(
                                    width: 200,
                                    child: Text("To increase your energy level try "
                                        "eating less high temperature processed food.", style: TextStyle(
                                        fontSize: 11
                                    ),),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 130),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_up_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_down_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.share_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    height: 100.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5)
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("https://i.pinimg.com/564x/b4/a2/6e/b4a26e607557faf37579859188efb2f7.jpg")
                              )
                          ),
                        ),
                        Container(
                          height: 100.0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Container(
                                    width: 75,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                        color: Colors.lightBlue
                                    ),
                                    child: Text("Productivity", textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Container(
                                    width: 200,
                                    child: Text("Try working from home. Your productivity correlates with home-office.", style: TextStyle(
                                        fontSize: 11
                                    ),),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 130),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_up_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_down_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.share_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    height: 100.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5)
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("https://i.pinimg.com/564x/01/1a/d2/011ad28a5991aa4b5f43c0bc95d9630b.jpg")
                              )
                          ),
                        ),
                        Container(
                          height: 100.0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                        color: Colors.redAccent
                                    ),
                                    child: Text("Sports", textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Container(
                                    width: 200,
                                    child: Text("Try carbs before running. Carbs correlate with running performance.", style: TextStyle(
                                        fontSize: 11
                                    ),),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 130),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_up_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_down_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.share_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    height: 100.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5)
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("https://i.pinimg.com/564x/83/21/92/832192ec5a509616ad655b0d6004d981.jpg")
                              )
                          ),
                        ),
                        Container(
                          height: 100.0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                        color: Colors.yellow
                                    ),
                                    child: Text("Recommendation", textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Container(
                                    width: 200,
                                    child: Text("Want to know how the weather affects you? Then try Dark Sky.", style: TextStyle(
                                        fontSize: 11
                                    ),),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 130),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_up_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_down_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.share_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    height: 100.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          width: 125.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5)
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("https://i.pinimg.com/564x/d3/81/cd/d381cd99cbe62d19f910480c41edeb56.jpg")
                              )
                          ),
                        ),
                        Container(
                          height: 100.0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                        color: Colors.yellow
                                    ),
                                    child: Text("Recommendation", textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Container(
                                    width: 200,
                                    child: Text("You are happier when you spend more time with friends.", style: TextStyle(
                                        fontSize: 11
                                    ),),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 130),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_up_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_down_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          icon: const Icon(Icons.share_outlined),
                                          iconSize: 18,
                                          onPressed: () {
                                            //TODO
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
