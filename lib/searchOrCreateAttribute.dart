import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database/Screen/attribute_detail.dart';
import 'Database/attribute.dart';
import 'Database/database_helper.dart';

/*
* TextEditingController from this cookbook:
* https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller
* */

// Define SearchOrCreateAttribute widget.
class SearchOrCreateAttribute extends StatefulWidget {
  @override
  _SearchOrCreateAttributeState createState() => _SearchOrCreateAttributeState();
}

// Define a corresponding State class, which holds data related to the Form.
class _SearchOrCreateAttributeState extends State<SearchOrCreateAttribute> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  var attributeInputController = TextEditingController();


  // Begin listening for changes when the _MyCustomFormState class is
  // initialized, and stop listening when the _MyCustomFormState is disposed.
/*    @override
    void initState() {
      super.initState();
      // Start listening to changes.
      attributeInputController.addListener(_printLatestValue);
    }*/


  // Clean up the controller when the widget is removed from the
  // widget tree.
  @override
  void dispose() {
    attributeInputController.dispose();
    super.dispose();
  }


  // Function that runs every time the text changes.
  // It prints out the current value of the text field.
/*    _printLatestValue() {
      print("Second text field: ${attributeInputController.text}");
    }*/

  // navigation for editing entry
  void navigateToDetail(Attribute attribute, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AttributeDetail(attribute, title);
    }));

    if (result == true) {
      updateListView();
    }
  }


  // updateListView depends on state
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Attribute>> attributeListFuture = databaseHelper.getAttributeList();
      attributeListFuture.then((attributeList) {
        setState(() {
          this.attributeList = attributeList;
          this.count = attributeList.length;
        });
      });
    });
  }


  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Attribute> attributeList;
  int count = 0;




    @override
    Widget build(BuildContext context) {
      return Scaffold(

        // APP BAR
          appBar: AppBar(
            title: Text("New manual entry"),
          ),

          // FRAGMENT
          body: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[

                        Expanded(
                          //height: ,
                          child: // Input text field for search or create attribute
                          // todo replace with
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'search or create new label',
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    attributeInputController.clear(),
                                icon: Icon(Icons.clear),
                              ),
                            ),
                            controller: attributeInputController,
                            //style: Theme.of(context).textTheme.description,


                            onChanged: (value) {
                              //debugPrint('Something changed search or create new attribute');
                              debugPrint(
                                  "Second text field: ${attributeInputController
                                      .text}");
                              //print(TextEditingController.text)
                              /*                       TODO:
                           if textfield is not empty and content is not in list:
                              show add button
                            */
                              //int lenAttributeInput = attributeInputController.text.length;

                              /*if ()lenAttributeInput < 0) {
                            debugPrint("Second text field: ${attributeInputController.text}");}*/

                              /*                        OR
                          search string in list of attributes
                           if found partially
                              if NOT matched exactly:
                                  show found attributes in list below
                                  display create new attribute button
                              else if: exact match:
                                  hide create new attribute button*/
                            },
                          ),
                        ),

                        Padding(padding: EdgeInsets.all(4.0),),

                        Container(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child: Text(
                              'Create',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Create button clicked");


                                // TODO save button
                                //_save();


                              });

                              navigateToDetail(
                                // attributeInputController.text is the Label
                                // name which is automatically put in in add
                                // attribute filed.
                                // 'Add Attribute' is the App Bar name
                                  Attribute(attributeInputController.text, 'val_not_impl', ''), 'Add Attribute');
                            },
                          ),
                        ),

                      ],
                    ),


                    // spacing between boxes
                    SizedBox(height: 4),

                    // List of previously used attributes
                    Flexible(
                      child: getAttributeListView()
                    )
                  ]
              )
          )
      );
    } // widget


/* // Save data to database
  void _save() async {
    // NAVIGATE
    moveToLastScreen();
    // TIMESTAMP
    todo.date = DateFormat.yMMMd().format(DateTime.now());
    // Update Operation: Update a to-do object and save it to database
    int result;
    if (todo.id != null) {  // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else { // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }
    // SUCCESS FAILURE STATUS DIALOG
    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Todo Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Todo');
    }
  }*/
  // TO-DO LIST
  ListView getAttributeListView() {
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
              child: Text(getFirstLetter(this.attributeList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            // TITLE
            title: Text(this.attributeList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),

            // SUBTITLE
/*            subtitle: Text(this.attributeList[position].description),*/

            // EDIT ICON
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.edit,color: Colors.grey,),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    navigateToDetail(this.attributeList[position], 'Edit Attribute');
                  },
                ),
              ],
            ),

            // onTAP TO EDIT
            onTap: () {
              // TODO navigate to Route for entering value, free text, date, time;
              //  TODO optional: feedback: compare to average.
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



} // class