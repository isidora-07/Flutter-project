class ChallengeSolving{
  int _id;
  int _postId;
  int _institutionId;
  int _userId;
  String _username;
  String _createdAt;
  int _postStatusId;
  String _description;
  String _solvingPhoto;
  String _userPhoto;
  bool _isOwnerOfPost;
  bool _isOwnerOfSolution;
  int _selected;

  ChallengeSolving();
  ChallengeSolving.withId(this._id);

  int get id => _id;
  set id(int id){_id = id;}

  int get postId => _postId;
  set postId(int postId){_postId = postId;}

  int get institutionId =>_institutionId;
  set institutionId(int institutionId){_institutionId = institutionId;}

  int get userId => _userId;
  set userId(int userId){_userId = userId;}

  String get username => _username;
  set username(String username){_username = username;}

  String get createdAt => _createdAt;
  set createdAt(String createdAt){_createdAt = createdAt;}

  int get postStatusId => _postStatusId;
  set postStatusId(int postStatusId){_postStatusId = postStatusId;}

  String get description => _description;
  set description(String description){_description = description;}

  String get solvingPhoto => _solvingPhoto;
  set solvingPhoto(String solvingPhoto){_solvingPhoto = solvingPhoto;}

  String get userPhoto => _userPhoto;
  set userPhoto(String userPhoto){_userPhoto = userPhoto;}

  bool get isOwnerOfPost => _isOwnerOfPost;
  set isOwnerOfPost(bool isOwnerOfPost){_isOwnerOfPost = isOwnerOfPost;}

  bool get isOwnerOfSolution => _isOwnerOfSolution;
  set isOwnerOfSolution(bool isOwnerOfSolution){_isOwnerOfSolution = isOwnerOfSolution;}

  int get selected => _selected;
  set selected(int selected){_selected = selected;}

  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["id"] = _id;
    data["postId"] = _postId;
    data["institutionId"] = _institutionId;
    data["userId"] = _userId;
    data["username"] = _username;
    data["createdAt"] = _createdAt;
    data["postStatusId"] = _postStatusId;
    data["description"] = _description;
    data["solvingPhoto"] = _solvingPhoto;
    data["userPhoto"] = _userPhoto;
    data["isOwnerOfPost"] = _isOwnerOfPost;
    data["isOwnerOfSolution"] =_isOwnerOfSolution;
    data["selected"] =_selected;
    
    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }
  
  //Extract a Post object from a Map object
  ChallengeSolving.fromObject(dynamic data){

    this._id = data["id"];
    this._postId = data["postId"];
    this._institutionId = data["institutionId"];
    this._userId = data["userId"];
    this._username = data["username"];
    this._createdAt = data["createdAt"];
    this._postStatusId = data["postStatusId"];
    this._description = data["description"];
    this._solvingPhoto = data["solvingPhoto"];
    this._userPhoto = data["userPhoto"];
    this._isOwnerOfPost = data["isOwnerOfPost"];
    this._isOwnerOfSolution = data["isOwnerOfSolution"];
    this._selected = data["selected"];
  }

}