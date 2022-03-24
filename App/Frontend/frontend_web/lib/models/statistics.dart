

class Statistics{
  int _numberOfPosts;
  int _numberOfSolvedPosts;
  int _numberOfUnsolvedPosts;
  int _numberOfUsers;
  int _numberOfInstitutions;
  int _numberOfNewPostsIn24h;
  int _numberOfNewUsersIn24h;
  int _numberOfNewInstitutionIn24h;
  int _numberOfEvents;
  int _numberOfActiveEvents;
  int _numberOfDonations;
  int _numberOfActiveDonations;



  Statistics();

  int get numberOfPosts => _numberOfPosts;
  int get numberOfSolvedPosts => _numberOfSolvedPosts;
  int get numberOfUnsolvedPosts => _numberOfUnsolvedPosts;
  int get numberOfUsers => _numberOfUsers;
  int get numberOfInstitutions => _numberOfInstitutions;
  int get numberOfNewPostsIn24h => _numberOfNewPostsIn24h;
  int get numberOfNewUsersIn24h => _numberOfNewUsersIn24h;
  int get numberOfNewInstitutionIn24h => _numberOfNewInstitutionIn24h;
  int get numberOfEvents => _numberOfEvents;
  int get numberOfActiveEvents => _numberOfActiveEvents;
  int get numberOfDonations => _numberOfDonations;
  int get numberOfActiveDonations => _numberOfActiveDonations;

 

  //Convert a User into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["numberOfPosts"] = _numberOfPosts;
    data["numberOfSolvedPosts"] = _numberOfSolvedPosts;
    data["numberOfUnsolvedPosts"] = _numberOfUnsolvedPosts;
    data["numberOfUsers"] = _numberOfUsers;
    data["numberOfInstitutions"] = _numberOfInstitutions;
    data["numberOfNewPostsIn24h"] = _numberOfNewPostsIn24h;
    data["numberOfNewUsersIn24h"] = _numberOfNewUsersIn24h;
    data["numberOfNewInstitutionIn24h"] = _numberOfNewInstitutionIn24h;
    data["numberOfEvents"] = _numberOfEvents;
    data["numberOfActiveEvents"] = _numberOfActiveEvents;
    data["numberOfDonations"] = _numberOfDonations;
    data["numberOfActiveDonations"] = _numberOfActiveDonations;

    return data;
  }

  //Extract a User object from a Map object
  Statistics.fromObject(dynamic data){
    this._numberOfPosts = data["numberOfPosts"];
    this._numberOfSolvedPosts = data["numberOfSolvedPosts"];
    this._numberOfUnsolvedPosts = data["numberOfUnsolvedPosts"];
    this._numberOfUsers = data["numberOfUsers"];
    this._numberOfInstitutions = data["numberOfInstitutions"];
    this._numberOfNewPostsIn24h = data["numberOfNewPostsIn24h"];
    this._numberOfNewUsersIn24h = data["numberOfNewUsersIn24h"];
    this._numberOfNewInstitutionIn24h = data["numberOfNewInstitutionIn24h"];
    this._numberOfEvents = data["numberOfEvents"];
    this._numberOfActiveEvents = data["numberOfActiveEvents"];
    this._numberOfDonations = data["numberOfDonations"];
    this._numberOfActiveDonations = data["numberOfActiveDonations"];

  }

}
