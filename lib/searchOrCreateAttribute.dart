import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final attributeInputController = TextEditingController();


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


    @override
    Widget build (BuildContext context) {
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
                        child:                       // Input text field for search or create attribute
                        // todo replace with
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'search or create new attribute',
                            suffixIcon: IconButton(
                              onPressed: () => attributeInputController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                          controller: attributeInputController,
                          //style: Theme.of(context).textTheme.description,


                          onChanged: (value) {
                            //debugPrint('Something changed search or create new attribute');
                            debugPrint("Second text field: ${attributeInputController.text}");
                            //print(TextEditingController.text)
                            /*                       TODO:
                           if textfield is not empty and content is not in list:
                              show add button
                            */
                            int lenAttributeInput = attributeInputController.text.length;

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
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              //_save();
                              // TODO save button
                            });
                          },
                        ),
                      ),

                    ],
                  ),





                  // spacing between boxes
                  SizedBox(height: 4),

                  // List of previously used attributes
                  Flexible(
                    child: ListView(
                      children: <Widget>[

                      FlatButton(
                      onPressed: () {},
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "second last used attribute"
                            ),
                          )
                      ),

                      FlatButton(
                        onPressed: () {},
                        child: Align(
                        alignment: Alignment.centerLeft,
                          child: Text(
                              "second last used attribute"
                          ),
                        )
                      ),
                      ],
                    ),
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

} // class
