import 'package:flutter/material.dart';
import '../attribute.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';

/*
* SEARCH OR CREATE NEW ATTRIBUTE FILE: TEXT INPUT
* creating another route to add attributes to Enter attributes to the database.
* */

class AttributeDetail extends StatefulWidget {

  final String appBarTitle;
  final Attribute attribute;

  AttributeDetail(this.attribute, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return AttributeDetailState(this.attribute, this.appBarTitle);
  }
}

class AttributeDetailState extends State<AttributeDetail> {

  DatabaseHelper helper = DatabaseHelper(); // probably needed?

  String appBarTitle;
  Attribute attribute;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  AttributeDetailState(this.attribute, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = attribute.title;
    descriptionController.text = attribute.description;

    return WillPopScope(


      //not sure what it is for
        onWillPop: () {
          moveToLastRoute();
        },


        // APPBAR

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastRoute();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[


                // TITLE

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    //controller: TextEditingController(text: attributeInputController.text),
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name of Label',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),


                // DESCRIPTION

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),


                  // SAVE BUTTON

                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),


                      // DELETE BUTTON

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),

        ));
  }

  void moveToLastRoute() {
    Navigator.pop(context, true);
  }

  // Update the title of attribute object
  void updateTitle(){
    attribute.title = titleController.text;
  }

  // Update the description of attribute object
  void updateDescription() {
    attribute.description = descriptionController.text;
  }


  // Save data to database

  void _save() async {

    // NAVIGATE
    moveToLastRoute();

    // TIMESTAMP
    attribute.date = DateFormat.yMMMd().format(DateTime.now());

    // Update Operation: Update a attribute object and save it to database
    int result;
    if (attribute.id != null) {  // Case 1: Update operation
      result = await helper.updateAttribute(attribute);
    } else { // Case 2: Insert Operation
      result = await helper.insertAttribute(attribute);
    }

    // SUCCESS FAILURE STATUS DIALOG
    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Attribute Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Attribute');
    }

  }


  // DELETE

  void _delete() async {

    moveToLastRoute();

    if (attribute.id == null) {
      _showAlertDialog('Status', 'No Attribute was deleted');
      return;
    }

    int result = await helper.deleteAttribute(attribute.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Attribute Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Attribute');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}