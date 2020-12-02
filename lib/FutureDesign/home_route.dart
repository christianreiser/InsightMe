import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeRoute extends StatelessWidget {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  static const double iconSize = 50;
  static const Color iconColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      // ChangeNotifierProvider for state management
      child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
          children: <Widget>[
            //TITLE
            Text(
              'Key Insights',
              style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: const <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.check_circle,size: iconSize, color: iconColor,),//FlutterLogo(size: 72.0),
                      title: Text('About today'),
                      subtitle: Text(
                          'You are set for an excellent day today! Skin temperature: 33 °C, Resting heart rate: 54 BPM, heart rate variability: 59 \n'
                              'Good to know button              i don\'t care button'),
                      //trailing: Icon(Icons.local_hospital),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.local_hospital,size: iconSize, color: iconColor,),//FlutterLogo(size: 72.0),
                      title: Text('Health'),
                      subtitle: Text(
                          'Skip the peanuts? You are twice as likely to get an headache when you ate peanuts the day before.\n'
                              'Good to know button              i don\'t care button'),
                      //trailing: Icon(Icons.local_hospital),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.directions_run,size: iconSize, color: iconColor,),//FlutterLogo(size: 72.0),
                      title: Text('Fitness'),
                      subtitle: Text(
                          'Your running pace is faster when you eat more carbs the day before.\n'
                              'Good to know button              i don\'t care button'),
                      //trailing: Icon(Icons.local_hospital),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.computer,size: iconSize, color: iconColor,),//FlutterLogo(size: 72.0),
                      title: Text('Productivity'),
                      subtitle: Text(
                          'When working more than 9.5 hours you start to get less productive the next day.\n'
                              'Good to know button              i don\'t care button'),
                      //trailing: Icon(Icons.local_hospital),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.local_hospital,size: iconSize, color: iconColor,),//FlutterLogo(size: 72.0),
                      title: Text('Recommendation'),
                      subtitle: Text(
                          'You seem stressed today. If you want to earn about how to reduce stress by practicing meditation we recommend THIS LINK. \n'
                              'Good to know button              i don\'t care button'),
                      //trailing: Icon(Icons.local_hospital),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.get_app,size: iconSize, color: iconColor,),//FlutterLogo(size: 72.0),
                      title: Text('App usage tip'),
                      subtitle: Text(
                          'To get insights on how the weather affects you, we recommend installing DARK SKY.\n'
                              'Good to know button              i don\'t care button'),
                      //trailing: Icon(Icons.local_hospital),
                      isThreeLine: true,
                    ),
                  ),
                ],
              ),
            ),
          ]),
    ); // type lineChart
  }
}
//}
