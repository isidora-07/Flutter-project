class Events{

  int _id;
  int _institutionId;
  int _adminId;
  String _organizeName;
  int _cityId;
  String _cityName;
  String _startDate;
  String _endDate;
  String _shortDescription;
  double _latitude;
  double _longitude;
  String _address;
  String _title;
  String _description;
  int _userNum;
  int _isGoing;


  Events();
  Events.withId(this._id);

  int get id => _id;
  set id(int id){_id = id;}

  int get institutionId => _institutionId;
  set institutionId(int institutionId){_institutionId = institutionId;}

  int get adminId => _adminId;
  set adminId(int adminId){_adminId = adminId;}

  String get organizeName => _organizeName;
  set organizeName(String organizeName){_organizeName = organizeName;}

  int get cityId => _cityId;
  set cityId(int cityId){_cityId = cityId;}

  String get cityName => _cityName;
  set cityName(String cityName){_cityName = cityName;}

  String get startDate => _startDate;
  set startDate(String startDate){_startDate = startDate;}

  String get endDate => _endDate;
  set endDate(String endDate){_endDate = endDate;}

  String get shortDescription => _shortDescription;
  set shortDescription(String shortDescription){_shortDescription = shortDescription;}

  double get latitude => _latitude;
  set latitude(double latitude){_latitude = latitude;}
  
  double get longitude => _longitude;
  set longitude(double longitude){_longitude = longitude;}

  String get address => _address;
  set address(String address){_address = address;}

  String get title => _title;
  set title(String title){_title = title;}

  String get description => _description;
  set description(String description){_description = description;}

  int get userNum => _userNum;
  set userNum(int userNum){_userNum = userNum;}

  int get isGoing => _isGoing;
  set isGoing(int isGoing){_isGoing = isGoing;}

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["id"] = _id;
    map["institutionId"] = _institutionId;
    map["adminId"] = _adminId;
    map["organizeName"] = _organizeName;
    map["cityId"] = _cityId;
    map["cityName"] = _cityName;
    map["startDate"] = _startDate;
    map["endDate"] = _endDate;
    map["shortDescription"] = _shortDescription;
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["address"] = _address;
    map["title"] = _title;
    map["description"] = _description;
    map["userNum"] = _userNum;
    map["isGoing"] = _isGoing;
    return map;
  }

  //pretvaramo iz json-a u object 
  Events.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._institutionId = data["institutionId"];
    this._adminId = data["adminId"];
    this._organizeName = data["organizeName"];
    this._cityId = data["cityId"];
    this._cityName = data["cityName"];
    this._startDate = data["startDate"];
    this._endDate = data["endDate"];
    this._shortDescription = data["shortDescription"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
    this._address = data["address"];
    this._title = data["title"];
    this._description = data["description"];
    this._userNum = data["userNum"];
    this._isGoing = data["isGoing"];
  }
}