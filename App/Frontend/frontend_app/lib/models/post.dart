class Post{
  int _id;
  String _userId;
  int _postTypeId;
  DateTime  _createdAt;
  String _description;
  String _photoPath;
  String _solvedPhotoPath;
  int _statusId;
  double _latitude;
  double _longitude;


  Post(this._id, this._userId, this._postTypeId, this._createdAt, this._description, this._photoPath,this._solvedPhotoPath, this._statusId, this._latitude, this._longitude);
  Post.withoutId(this._userId, this._postTypeId, this._createdAt, this._description, this._photoPath,this._solvedPhotoPath, this._statusId, this._latitude, this._longitude);

  int get id => _id;
  String get userId => _userId;
  int get postTypeId => _postTypeId;
  DateTime get createdAt => _createdAt;
  String get description => _description;
  String get photoPath => _photoPath;
  String get solvedPhotoPath => _solvedPhotoPath;
  int get statusId => _statusId;
  double get latitude => _latitude;
  double get longitude => _longitude;  


  //Convert a Post object into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["userId"] = _userId;
    data["postTypeId"] = _postTypeId;
    data["createdAt"] = _createdAt;
    data["description"] = _description;
    data["photoPath"] = _photoPath;
    data["solvedPhotoPath"] = _solvedPhotoPath;
    data["statusId"] = _statusId;
    data["latitude"] = _latitude;
    data["longitude"] =_longitude;
 
    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }
  
  //Extract a Post object from a Map object
  Post.fromObject(dynamic data){
    this._id = data["id"];
    this._userId = data["userId"];
    this._postTypeId = data["postTypeId"];
    this._createdAt = data["createdAt"];
    this._description = data["description"];
    this._photoPath = data["photoPath"];
    this._solvedPhotoPath = data["solvedPhotoPath"];
    this._statusId = data["statusId"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
  }

}