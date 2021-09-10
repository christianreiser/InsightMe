import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// json_to_dart https://javiercbk.github.io/json_to_dart/
class PredictionAutogenerated {
  double prediction;
  double ci68;
  double ci95;
  List<double> scaleBounds;

  PredictionAutogenerated(
      {this.prediction, this.ci68, this.ci95, this.scaleBounds});

  PredictionAutogenerated.fromJson(Map<String, dynamic> json) {
    prediction = json['prediction'];
    ci68 = json['ci68'];
    ci95 = json['ci95'];
    scaleBounds = json['scale_bounds'].cast<double>();
    print(
        'prediction,ci68,ci95,scaleBounds below:\n$prediction,$ci68,$ci95,$scaleBounds');
  }
}

class PredictionRoute extends StatefulWidget {
  @override
  State<PredictionRoute> createState() => _PredictionRouteState();
}

class _PredictionRouteState extends State<PredictionRoute> {
  @override
  Widget build(BuildContext context) {
    /// read files
    Future<PredictionAutogenerated> _readPhonePredictionIOFiles() async {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/tmp_phone_io/prediction.json");
      final jsonResult = jsonDecode(data); //latest Dart
      PredictionAutogenerated predictions =
          PredictionAutogenerated.fromJson(jsonResult);
      return predictions;
    }

    Future<List<List<dynamic>>> _readPhoneFeatureDataIOFiles() async {
      final String data = await DefaultAssetBundle.of(context)
          .loadString("assets/tmp_phone_io/feature_data.csv");
      final List<List<dynamic>> featureDataListList =
          const CsvToListConverter().convert(data);
      return featureDataListList;
    }

    BoxDecoration _predictionBoxDecoration() {
      return BoxDecoration(
        border: Border.all(width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(1.0)),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment(0.8, 0.0),
          // 10% of the width, so there are ten blinds.
          colors: const <Color>[
            Colors.red,
            Colors.yellow,
            Colors.green
          ], // red to yellow
        ),
      );
    }

    Widget _scaledBar(start, end, scaleBounds, color, height, textBeforeBar) {
      final int startCorrected = ((start - scaleBounds[0]) * 100).toInt();

      final int endCorrected = ((end - scaleBounds[0]) * 100).toInt();
      return Row(children: [
        /// empty space
        Expanded(
            flex: (startCorrected),
            child: Container(
              alignment: Alignment.centerLeft,
              height: height,
              child: Row(
                children: [
                  SizedBox(width: 2),
                  Text(textBeforeBar),
                ],
              ),
            )),

        /// prediction
        Expanded(
            flex: (endCorrected - startCorrected),
            child: Container(
              height: height,
              color: color,
              child: color == Colors.green
                  ? FittedBox(child: Icon(Icons.arrow_forward_sharp))
                  : color == Colors.red
                      ? FittedBox(child: Icon(Icons.arrow_back_sharp))
                      : Container(),
            )),

        /// empty space
        Expanded(
          flex: ((scaleBounds[1] * 100).toInt() - 100 - endCorrected),
          child: Container(height: height),
        ),
      ]);
    }

    Container _gradientColorScale(predictions) {
      return Container(
        height: 30.0,
        decoration: _predictionBoxDecoration(),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _scaledBar(
                predictions.prediction - 0.1,
                predictions.prediction + 0.1,
                predictions.scaleBounds,
                Colors.blue,
                8.0,
                ''),
            _scaledBar(
              predictions.prediction - predictions.ci68,
              predictions.prediction + predictions.ci68,
              predictions.scaleBounds,
              Colors.blue,
              6.0,
              '',
            ),
            _scaledBar(
              predictions.prediction - predictions.ci95,
              predictions.prediction + predictions.ci95,
              predictions.scaleBounds,
              Colors.blue,
              3.0,
              '',
            ),
          ]),
        ),
      );
    }

    Widget _biDirectionalGanttChart(scaleBounds) {
      return FutureBuilder(
        future: _readPhoneFeatureDataIOFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<List<dynamic>> featureEndStarts = snapshot.data;
            const double height = 16.0;

            List<Widget> _ganttChildren(featureEndStarts) {
              List<Widget> list = List();
              //i<5, pass your dynamic limit as per your requirment
              for (int i = 1; i < featureEndStarts.length; i++) {
                Color color = Colors.red;
                if ((featureEndStarts[i][3]) == 'True'){
                  color = Colors.green;
                }
                list.add(
                  _scaledBar(
                      featureEndStarts[i][1],
                      featureEndStarts[i][2],
                      scaleBounds,
                      color,
                      height,
                      featureEndStarts[i][0]),
                ); //add any Widget in place of Text("Index $i")
              }
              return list; // all widget added now retrun the list here
            }

            return Column(
              children: _ganttChildren(featureEndStarts),
            );
          } else {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }

    Widget _scaleTile(num number) {
      return Column(
        children: [
          Container(color: Colors.black, height: 5, width: 1),
          Text('$number')
        ],
      );
    }

    _numericScale(scaleBounds) {
      var text = new List<int>.generate(scaleBounds[1].floor().toInt(), (i) {
        return i + 1;
      });
      return Container(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (var i in text) _scaleTile(i)],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(8),
        child: FutureBuilder(
            future: _readPhonePredictionIOFiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print('snapshot.data: ${snapshot.data.prediction}');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        // padding: const EdgeInsets.fromLTRB(1, 8, 8, 8),
                        child: Text(
                            'Mood prediction for today with confidence interval:')),
                    _biDirectionalGanttChart(snapshot.data.scaleBounds),
                    _gradientColorScale(snapshot.data),
                    _numericScale(snapshot.data.scaleBounds),
                  ],
                );
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
