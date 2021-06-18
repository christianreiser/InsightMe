import 'package:flutter/cupertino.dart';
import 'package:flutter_charts/flutter_charts.dart';

getFirstLetter(String title) {
  /* get first letter for yellow circle avatar */
  if (title.length > 0) {
    // to avoid error when title.length == 0
    return title.substring(0, 1);
  } else {
    return ' ';
  }
}

List<List<dynamic>> transposeChr(List<List<dynamic>> colsInRows) {
  final int nRows = colsInRows.length;
  if (colsInRows.length == 0) return colsInRows;

  final int nCols = colsInRows[0].length;
  if (nCols == 0) throw new StateError("Degenerate matrix");

  // Init the transpose to make sure the size is right
  List<List<dynamic>> rowsInCols = new List.filled(nCols, []);
  for (int col = 0; col < nCols; col++) {
    rowsInCols[col] =
    new List.filled(nRows, new StackableValuePoint.initial());
  }

  // Transpose
  for (int row = 0; row < nRows; row++) {
    debugPrint('row: ${row+1} of $nRows');

    for (int col = 0; col < nCols; col++) {
      // debugPrint('colsInRows[row][col]: ${colsInRows[row][col]}');
      // debugPrint('rowsInCols[col][row]: ${rowsInCols[col][row]=1}');
      rowsInCols[col][row] = colsInRows[row][col];
    }
  }
  // debugPrint('after transpose rowsInCols: $rowsInCols');
  return rowsInCols;
}