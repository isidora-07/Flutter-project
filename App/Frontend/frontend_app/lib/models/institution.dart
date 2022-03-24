class Institution {

  int _id;
  String _name;  
  String _description;
  String _password;
  String _email;
  String _phone;  
  int _cityId;
  bool _authentication;
  String _cityName;
  String _createdAt;
  String _city;
  int _postsNum;
  String _photoPath;
  

  Institution();
  Institution.without(this._name, this._description, this._password, this._email, this._phone, this._cityId);

  int get id => _id;
  String get name => _name;
  String get description => _description;
  int get cityId =>_cityId;
  int get postsNum =>_postsNum;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get cityName => _cityName;
  String get createdAt => _createdAt;
  String get city => _city;
  String get photoPath => _photoPath;
  bool get authentication => _authentication;

  //Convert a Ins into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["name"] = _name;
    data["description"] = _description;
    data["password"] = _password;
    data["email"] = _email;
    data["phone"] = _phone;
    data["cityId"] = _cityId;
    data["cityName"] = _cityName;
    data["createdAt"] = _createdAt;
    data["authentication"] = _authentication;
    data["city"] = _city;
    data["postsNum"] = _postsNum;
    data["photoPath"] = _photoPath;
 
    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  //Extract a User object from a Map object
  Institution.fromObject(dynamic data){
    this._id = data["id"];
    this._name = data["name"];
    this._description = data["description"];
    this._password = data["password"];
    this._email = data["email"];
    this._phone = data["phone"];
    this._cityId = data["cityId"];
    this._city = data["city"];
    this._postsNum = data["postsNum"];
    this._authentication = data["authentication"];
    this._createdAt = data["createdAt"];
    this._cityName = data["cityName"];
    this._photoPath = data["photoPath"];
   
  }





}