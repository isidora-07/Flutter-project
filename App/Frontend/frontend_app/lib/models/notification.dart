class NotificationModel{

  
  int _postId;
  int _institutionId;
  int _userId;
  String _username;
  String _createdAtString;
  String _photoPath;
  String _userPhoto;
  int _typeNotification;

  NotificationModel();


  int get userId => _userId;
  int get institutionId => _institutionId;
  int get postId => _postId;
  String get username => _username;
  String get photoPath => _photoPath;
  String get createdAtString => _createdAtString;
  String get userPhoto => _userPhoto;
  int get typeNotification => _typeNotification;


  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();
    data["postId"] = _postId;
    data["institutionId"] = _institutionId;
    data["userId"] = _userId;
    data["username"] = _username;
    data["createdAtString"] = _createdAtString;
    data["photoPath"] = _photoPath;
    data["userPhoto"] = _userPhoto;
    data["typeNotification"] =_typeNotification;
    
    return data;
  }
  
  //Extract a Post object from a Map object
  NotificationModel.fromObject(dynamic data){

    
    this._postId = data["postId"];
    this._institutionId = data["institutionId"];
    this._userId = data["userId"];
    this._username = data["username"];
    this._createdAtString = data["createdAtString"];
    this._photoPath = data["photoPath"];
    this._userPhoto = data["userPhoto"];
    this._typeNotification = data["typeNotification"];
  }

}