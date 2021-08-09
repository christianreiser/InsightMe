import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveConnectionSetting(serviceName) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('$serviceName Connected', true);
  debugPrint('set gFitConnected shared pref: $serviceName Connected to true');
}