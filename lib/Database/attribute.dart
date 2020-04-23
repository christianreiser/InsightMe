/* chrei
// define the data that needs to be stored:
class Attribute {
  final int id;
  final String name;
  final int value;  // ATTRIBUTE float

  Attribute({this.id, this.name, this.value});
}*/

// ATTRIBUTE create for me individually
// create the model class for the to-do item.
// Title, value_type_not_implemented, date, and id for each to-do

class Attribute {

  int _id;
  String _title;
  String _value_type_not_implemented;
  String _date;

  Attribute(this._title, this._date, [this._value_type_not_implemented] );

  Attribute.withId(this._id, this._title, this._date, [this._value_type_not_implemented]);

  int get id => _id;

  String get title => _title;

  String get value_type_not_implemented => _value_type_not_implemented;

  String get date => _date;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set value_type_not_implemented(String newValue_type_not_implemented) {
    if (newValue_type_not_implemented.length <= 255) {
      this._value_type_not_implemented = newValue_type_not_implemented;
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
    map['value_type_not_implemented'] = _value_type_not_implemented;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Attribute.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._value_type_not_implemented = map['value_type_not_implemented'];
    this._date = map['date'];
  }
}