class Donation{

  int _id;
  int _adminId;
  String _title;
  String _organizationName;
  String _description;
  int _pointsNeeded;
  int _pointsAccumulated;
  int _userNum;


  Donation();
  Donation.withId(this._id);

  int get id => _id;
  set id(int id){_id = id;}

  int get adminId => _adminId;
  set adminId(int adminId){_adminId = adminId;}

  String get title => _title;
  set title(String title){_title = title;}

  String get organizationName => _organizationName;
  set organizationName(String organizationName){_organizationName = organizationName;}

  String get description => _description;
  set description(String description){_description = description;}

  int get userNum => _userNum;
  set userNum(int userNum){_userNum = userNum;}

  int get pointsNeeded => _pointsNeeded;
  set pointsNeeded(int pointsNeeded){_pointsNeeded = pointsNeeded;}

  int get pointsAccumulated => _pointsAccumulated;
  set pointsAccumulated(int pointsAccumulated){_pointsAccumulated = pointsAccumulated;}

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["id"] = _id;
    map["adminId"] = _adminId;
    map["title"] = _title;
    map["organizationName"] = _organizationName;
    map["description"] = _description;
    map["pointsNeeded"] = _pointsNeeded;
    map["pointsAccumulated"] = _pointsAccumulated;
    map["userNum"] = _userNum;
    return map;
  }

  //pretvaramo iz json-a u object 
  Donation.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._adminId = data["adminId"];
    this._title = data["title"];
    this._organizationName = data["organizationName"];
    this._description = data["description"];
    this._pointsNeeded = data["pointsNeeded"];
    this._pointsAccumulated = data["pointsAccumulated"];
    this._userNum = data["userNum"];
  }
}