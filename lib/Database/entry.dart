/* chrei
// define the data that needs to be stored:
class Attribute {
  final int id;
  final String name;
  final int value;  // TODO float

  Attribute({this.id, this.name, this.value});
}*/

// TODO create for me individually
// create the model class for the to-do item.
// Title, comment, date, and id for each to-do

class Entry {

  int _id;
  String _title;
  String _value;
  String _comment;
  String _date;

  Entry(this._title, this._value, this._date, this._comment );

  Entry.withId(this._id, this._title, this._value, this._date, this._comment);

  int get id => _id;

  String get title => _title;

  String get value => _value;

  String get comment => _comment;

  String get date => _date;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set value(String newValue) {
    if (newValue.length <= 255) {
      this._value = newValue;
    }
  }
  set comment(String newComment) {
    if (newComment.length <= 255) {
      this._comment = newComment;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['value'] = _value;
    map['comment'] = _comment;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Entry.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._value = map['value'];
    this._comment = map['comment'];
    this._date = map['date'];
  }
}