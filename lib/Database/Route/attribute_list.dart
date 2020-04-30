//import 'dart:async';
//import 'package:flutter/material.dart';
//import '../attribute.dart';
//import '../database_helper_attribute.dart';
//import 'edit_attributes.dart';
//import 'package:sqflite/sqflite.dart';
//
///*
// * NEW MANUAL ENTRY FILE: list view of buttons
// * List view which displays the entered to-dos
//*/
//
//// CREATE STATEFUL TO-DO-LIST WIDGET
//class AttributeList extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return AttributeListState();
//  }
//}
//
//// STATE OF TO-DO LIST
//class AttributeListState extends State<AttributeList> {
//  DatabaseHelper databaseHelper = DatabaseHelper();
//  List<Attribute> attributeList;
//  int count = 0;
//
//  // NULL -> UPDATE
//  @override
//  Widget build(BuildContext context) {
//    if (attributeList == null) {
//      attributeList = List<Attribute>();
//      updateListView();
//    }
//
//    // APP BAR AND FAB ADD BUTTON
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Attributes'),
//      ),
//      body: getAttributeListView(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          debugPrint('FAB clicked');
//          navigateToDetail(Attribute('', '', ''), 'Add Attribute');
//        },
//        tooltip: 'Add Attribute',
//        child: Icon(Icons.add),
//      ),
//    );
//  }
//
//  // TO-DO LIST
//  ListView getAttributeListView() {
//    return ListView.builder(
//      itemCount: count,
//      itemBuilder: (BuildContext context, int position) {
//        return Card(
//          color: Colors.white,
//          elevation: 2.0,
//          child: ListTile(
//
//            // YELLOW CIRCLE AVATAR
//            leading: CircleAvatar(
//              backgroundColor: Colors.amber,
//              child: Text(getFirstLetter(this.attributeList[position].title),
//                  style: TextStyle(fontWeight: FontWeight.bold)),
//            ),
//
//            // TITLE
//            title: Text(this.attributeList[position].title,
//                style: TextStyle(fontWeight: FontWeight.bold)),
//
//            // SUBTITLE
//            subtitle: Text(this.attributeList[position].description),
//
//            // TRASH ICON
//            trailing: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                GestureDetector(
//                  child: Icon(Icons.delete,color: Colors.red,),
//                  onTap: () {
//                    _delete(context, attributeList[position]);
//                  },
//                ),
//              ],
//            ),
//
//            // onTAP TO EDIT
//            onTap: () {
//              debugPrint("ListTile Tapped");
//              navigateToDetail(this.attributeList[position], 'Edit Attribute');
//            },
//          ),
//        );
//      },
//    );
//  }
//
//  // for yellow circle avatar
//  getFirstLetter(String title) {
//    return title.substring(0, 2);
//  }
//
//  // delete
//  void _delete(BuildContext context, Attribute attribute) async {
//    int result = await databaseHelper.deleteAttribute(attribute.id);
//    if (result != 0) {
//      _showSnackBar(context, 'Attribute Deleted Successfully');
//      updateListView();
//    }
//  }
//
//  // SnackBar for deletion confirmation
//  void _showSnackBar(BuildContext context, String message) {
//    final snackBar = SnackBar(content: Text(message));
//    Scaffold.of(context).showSnackBar(snackBar);
//  }
//
//  // navigation for editing entry
//  void navigateToDetail(Attribute attribute, String title) async {
//    bool result =
//    await Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return AttributeDetail(attribute, title);
//    }));
//
//    if (result == true) {
//      updateListView();
//    }
//  }
//
//  // updateListView depends on state
//  void updateListView() {
//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((database) {
//      Future<List<Attribute>> attributeListFuture = databaseHelper.getAttributeList();
//      attributeListFuture.then((attributeList) {
//        setState(() {
//          this.attributeList = attributeList;
//          this.count = attributeList.length;
//        });
//      });
//    });
//  }
//
//
//}