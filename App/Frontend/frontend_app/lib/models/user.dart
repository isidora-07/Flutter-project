class User{
  int _id;
  String _firstName;  
  String _lastName;
  String _createdAt;
  String _username;
  String _password;
  String _email;
  String _phone;  
  int _cityId;
  String _cityName;
  String _token;
  String _photo;
  int _postsNum;
  int _points;
  int _donatedPoints;
  int _level;
  bool _darkTheme;

  User();
  User.without(this._firstName, this._lastName, this._username, this._password, this._email, this._phone, this._cityId, this._photo);
  

  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get createdAt => _createdAt;
  String get username => _username;
  String get password => _password;
  String get email => _email;
  String get phone => _phone;
  int get cityId => _cityId;
  String get cityName => _cityName;
  String get token => _token;
  String get photo => _photo;
  int get postsNum => _postsNum;
  set postsNum(int postsNum){_postsNum = postsNum;}
  int get points => _points;
  set points(int points){_points = points;}
  int get donatedPoints => _donatedPoints;
  set donatedPoints(int points){_donatedPoints = points;}
  int get level => _level;
  bool get darkTheme => _darkTheme;
  set darkTheme(bool theme){_darkTheme = theme;}

  //Convert a User into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["firstName"] = _firstName;
    data["lastName"] = _lastName;
    data["createdAt"] = _createdAt;
    data["username"] = _username;
    data["password"] = _password;
    data["email"] = _email;
    data["phone"] = _phone;
    data["cityId"] = _cityId;
    data["cityName"]=_cityName;
    data["token"] = _token;
    data["photo"] = _photo;
    data["postsNum"] = _postsNum;
    data["points"] = _points;
    data["donatedPoints"] = _donatedPoints;
    data["level"] = _level;
    data["darkTheme"] = _darkTheme;
 
    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  //Extract a User object from a Map object
  User.fromObject(dynamic data){
    this._id = data["id"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];
    this._createdAt = data["createdAt"];
    this._username = data["username"];
    this._password = data["password"];
    this._email = data["email"];
    this._phone = data["phone"];
    this._cityId = data["cityId"];
    this._token = data["token"];
    this._cityName = data["cityName"];
    this._photo = data["photo"];
    this._postsNum = data["postsNum"];
    this._points = data["points"];
    this._donatedPoints = data["donatedPoints"];
    this._level = data["level"];
    this._darkTheme = data["darkTheme"];
  }

}