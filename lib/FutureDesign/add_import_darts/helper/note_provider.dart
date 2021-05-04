// NOTE: This class contains to add, update and delete operations and notify
// the listeners.

import 'package:flutter/cupertino.dart';
import 'package:insightme/FutureDesign/add_import_darts/models/note.dart';

import 'database_helper.dart';

class NoteProvider with ChangeNotifier {
  List _items = [];

  List get items {
    return [..._items];
  }

  Future getNotes() async {
    final notesList = await DatabaseHelper.getNotesFromDB();
    _items = notesList
        .map(
          (item) => Note(
              item['id'], item['title'], item['content'], item['imagePath']),
        )
        .toList();
    notifyListeners();
  }
}
