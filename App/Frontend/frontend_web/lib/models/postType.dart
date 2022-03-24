class PostType{
  int _id;
  String _typeName;

  PostType(this._id, this._typeName);

  int get id => _id;
  String get typeName => _typeName;


  //Convert a postType object into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["typeName"] = _typeName;

    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  //Extract a postType object from a Map object
  PostType.fromObject(dynamic data){
    this._id = data["id"];
    this._typeName = data["typeName"];
  }
}