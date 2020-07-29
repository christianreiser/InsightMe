import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//import 'package:simple_permissions/simple_permissions.dart'; // compiling error when in pubspec
import 'package:permission_handler/permission_handler.dart';



exportDailySummaries() async {
  /*get source file*/
  final directoryCurrent = await getApplicationDocumentsDirectory();
  final currentPath = directoryCurrent.path + "/daily_summaries.csv";

  /*get permission*/
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();
  debugPrint('${statuses[Permission.storage]}');

  /* copy file */
  File(currentPath).copy('/storage/emulated/0/Download/export.csv');
}