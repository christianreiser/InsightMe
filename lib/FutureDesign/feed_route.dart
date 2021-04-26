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
                  child: ListTile(
                    leading: Icon(
                      Icons.fastfood,
                    ),
                    //FlutterLogo(size: 72.0),
                    title: Text('Energy & Food'),
                    subtitle: Text(
                        'To increase your energy level try eating less high temperature processed food.'),
                    isThreeLine: true,
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.local_hospital,
                    ),
                    //FlutterLogo(size: 72.0),
                    title: Text('Energy'),
                    subtitle: Text(
                        'Iron Deficiency. \nYour energy level correlates with iron.'),
                    isThreeLine: true,
                  ),
                ),
              ],
            ),
          )

          /* TODO: adapt this to current view
          Container(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(items[index]),
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    direction: DismissDirection.endToStart,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 100.0,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 100.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      topLeft: Radius.circular(5)
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png")
                                  )
                              ),
                            ),
                            Container(
                              height: 100,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      items[index],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child: Container(
                                        width: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.teal),
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                        child: Text("3D",textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                      child: Container(
                                        width: 260,
                                        child: Text("His genius finally recognized by his idol Chester",style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(255, 48, 48, 54)
                                        ),),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          )
           */
        ],
      ),
    );
  }
}
