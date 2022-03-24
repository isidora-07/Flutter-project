class ReportType
{
  int _id;
  String _typeName;
  String _description;

  ReportType(this._id, this._typeName, this._description);

  int get id => _id;
  String get typeName => _typeName;
  String get description => _description;

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["id"] = _id;
    map["typeName"] = _typeName;
    map["description"] = _description;
	
    return map;
  }

  //pretvaramo iz json-a u object 
  ReportType.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._typeName = data["typeName"];
	this._description = data["description"];
  }
}