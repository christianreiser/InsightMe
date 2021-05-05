import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class EditNotePage extends StatefulWidget {
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  String dropdownValue = 'Emotion';
  String date = DateFormat.yMMMMd('en_US').format(DateTime.now());
  String time = DateFormat.Hm().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.folder_rounded,
                  color: Colors.black,
                  size: 35,
                ),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Emotion', 'Health', 'Activity']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 100),
                IconButton(
                  icon: const Icon(Icons.done),
                  iconSize: 25,
                  onPressed: () {
                    //TODO
                  },
                )
              ],
            ),
            SizedBox(height: 30),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.circle,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(height: 30),
            Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    maxLines: 20,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your text here"),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child:
                      Text(date + ', ' + time, style: TextStyle(fontSize: 12)),
                ),
                //SizedBox(width: 100),
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: Colors.grey),
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
    );
  }
}
