getFirstLetter(String title) {
  /* get first letter for yellow circle avatar */
  if (title.length > 0) {
    // to avoid error when title.length == 0
    return title.substring(0, 1);
  } else {
    return ' ';
  }
}