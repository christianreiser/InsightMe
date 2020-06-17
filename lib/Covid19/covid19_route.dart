import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Covid19/stayHealthy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Covid19 extends StatelessWidget {
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
            // TITLE
            Row(children: <Widget>[
              Icon(Icons.local_hospital),
              Text(
                ' COVID-19 Info & Resources',
                style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w500),
              ),
            ]),
            SizedBox(height: 15),

            // DESCRIPTION
            Text(
              'Here are resources to take care of yourself and make a difference in the fight against COVID-19:',
              style: TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.w300, wordSpacing: 4),
            ),

            SizedBox(height: 20.0), // spacing between dropdown and chart


            // SPACING AND GREY LINE
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 1.0,
                color: Colors.grey,
              ),
            ), // spacing between dropdown and chart


            // InsightMe
            ListTile(
              leading: SizedBox(
                width: 120,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'InsightMe',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 26),
                  ),
                ),
              ),
              title: Text(
                'Stay healthy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle:
                  Text('View our resources for more ideas to stay healthy'),
              trailing: Icon(Icons.arrow_forward_ios),

              // onTAP TO EDIT
              onTap: () {
                debugPrint("ListTile Tapped");
                _navigateToCovidStayHealthy(context);
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

            // WHO
            ListTile(
              leading: SvgPicture.asset(
                './assets/icon/who.svg',
                color: Colors.blueAccent,
                width: 120,
              ),
              title: Text(
                'Help stop the spread',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                  'Stay informed with the latest updates from the WHO.'),
              trailing: Icon(Icons.open_in_new),

              // onTAP TO EDIT
              onTap: () {
                launch(
                    'https://www.who.int/emergencies/diseases/novel-coronavirus-2019');
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



            //Correlation(),
          ]),
    ); // type lineChart
  }

  // navigation for editing entry
  void _navigateToCovidStayHealthy(context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StayHealthy();
    }));
  }
}
//}
