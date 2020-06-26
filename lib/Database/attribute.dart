class Attribute {

  int _id;
  String _title;

  Attribute(this._title);

  Attribute.withId(this._id, this._title);

  int get id => _id;

  String get title => _title;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;

    return map;
  }

  // Extract a Note object from a Map object
  Attribute.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
  }
}