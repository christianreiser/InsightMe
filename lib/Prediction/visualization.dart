import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Prediction/wvc_chart.dart';

import 'color_scale.dart';
import 'gantt.dart';

/// json_to_dart https://javiercbk.github.io/json_to_dart/
class PredictionAutogenerated {
  double prediction;
  double ci68;
  List<double> ci95;
  List<double> scaleBounds;
  double targetMean;

  PredictionAutogenerated(
      {this.prediction,
      this.ci68,
      this.ci95,
      this.scaleBounds,
      this.targetMean});

  PredictionAutogenerated.fromJson(Map<String, dynamic> json) {
    prediction = json['prediction'];
    ci68 = json['ci68'];
    ci95 = json['ci95'].cast<double>();
    scaleBounds = json['scale_bounds'].cast<double>();
    targetMean = json['target_mean'];
    print(
        'prediction,ci68,ci95,scaleBounds,targetMean below:\n$prediction,$ci68,$ci95,$scaleBounds,$targetMean');
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

    const bool _wvcChartEnabled = true;
    const bool _ganttChartEnabled = true;
    return Container(
      margin: const EdgeInsets.all(8),
      child: FutureBuilder(
          future: _readPhonePredictionIOFiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print('snapshot.data: ${snapshot.data.prediction}');
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      // padding: const EdgeInsets.fromLTRB(1, 8, 8, 8),
                      child: Text(
                        'Mood prediction for today with prediction interval:',
                        style: TextStyle(
                            fontSize: 15.5, fontWeight: FontWeight.w500),
                      ),
                    ),
                    _ganttChartEnabled == true
                        ? biDirectionalGanttChart(
                            snapshot.data.scaleBounds, context)
                        : Container(),
                    SizedBox(height: 3),
                    predictionWidget(snapshot.data),
                    numericScale(snapshot.data.scaleBounds),
                    _ganttChartEnabled == true
                        ? showGanttExplanation(context)
                        : Container(),
                    _wvcChartEnabled == true ? wvcChart(context) : Container(),
                  ],
                ),
              );
            } else {
              return Container(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
