class City{
  int _id;
  String _name;
  double _latitude;
  double _longitude;

  City();
  City.withId(this._id, this._name);

  int get id => _id;
  String get name => _name;
  double get latitude => _latitude;
  double get longitude => _longitude;  

  //Convert a City object into a Map object
  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data["id"] = _id;
    data["name"] = _name;
    data["latitude"] = _latitude;
    data["longitude"] =_longitude;
    return data;
  }

  //Extract a City object from a Map object
  City.fromObject(dynamic data){
    this._id = data["id"];
    this._name = data["name"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
  }
}