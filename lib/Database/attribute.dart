

class Attribute {
  /* initialize */
  int _id;
  String _title;
  String _note;
  int _color;
  int _aggregation;

  Attribute(this._title, this._note, this._color, this._aggregation);

  Attribute.withId(
      this._id, this._title, this._note, this._color, this._aggregation);

  /*
  getters
  */
  int get id => _id;

  String get title => _title;

  String get note => _note;

  int get color => _color;

  int get aggregation => _aggregation;

  /*
  setters
  */
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set note(String newNote) {
    if (newNote.length <= 255) {
      // todo userXP: tell user about 255 length
      this._note = newNote;
    }
  }

  set color(int newColor) {
    this._color = newColor;
  }

  set aggregation(int newAggregation) {
    this._aggregation = newAggregation;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['note'] = _note;
    map['color'] = _color;
    map['aggregation'] = _aggregation;

    return map;
  }

  // Extract a Note object from a Map object
  Attribute.fromMapObject(Map<String, dynamic> map) {
    // debugPrint('mapTitle ${map['title']}');
    this._id = map['id'];
    this._title = map['title'];
    this._note = map['note'];
    this._color = map['color'];
    this._aggregation = map['aggregation'];
  }
}
