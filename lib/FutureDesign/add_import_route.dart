import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddImportRoute extends StatefulWidget {

  @override
  _AddImportRouteState createState() => _AddImportRouteState();
}

class _AddImportRouteState extends State<AddImportRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.white,
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
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    //TODO
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                )
            ),
          ],
        )
    );
  }
}
