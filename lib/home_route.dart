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
                        Icons.fastfood,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('Energy & Food'),
                      subtitle: Text(
                          'To increase your energy level try eating less high temperature processed food.'),
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
                      title: Text('Energy'),
                      subtitle: Text(
                          'Iron Deficiency. \nYour energy level correlates with iron.'),
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
                          'Try working from home. \nYour productivity correlates with home-office.'),
                      trailing: _voteUpDownButton(),
                      isThreeLine: true,
                    ),
                  ),
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
                          'Checked: Temperature, resting heart rate, heart rate variability, blood sugar level '),
                      isThreeLine: true,
                      trailing: _voteUpDownButton(),
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
                          'Try Carbs before running. \nCarbs correlate with running performance.'),
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
                      title: Text('Stress'),
                      subtitle: Text(
                          'Try meditation. \nUsually meditation lowers your stress level.'),
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
                          'Want to know how the weather affects you? \nThen try Dark Sky.'),
                      trailing: _voteUpDownButton(),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.mood,
                        size: HomeRoute.leadingIconSize,
                        color: HomeRoute.iconColor,
                      ),
                      //FlutterLogo(size: 72.0),
                      title: Text('Happiness'),
                      subtitle: Text(
                          'You are happier when you spend more time with friends.'),
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
      child: TextButton(
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
        TextButton(
          child: Row(
            children: [Icon(Icons.thumb_up), Text(' Show more')],
          ),
          onPressed: () {
            //todo feature: implement show more functionality
            Navigator.of(context).pop();
          },
        ),
        TextButton(
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
            //todo feature: implement show more functionality
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
