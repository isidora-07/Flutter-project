class Admin{
  int _id;
  String _firstName;  
  String _lastName;
  String _password;
  String _email;
  String _photoPath;


  Admin();
  Admin.without(this._firstName, this._lastName, this._password, this._email);
 

  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get password => _password;
  String get email => _email;
  String get photoPath => _photoPath;

  //Convert a User into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["firstName"] = _firstName;
    data["lastName"] = _lastName;
    data["password"] = _password;
    data["email"] = _email;
    data["photoPath"] = _photoPath;
 
    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  //Extract a User object from a Map object
  Admin.fromObject(dynamic data){
    this._id = data["id"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];
    this._password = data["password"];
    this._email = data["email"];
    this._photoPath = data["photoPath"];
  }

}
