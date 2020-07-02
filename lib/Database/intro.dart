class Intro {
  int _id;
  String _title;
  bool _value;

  Intro(this._title, this._value);

  Intro.withId(this._id, this._title, this._value);

  int get id => _id;

  String get title => _title;

  bool get value => _value; // TODO change to double?

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set value(bool newValue) {
      this._value = newValue;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['value'] = _value;

    return map;
  }

  // Extract a Note object from a Map object
  Intro.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._value = map['value'];
  }
}
