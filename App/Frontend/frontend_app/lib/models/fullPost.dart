class FullPost
{
   
  int _postId;
  int _userId; 
  String _username;
  int _postTypeId;
  String _typeName;
  DateTime _createAt; //time the post was posted
  String _description;
  String _photoPath; 
  String _solvedPhotoPath; 
  int _statusId;
  String _status; // 'reseno' or 'nereseno'
  int _likeNum; //number of likes
  int _dislikeNum; //number of dislikes
  int _commNum;
  double _latitude;
  double _longitude;
  String _userPhoto;
  String _address;
  int _isLiked;
  
  FullPost.nothing();
  FullPost(this._postId, this._userId, this._username,this._postTypeId,this._typeName,this._createAt,this._description,this._photoPath,this._statusId,this._status,this._likeNum,this._dislikeNum, this._commNum, this._latitude, this._longitude, this._userPhoto, this._address, this._solvedPhotoPath);
 

  int get postId => _postId;
  set postId(int postId){_postId = postId;}
  int get userId => _userId;
  set userId(int userId){_userId = userId;}
  String get username => _username;
  set username(String username){_username = username;}
  int get postTypeId => _postTypeId;
  set postTypeId(int postTypeId){_postTypeId = postTypeId;}
  String get typeName => _typeName;
  set typeName(String typeName){_typeName = typeName;}
  DateTime get createAt => _createAt;
  set createAt(DateTime createAt){_createAt = createAt;}
  String get description => _description;
  set description(String description){_description = description;}
  String get photoPath => _photoPath;
  set photoPath(String photoPath){_photoPath = photoPath;}
   String get solvedPhotoPath => _solvedPhotoPath;
  set solvedPhotoPath(String solvedPhotoPath){_solvedPhotoPath = solvedPhotoPath;}
  int get statusId => _statusId;
  set statusId(int statusId){_statusId = statusId;}
  String get status => _status;
  set status(String status){_status = status;}
  int get likeNum => _likeNum;
  set likeNum(int likeNum){_likeNum = likeNum;}
  int get dislikeNum => _dislikeNum;
  set dislikeNum(int dislikeNum){_dislikeNum = dislikeNum;}
  int get commNum => _commNum;
  set commNum(int commNum){_commNum = commNum;}
  double get latitude => _latitude;
  set latitude(double latitude){_latitude = latitude;}
  double get longitude => _longitude;
  set longitude(double longitude){_longitude = longitude;}
  String get userPhoto => _userPhoto;
  set userPhoto(String userPhoto){_userPhoto = userPhoto;}
  String get address => _address;
  set address(String address){_address = address;}
  int get isLiked => _isLiked;
  set isLiked(int isLiked){_isLiked = isLiked;}

 //saljemo kao json fajl
  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["postId"] = _postId;
    map["userId"] = _userId;
    map["username"] = _username;
    map["postTypeId"] = _postTypeId;
    map["typeName"] = _typeName;
    map["createAt"] = _createAt;
    map["description"] = _description;
    map["photoPath"] = _photoPath;
    map["solvedPhotoPath"] = _solvedPhotoPath;
    map["statusId"] = _statusId;
    map["status"] = _status;
    map["likeNum"] = _likeNum;
    map["dislikeNum"] = _dislikeNum;
    map["commNum"] = _commNum;
    map["latitude"] = _latitude;
    map["longitude"] =_longitude;
    map["userPhoto"] =_userPhoto;
    map["address"] =_address;
    map["isLiked"] =_isLiked;
   
    return map;
  }

  //pretvaramo iz json-a u object 
  FullPost.fromObject(dynamic data)
  {
    this._postId = data["postId"];
    this._userId = data["userId"];
    this._username = data["username"];
    this._postTypeId = data["postTypeId"];
    this._typeName = data["typeName"];
    this._createAt = data["createAt"];
    this._description = data["description"] ;
    this._photoPath = data["photoPath"];
    this._solvedPhotoPath = data["solvedPhotoPath"];
    this._statusId = data["statusId"];
    this._status = data["status"];
    this._likeNum = data["likeNum"];
    this._dislikeNum = data["dislikeNum"];
    this._commNum = data["commNum"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
    this._userPhoto = data["userPhoto"];
    this._address = data["address"];
    this._isLiked = data["isLiked"];
  }
}