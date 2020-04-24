//import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database/Screen/todo_detail.dart';
import 'Database/db_help_one_att.dart';
import 'Database/todo.dart';
import 'searchOrCreateAttribute.dart';




class JournalScreen extends StatefulWidget {
  JournalScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  DbHelpOneAtt helperTodo = DbHelpOneAtt(); // probably needed?
  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the JournalScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Journal"),
      ),
      body: getTodoListView(),
      floatingActionButton: SpeedDial(
        //floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        //tooltip: 'Increment',
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.border_color),
              label: "New Entry",
              onTap: () {
                print("nav to add manually");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchOrCreateAttribute()),
                ); // Navigate to newManualEntry route when tapped.
              }
          )
          ,
          SpeedDialChild(
              backgroundColor: Colors.grey,
              child: Icon(Icons.timer),
              label: "-not implemented-",
              onTap: () {
                print("not implemented yet");
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttributeList()),
                ); // Navigate to newManualEntry route when tapped.*/
              }
          )
        ],
      )
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }


  // TO-DO LIST
  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            // YELLOW CIRCLE AVATAR
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.todoList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            // TITLE
            title: Text(this.todoList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),

            // SUBTITLE
            subtitle: Text(this.todoList[position].description),

            // TRASH ICON
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.edit,color: Colors.grey,),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    navigateToTodoDetail(this.todoList[position], 'Edit Attribute');
                  },
                ),
              ],
            ),

            // onTAP TO EDIT
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToTodoDetail(this.todoList[position], 'Edit Todo');
            },
          ),
        );
      },
    );
  }

  // for yellow circle avatar
  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  // navigation for editing entry
  void navigateToTodoDetail(Todo todo, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // updateListView depends on state
  void updateListView() {
    final Future<Database> dbFuture = helperTodo.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = helperTodo.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}

