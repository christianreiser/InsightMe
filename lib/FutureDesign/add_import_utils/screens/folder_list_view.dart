import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit.dart';

class FolderListPage extends StatefulWidget {
  @override
  _FolderListPageState createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> {
  String date = DateFormat.yMMMMd('en_US').format(DateTime.now());
  String time = DateFormat.Hm().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Emotion',
            style: TextStyle(color: Colors.black, fontSize: 19)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  //TODO
                },
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              )),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 2,
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(date + ', ' + time,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          SizedBox(height: 13),
                          Text('Today, I am feeling quite good.',
                              style: TextStyle(fontSize: 13))
                        ],
                      )),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.star_border, color: Colors.grey),
                        iconSize: 25,
                        onPressed: () {
                          //TODO
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        iconSize: 25,
                        onPressed: () {
                          //TODO
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            elevation: 2,
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(date + ', ' + time,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          SizedBox(height: 13),
                          Text('What a sad day!.',
                              style: TextStyle(fontSize: 13))
                        ],
                      )),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.star_border, color: Colors.grey),
                        iconSize: 25,
                        onPressed: () {
                          //TODO
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        iconSize: 25,
                        onPressed: () {
                          //TODO
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            elevation: 2,
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(date + ', ' + time,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          SizedBox(height: 13),
                          Text('There will be good days sometime.',
                              style: TextStyle(fontSize: 13))
                        ],
                      )),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.star_border, color: Colors.grey),
                        iconSize: 25,
                        onPressed: () {
                          //TODO
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        iconSize: 25,
                        onPressed: () {
                          //TODO
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNotePage()),
          );
        },
      ),
    );
  }
}
