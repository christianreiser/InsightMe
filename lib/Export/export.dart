import 'package:path_provider/path_provider.dart';
import 'dart:io';


exportDailySummaries() async {
  final directoryCurrent = await getApplicationDocumentsDirectory();
  final currentPath = directoryCurrent.path + "/daily_summaries.csv";
  final directoryTarget = await getExternalStorageDirectory();
  final targetPath = directoryTarget.path + "/Download/daily_summaries.csv";
  File(currentPath).copy(targetPath);
}