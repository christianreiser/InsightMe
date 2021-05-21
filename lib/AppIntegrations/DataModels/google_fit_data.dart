import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class GoogleFitData {
  String dataType;
  Data data;

  GoogleFitData(this.dataType, this.data);
  Map<String, dynamic> toJson() => _$FitDataToJson(this);

  Map<String, dynamic> _$FitDataToJson(GoogleFitData instance) => <String, dynamic> {
    'dataType': instance.dataType,
    'FitData': instance.data,
  };
}

@JsonSerializable()
class Data {
  double value;
  String dateFrom;
  String dateTo;
  String source;
  bool userEntered;

  Data(this.value, this.dateFrom, this.dateTo, this.source, this.userEntered);
  Map<String, dynamic> toJson() => _$DataToJson(this);

  Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic> {
    'value': instance.value,
    'dateFrom': instance.dateFrom,
    'dateTo': instance.dateTo,
    'source': instance.source,
    'userEntered': instance.userEntered,
  };
}