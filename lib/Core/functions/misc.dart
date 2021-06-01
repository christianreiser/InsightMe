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
  int nRows = colsInRows.length;
  if (colsInRows.length == 0) return colsInRows;

  int nCols = colsInRows[0].length;
  if (nCols == 0) throw new StateError("Degenerate matrix");

  // Init the transpose to make sure the size is right
  List<List<dynamic>> rowsInCols = new List.filled(nCols, []);
  for (int col = 0; col < nCols; col++) {
    rowsInCols[col] =
    new List.filled(nRows, new StackableValuePoint.initial());
  }

  // Transpose
  for (int row = 0; row < nRows; row++) {
    for (int col = 0; col < nCols; col++) {
      rowsInCols[col][row] = colsInRows[row][col];
    }
  }
  return rowsInCols;
}