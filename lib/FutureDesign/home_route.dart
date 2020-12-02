import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeRoute extends StatefulWidget {
  static const double leadingIconSize = 50;
  static const double trailingIconSize = 30;
  static const Color iconColor = Colors.teal;

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
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
/*            Text(
              'Home',
              style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w500, color: Colors.teal),
            ),
            SizedBox(height: 15),*/

            Expanded(
              child: ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('Everything looks good!'),
                      subtitle: Text(
                          'Temperature, resting heart rate, heart rate variability, blood sugar level are in your normal range'),
                      isThreeLine: true,
                      trailing: _voteUpDownButton(),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.local_hospital,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('Health'),
                      subtitle: Text(
                          'Skip the peanuts? You are twice as likely to get an headache when you ate peanuts the day before'),
                      trailing: _voteUpDownButton(),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.directions_run,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('Fitness'),
                      subtitle: Text(
                          'Your running pace is faster when you eat more carbs the day before.'),
                      trailing: _voteUpDownButton(),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.computer,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('Productivity'),
                      subtitle: Text(
                          'When working more than 9.5 hours you start to get less productive the next day.'),
                      trailing: _voteUpDownButton(),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.local_hospital,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('Recommendation'),
                      subtitle: Text(
                          'You seem stressed today. If you want to earn about how to reduce stress by practicing meditation we recommend THIS LINK.'),
                      trailing: _voteUpDownButton(),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.get_app,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('App usage tip'),
                      subtitle: Text(
                          'To get insights on how the weather affects you, we recommend installing DARK SKY.'),
                      trailing: _voteUpDownButton(),
                      isThreeLine: true,
                    ),
                  ),
                ],
              ),
            ),
          ]),
    ); // type lineChart
  }

  Widget _voteUpDownButton() {
    /// button for voting up or down
    return SizedBox(
      width: 50,
      child: FlatButton(
        onPressed: () {
          _voteUpDownDialog();
        },
        child: Icon(
          Icons.thumbs_up_down,
          color: HomeRoute.iconColor,
          size: HomeRoute.trailingIconSize,
        ),
      ),
    );
  }

  _voteUpDownDialog() {
    /// dialog for voting up or down
    AlertDialog alertDialog = AlertDialog(
      actions: [
        FlatButton(
          child: Row(
            children: [Icon(Icons.thumb_up), Text(' Show more')],
          ),
          onPressed: () {
            //todo implement show more functionality
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Row(
            children: [
              SizedBox(
                width: 2,
              ),
              Icon(Icons.thumb_down),
              Text(' Show less')
            ],
          ),
          onPressed: () {
            //todo implement show more functionality
            Navigator.of(context).pop();
          },
        ),
      ],
      title: Text('Do you like the message?'),
/*      content: Text('Vote up to see such messages more\n'
          'and down for less often.'),*/
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
//}
