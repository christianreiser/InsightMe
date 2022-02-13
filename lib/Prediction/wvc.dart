import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'core.dart';

Widget wcv(context, i) {
  Color contributionColor = kindaGreen;
  const Color weightColor = Colors.teal; //const Color(0xFF00b5b2); //
  const Color valueTodayColor = const Color(0xFF5dddd7);
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    child: Container(
      color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(children: [
            _greenRedLegendBox(context),
            Text(' Contribution  '),
            Container(color: weightColor, height: 16.0, width: 16.0),
            Text(' Relationship  '),
            Container(color: valueTodayColor, height: 16.0, width: 16.0),
            Text(' Today\'s value  '),
          ]),
          SizedBox(height: 6),
          FutureBuilder(
            future: _readPhoneWVCIOFiles(context),
            builder: (context, snapshot) {
              final List<List<dynamic>>? wvcData = snapshot.data as List<List<dynamic>>?;
              if (snapshot.connectionState == ConnectionState.done) {
                const double height = 16.0;
                List<double> scaleBounds = [wvcData![2][5], wvcData[1][5]];

                /// def _wvcChildren
                List<Widget> _wvcChildren(wVCIOData) {
                  List<Widget> list = [];
                  // if positive then green; red if negative
                  if (wVCIOData[i][1] < 0) {
                    contributionColor = kindaRed;
                  }
                  print('wVCIOData[i][1] ${wVCIOData[i][1]}');

                  /// Contribution
                  list.add(
                    scaledBar(0, wVCIOData[i][1], scaleBounds,
                        contributionColor, height, '', false),
                  );

                  /// Weight
                  list.add(
                    scaledBar(0, wVCIOData[i][2], scaleBounds, weightColor,
                        height, '', false),
                  );

                  /// Today's measurement
                  list.add(Stack(children: <Widget>[
                    scaledBar(0, wVCIOData[i][4], scaleBounds, valueTodayColor,
                        height, '', false),
// Text('Today - average${wVCIOData[i][0]}:')
                  ]));
                  list.add(
                    SizedBox(
                      height: 10,
                    ),
                  );
                  return list;
                } // end def _wvcChildren

                return Stack(children: [
                  Column(
                    children: _wvcChildren(wvcData),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      scaledBar(0, 0.01, scaleBounds, Colors.black, height * 3,
                          '', false),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                  )
                ]);
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          _showWVCExplanation(
              contributionColor, weightColor, valueTodayColor, context),
        ],
      ),
    ),
  );
}

Widget _showWVCExplanation(
    contributionColor, weightColor, valueTodayColor, context) {
  return TextButton(
    style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    /* info note for correlation coefficient */
    // to reduce height of correlation info button
    child: Icon(Icons.info, color: Colors.grey),
    onPressed: () {
      AlertDialog alertDialog = AlertDialog(
        title: Text('Explanation'),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                _greenRedLegendBox(context),
                Text(' = '),
                Container(color: weightColor, height: 16.0, width: 16.0),
                Text(' · '),
                Container(color: valueTodayColor, height: 16.0, width: 16.0),
              ]),
              Text('Contribution = Weight · Measurement.\n'
                  'In the example below it has a medium positive effect.\n'),
              Row(children: [
                Container(color: weightColor, height: 16.0, width: 16.0),
                Text(' Relationship or Correlation:'),
              ]),
              Text(
                  'Indicates how strong the effect is and if it\'s negative or positive.\n'
                  'In the example below Humidity has a strong negative relationship with mood.\n'),
              Row(children: [
                Container(color: valueTodayColor, height: 16.0, width: 16.0),
                Text(' Today\'s value:'),
              ]),
              Text(
                  'Indicates if today\'s humidity measurement is below or above average.\n'),
              Text('Example Humidity:'),
              scaledBar(5, 6.7, [1, 9], contributionColor, 16.0, '', false),
              scaledBar(1.5, 5, [1, 9], weightColor, 16.0, '', false),
              scaledBar(4.5, 5, [1, 9], valueTodayColor, 16.0, '', false),
            ]),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
      showDialog(context: context, builder: (_) => alertDialog);
    },
  );
}

Widget _greenRedLegendBox(context) {
  return Container(
      child: Stack(children: [
        Container(color: kindaRed),
        ClipPath(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: kindaGreen,
          ),
          clipper: CustomClipPath(),
        )
      ]),
      height: 16.0,
      width: 16.0);
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(16, 0);
    path.lineTo(0, 16);
    path.lineTo(0, 0);
    // path.lineTo(16, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Future<List<List<dynamic>>> _readPhoneWVCIOFiles(context) async {
  final String data = await DefaultAssetBundle.of(context)
      .loadString("assets/tmp_phone_io/wvc_chart.csv");
  final List<List<dynamic>> wVCIODataListList =
      const CsvToListConverter().convert(data);
  print('wVCIODataListList: $wVCIODataListList');
  return wVCIODataListList;
}
