class Comment{
  int _id;
  int _postId;
  int _userId;
  String _description;
  String _username;
  String _photoPath;
  String _date;
  int _reportNum;

  Comment();
  Comment.full(this._id, this._username, this._postId, this._userId, this._description, this._photoPath, this._date);

  int get id => _id;
  String get username => _username;
  int get postId => _postId;
  int get userId => _userId;
  int get reportNum => _reportNum;
  String get description => _description;
  String get photoPath => _photoPath;
  String get date => _date;

  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["postId"] = _postId;
    data["userId"] = _userId;
    data["description"] = _description;
    data["photoPath"] = _photoPath;
    data["date"] = _date;
    data["reportNum"] = _reportNum;

    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  Comment.fromObject(dynamic data){
    this._id = data["id"];
    this._postId = data["postId"];
    this._userId = data["userId"];
    this._description = data["description"];
    this._username = data["username"];
    this._photoPath = data["photoPath"];
    this._date = data["date"];
    this._reportNum = data["reportNum"];
  }
}