class LikeViewModel{
  int _postId;
  int _likeNum;
  int _dislikeNum;
  int _commNum;
  int _isLiked;

  LikeViewModel();
  LikeViewModel.withId(this._postId);

  int get postId => _postId;
  int get likeNum => _likeNum;
  int get dislikeNum => _dislikeNum;
  int get commNum => _commNum;
  int get isLiked => _isLiked;   

  //Convert a City object into a Map object
  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data["postId"] = _postId;
    data["likeNum"] = _likeNum;
    data["dislikeNum"] = _dislikeNum;
    data["commNum"] = _commNum;
    data["isLiked"] = _isLiked;
    return data;
  }

  //Extract a City object from a Map object
  LikeViewModel.fromObject(dynamic data){
    this._postId = data["postId"];
    this._likeNum = data["likeNum"];
    this._dislikeNum = data["dislikeNum"];
    this._commNum = data["commNum"];
    this._isLiked = data["isLiked"];
  }
}