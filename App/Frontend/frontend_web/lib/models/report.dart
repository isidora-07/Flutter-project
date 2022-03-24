class Report {
  int _id;
  String _createdAt;
  String _username;
  String _firstName;
  String _lastName;
  String _photo;
  String _reportTypeName;
  String _time;
  int _cityId;


  Report();

  int get id => _id;
  String get createdAt => _createdAt;
  String get username => _username;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get photo => _photo;
  String get reportTypeName => _reportTypeName;
  String get time => _time;
  int get cityId => _cityId;



// convert to map
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();
    data["firstName"] = _firstName;
    data["lastName"] = _lastName;
    data["createdAt"] = _createdAt;
    data["username"] = _username;
    data["photo"] = _photo;
    data["reportTypeName"] = _reportTypeName;
    data["time"] = _time;
    data["cityId"] = _cityId;

    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  Report.fromObject(dynamic data){
    this._id = data["id"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];
    this._createdAt = data["createdAt"];
    this._username = data["username"];
    this._photo = data["photo"];
    this._reportTypeName = data["reportTypeName"];
    this._time = data["time"];
    this._cityId = data["cityId"];
  }







}