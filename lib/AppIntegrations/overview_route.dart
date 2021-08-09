import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/functions/navigation_helper.dart';
import 'package:insightme/Database/database_helper_attribute.dart';
import 'package:insightme/Database/database_helper_entry.dart';

import 'Connect_route/gfit.dart';

class AppIntegrationsOverview extends StatelessWidget {
  final DatabaseHelperEntry helperEntry = // error when static
      DatabaseHelperEntry();

  static DatabaseHelperAttribute databaseHelperAttribute =
      DatabaseHelperAttribute();

//  int importSuccessCounter = 0;
//  int importFailureCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            NavigationHelper().navigateToFutureDesign(context); // refreshes
          },
        ),
        title: Text('Import'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bring data from other apps',
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),

              /// Google fit
              Row(children: [
                Expanded(
                  flex: 50,
                  child: Image(
                      image: AssetImage('./assets/icon/logo_googlefit.png')),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'fit_kit plugin',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
                Expanded(
                  flex: 10,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GFit(),
                        ),
                      );
                    },
                  ),
                ),
              ]),
              SizedBox(height: 10),

              /*/// FitBit
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_fitbit.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Steps, active minutes, floors walked, energy burned, sleep',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// RescueTime
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_rescueTime.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Screen time, productive time, neutral time, distracting time',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// AppleHealth
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_applehealth.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apple Health data, daily mood rating, custom tags, location',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// forecast
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_forecast.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weather conditions',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// Calendar
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_calendar.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Events, time spent in events',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// github
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_github.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Commits',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// lastfm
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_lastfm.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'music',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// pocket
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_pocket.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'articles read, words read',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// strava
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_strava.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'workouts',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// TODoIst
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_todoist.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'tasks completed',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// facebook
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_facebook.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posts, comments, reactions',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// twitter
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_twitter.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'tweets, mentions, likes',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// withings
            Row(
              children: [
                Expanded(
                    flex: 50,
                    child: Image(
                        image: AssetImage('./assets/icon/logo_withings.png'))),
                SizedBox(width: 10),
                Expanded(
                  flex: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'activity, sleep, body weight, blood pressure',
                          textScaleFactor: 1.2,
                        )
                      ]),
                ),
              ],
            ),*/
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ); // type lineChart
  }
}
