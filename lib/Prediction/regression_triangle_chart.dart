import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Core/widgets/chart.dart';

import 'core.dart';

Future<List<List<dynamic>>> readRegressionTriangleIOFiles(context) async {
  final String data = await DefaultAssetBundle.of(context)
      .loadString("assets/tmp_phone_io/regression_triangle_chart.csv");
  final List<List<dynamic>> regressionTriangleIODataListList =
      const CsvToListConverter().convert(data);
  return regressionTriangleIODataListList;
}

class _DiagonalClipPath extends CustomClipper<Path> {
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

Widget _greenRedLegendBox(context) {
  return Container(
      child: Stack(children: [
        Container(color: kindaRed),
        ClipPath(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: kindaGreen,
          ),
          clipper: _DiagonalClipPath(),
        )
      ]),
      height: 16.0,
      width: 16.0);
}

Widget triangleScatterPlot(
    context, doseName, regressionTriangleIOData, scaleBounds) {
  print('regressionTriangleIOData:$regressionTriangleIOData');

  /// header: [0]featureName [1]mean_y_coord	[2]mean_x_coord
  /// [3]dosage_coord	[4]response_coord
  final String? label = regressionTriangleIOData[0];
  final double? xMeanCoord = regressionTriangleIOData[1];
  final double yMeanCoord = regressionTriangleIOData[2];
  final double? dosageCoord = regressionTriangleIOData[3];
  final double responseCoord = regressionTriangleIOData[4];
  const double height = 407;
  const double width = 370;

  Color triangleColor = kindaGreen;
  if (yMeanCoord - responseCoord < 0) {
    triangleColor = kindaRed;
  }
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(
      children: [
        SizedBox(width: 8),
        Text('Mood', style: TextStyle(color: Colors.deepPurple)),
      ],
    ),
    Stack(children: [
      SizedBox(
        height: 450, // height constraint
        child: SizedBox.expand(
          /// scatter plot
          child: futureScatterPlot('Mood', label, false),
        ),
      ),
      Column(children: [
        SizedBox(height: 7),

        Row(children: [
          SizedBox(width: 24),
          Container(
              child: Stack(children: [
                Container(color: Colors.grey.withOpacity(0.1)),
                ClipPath(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: triangleColor.withOpacity(0.5),
                  ),
                  clipper: TriangleClipPath(
                      xMeanCoord, yMeanCoord, dosageCoord, responseCoord),
                )
              ]),
              height: height,
              width: width),
          // RotatedBox(
          //     quarterTurns: 1,
          //     child: Text('Mood Contribution')),
        ]),
        // Text('Today\'s-Average Humidity')
      ])
    ]),
    _showTriangleExplanation(context),
  ]);
}

class TriangleClipPath extends CustomClipper<Path> {
  final double? xMean;
  final double yMean;
  final double? dose;
  final double response;

  TriangleClipPath(this.xMean, this.yMean, this.dose, this.response);

  @override
  Path getClip(Size size) {
    print('xMean...:$xMean,$yMean, $dose, $response');
    Path path = Path();
    path.lineTo(xMean!, yMean); //start in middle dosage; mean response
    path.lineTo(dose!, yMean); //right/left
    path.lineTo(dose!, response); //up/down
    path.lineTo(xMean!, yMean); //end in middle
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget _showTriangleExplanation(context) {
  return TextButton(
    style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    /* info note for correlation coefficient */
    // to reduce height of correlation info button
    child: Icon(Icons.info, color: Colors.grey),
    onPressed: () {
      AlertDialog alertDialog = AlertDialog(
          title: Text('Example'),
          content: Image(image: AssetImage('./assets/triangle-example2.png')),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ]);
      showDialog(context: context, builder: (_) => alertDialog);
    },
  );
}
