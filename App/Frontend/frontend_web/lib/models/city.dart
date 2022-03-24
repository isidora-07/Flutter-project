class City{
  int _id;
  String _name;

  City(this._id, this._name);

  int get id => _id;
  String get name => _name;

  //Convert a City object into a Map object
  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data["id"] = _id;
    data["name"] = _name;

    return data;
  }

  //Extract a City object from a Map object
  City.fromObject(dynamic data){
    this._id = data["id"];
    this._name = data["name"];
  }
}