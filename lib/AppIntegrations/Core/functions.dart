import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveConnectionSetting(serviceName) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('$serviceName Connected', true);
  final gFitConnected = prefs.getBool('$serviceName Connected') ?? false;
  debugPrint('tried to set set gFitConnected shared pref to true: $gFitConnected');
}

