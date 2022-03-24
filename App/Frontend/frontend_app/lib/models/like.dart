class Like
{
  int _id;
  int _postId;
  int _userId;
  String _time;
  int _likeTypeId;
  String _username;
  String _firstName;
  String _lastName;
  String _photo;

  
  Like(this._id, this._postId, this._userId, this._time, this._likeTypeId, this._username, this._firstName, this._lastName, this._photo);

  int get postId => _postId;
  int get userId => _userId;
  String get time => _time;
  int get likeTypeId => _likeTypeId;
  int get id => _id;
  String get username => _username;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get photo => _photo;

 //saljemo kao json fajl
  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["postId"] = _postId;
    map["userId"] = _userId;
    map["time"] = _time;
    map["likeTypeId"] = _likeTypeId;
    map["id"] = _id;
    map["username"] = _username;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["photo"] = _photo;

   
    return map;
  }

  //pretvaramo iz json-a u object 
  Like.fromObject(dynamic data)
  {
    this._postId = data["postId"];
    this._userId = data["userId"];
    this._time = data["time"];
    this._likeTypeId = data["likeTypeId"];
    this._id = data["id"];
    this._lastName = data["lastName"];
    this._firstName = data["firstName"];
    this._username = data["username"];
    this._photo = data["photo"];
    

  }
}