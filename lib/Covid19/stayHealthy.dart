import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class StayHealthy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stay healthy'),
        leading: null,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        // ChangeNotifierProvider for state management
        child: Column(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
            children: <Widget>[
              // TITLE
              Row(children: <Widget>[
                Icon(Icons.local_hospital),
                Text(
                  ' COVID-19 Info & Resources',
                  style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w500),
                ),
              ]),
              SizedBox(height: 15),

              // SPACING AND GREY LINE
              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ), // spacing between dropdown and chart

              // WASH HANDS
              ListTile(
                leading: Icon(Icons.assignment_turned_in),
                title: Text(
                  'Wash your hands often',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Track how often you washed your hands'),
                //trailing: Icon(Icons.arrow_forward_ios),

                // onTAP TO EDIT
                onTap: () {
                  debugPrint("ListTile Tapped");
                  //_navigateToCovidStayHealthy(context);
                },
              ),

              // SPACING AND GREY LINE
              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ), // spacing between dropdown and chart

              // Stay active indoors
              ListTile(
                leading: Icon(Icons.directions_run),
                title: Text(
                  'Stay active indoors',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    'Track how often you get up for stretching or do push-ups'),
                //trailing: Icon(Icons.open_in_new),

                // onTAP TO EDIT
                onTap: () {},
              ),

              // SPACING AND GREY LINE
              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ), // spacing between dropdown and chart

              // Sleep
              ListTile(
                leading: Icon(Icons.airline_seat_individual_suite),
                title: Text(
                  'Sleep',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    'Track and improve your sleep to support your immune system.'),
                //trailing: Icon(Icons.open_in_new),

                // onTAP TO EDIT
//              onTap: () {
//                launch(
//                    'https://www.int/emergencies/diseases/novel-coronavirus-2019');
//              },
              ),

              // SPACING AND GREY LINE
              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ), // spacing between dropdown and chart


              // Sleep
              ListTile(
                leading: Icon(Icons.airline_seat_recline_extra),
                title: Text(
                  'Relax',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    'Track your time relaxing or meditating. It reduces stress levels and boosts your immune system '),
                //trailing: Icon(Icons.open_in_new),

                // onTAP TO EDIT
//              onTap: () {
//                launch(
//                    'https://www.int/emergencies/diseases/novel-coronavirus-2019');
//              },
              ),

              // SPACING AND GREY LINE
              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ), // spacing between dropdown and chart


              //Correlation(),
            ]),
      ),
    );
  }
}
//}
