import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

  //String serverURLPhoto = 'http://147.91.204.116:2043/';
  String serverURLPhoto = 'http://10.0.2.2:60676//';
  //String serverURLPhoto = 'http://192.168.1.8:45455//';
  //String serverURLPhoto = 'http://192.168.1.4:45457//';
  final storage = FlutterSecureStorage();

  //String serverURL = 'http://147.91.204.116:2043/api/';
  String serverURL = 'http://10.0.2.2:60676/api/';
  // String serverURL = 'http://192.168.1.8:45455/api/';
  //String serverURL = 'http://192.168.1.4:45457/api/';

class APIServices
{


  static Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  //return all posts
  static Future getPost(String jwt) async{
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL +'Post/userID='+userId.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }

  //return all posts from a specific user
  static Future getPostsForUser(String jwt, int userId1) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Post/UsersPosts';
    var data = Map();
    data["id"] = userId1;
    data["userID"] = userId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    },body: jsonBody);
  }

  static Future getUser(String jwt, int userId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL +'User/'+userId.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }); 
  }

  //send a new post to the database
  static Future<String> addPost (String jwt, int userId, int postTypeId, String description, String photoPath,String photoPath2,  int statusId, double latitude, double longitude, String address, int cityId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Post';
    var data = Map();
    data["userId"] = userId;
    data["postTypeId"] = postTypeId;
    data["description"] = description;
    data["photoPath"] = photoPath;
    data["solvedPhotoPath"] = photoPath2;
    data["statusId"] = statusId;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["address"] = address;
    data["cityId"] = cityId;
    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    String data2 = res.body.toString();
    print(data2);
    return data2;
  }

  //send a new like to the database
  static Future<String> addLike(String jwt, int postId, int userId, int typeId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Like';
    var data = Map();
    data["postId"] = postId;
    data["userId"] = userId;
    data["likeTypeId"] = typeId;
    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    String data2 = res.body.toString();
    return data2;
  }

  //return all comments on one post
  static Future getComments(String jwt, int postId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL +'Comment/'+postId.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }

  //send a new comment to the database
  static Future<String> addComment(String jwt, String comm, int userId, int postId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Comment';
    var data = Map();
    data["description"] = comm;
    data["userId"] = userId;
    data["postId"] = postId;
    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    String data2 = res.body.toString();
    return data2;
  }

  //return types of posts (example smeće, rupe...)
  static Future getPostType(String jwt) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL +'PostType', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  // Login funtion
  static Future login(String mail, String password) async{
    String url = serverURL + 'User/Login';
    var body = jsonEncode({ 'email': mail, 'password': password });
    print(url);
    var res =await http.post(url,headers: {"Content-Type": "application/json"},body: body);
    if(res.statusCode == 200) return res.body;
    return null;
  
  }

  static Future registration(User user) async  {
   String url = serverURL + 'User/Register';
    var data = Map();
    data["firstName"] = user.firstName;
    data["lastName"] = user.lastName;
    data["username"] = user.username;
    data["email"] = user.email;
    data["phone"] = user.phone;
    data["cityId"] = user.cityId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    return await http.post(url, headers: header, body: jsonBody);
  }

  //fetch method for cities
  static Future getCity() async{

    return await http.get(serverURL + 'City', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
  }
  
  
	static Future editUser(String jwt, int id, String firstName, String lastName, String username, String email, String phone, int city) async  {
		var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'User/EditUserData';
		var data = Map();
		data["id"] = id;
		data["firstName"] = firstName;
		data["lastName"] = lastName;
		data["username"] = username;
		data["email"] = email;
		data["phone"] = phone;
    data["cityId"] = city;
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
	}

  static Future editUserPassword(String jwt, int id, String password, String password1) async  {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
		String url = serverURL + 'User/EditUserPassword';
		var data = Map();
		data["id"] = id;
		data["password"] = password;
		data["password1"] = password1;
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
	}


  static Future dislikeInPost(String jwt, int postId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Like/DislikeInPost';
    var data = Map();
    data["id"] = postId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
 
  }
  static Future likeInPost(String jwt, int postId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Like/LikeInPost';
    var data = Map();
    data["id"] = postId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  static Future getSolvedPosts(String jwt) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
     return await http.get(serverURL +'Post/SolvedPosts/userID='+userId.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getUnsolvedPosts(String jwt) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
     return await http.get(serverURL +'Post/UnsolvedPosts/userID='+userId.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

   static Future editProfilePhoto(String jwt, int userId, String photo) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'User/EditUserPhoto';
    var data = Map();
    data["id"] = userId;
    data["photo"] = photo;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    print("bodYY "+ res.body);
    return res.body;
  }

  static Future<String> jwtOrEmpty() async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }
  
  static Future getReportType(String jwt) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL +'ReportType', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }

   static Future addReport(String jwt, int userId, int reportedUserId, int reportTypeId, String description) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Report/Insert';
    var data = Map();
    data["reportingUserId"] = userId;
    data["reportedUserId"] = reportedUserId;
    data["reportTypeId"] = reportTypeId;
    data["description"] = description;
    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    //String data2 = res.body.toString();    
    return res;
  }
  
   static Future getCityById(String jwt, int cityId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL + 'City/$cityId',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future deletePost(String jwt, int postId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    var map = Map();
    map['id'] = postId;
    var jsonBody = convert.jsonEncode(map);
    return await http.post(serverURL + 'Post/Delete', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  static Future editPost(String jwt, int postId, String description) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    var map = Map();
    map['id'] = postId;
    map['description'] = description;
    var jsonBody = convert.jsonEncode(map);
    return await http.post(serverURL + 'Post/editPost', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  static Future deleteComment(String jwt, int id) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Comment/Delete';
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: convert.jsonEncode({ 'id' : id, }));
  }

  static Future addReportComment(String jwt, int commentId, int userId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'ReportComment/Insert';
    var data = Map();
    data["commentId"] = commentId;
    data["userID"] = userId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res;
  }

  static Future getEvents(String jwt, int userId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL + 'Event/userId=$userId',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getDonations(String jwt) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL + 'Donation',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  
  static Future getUsersFromEvent(String jwt, int eventId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event/UserForEvent';
    var data = Map();
    data["id"] = eventId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res.body;
  }

  static Future getUsersFromDonation(String jwt, int donationId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Donation/UserForDonation';
    var data = Map();
    data["id"] = donationId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res.body;
  }

  static Future joinEvent(String jwt, int eventId, int userId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event/addGoingToEvent';
    var data = Map();
    data["eventId"] = eventId;
    data["userId"] = userId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res;
  }

  static Future leaveEvent(String jwt, int eventId, int userId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event/CancelArrival';
    var data = Map();
    data["eventId"] = eventId;
    data["userId"] = userId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res;
  }

  static Future addDonation(String jwt, int donationId, int userId, int donatedPoints) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Donation/addParcipate';
    var data = Map();
    data["donationId"] = donationId;
    data["userId"] = userId;
    data["donatedPoints"] = donatedPoints;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res;
  }

  static Future getChallengeSolving(String jwt, int postId, int userId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL + 'ChallengeSolving/postId=$postId/userId=$userId',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future challengeSolvingDelete(String jwt, int solvingPostId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'ChallengeSolving/Delete';
    var data = Map();
    data["id"] = solvingPostId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res;
  }

  static Future challengeSolving(String jwt, int solvingPostId, int postId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'ChallengeSolving/solvingChallenge';
    var data = Map();
    data["id"] = solvingPostId;
    data["postId"] = postId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res;
  }

  static Future insertSolution (String jwt, int userId, int postId, String description, String photoPath, int selected) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'ChallengeSolving';
    var data = Map();
    data["userId"] = userId;
    data["postId"] = postId;
    data["description"] = description;
    data["solvingPhoto"] = photoPath;
    data["selected"] = selected;
    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    return res;
  }

  static Future deleteUser(String jwt, int userId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'User/Delete';
    var data = Map();
    data["id"] = userId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    print(res.statusCode);
    return res;
  }

    static Future getTop10(String jwt, int cityId1) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'User/Top10';
    var data = Map();
    data["cityId"] = cityId1;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    },body: jsonBody);
  }

  static Future getPostById(String jwt, int postId, int userId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL + 'Post/GetById/postId=$postId/userId=$userId',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future forgottenPassword(String email) async  {
   String url = serverURL + 'User/ForgetPassword';
    var data = Map();
    data["email"] = email;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    return await http.post(url, headers: header, body: jsonBody);
  }

    static Future getPostByCityId(String jwt, int id) async{
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL +'Post/ByCityId/userId='+userId.toString()+'/cityId='+id.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }

  
    static Future getUnsolvedPostByCityId(String jwt, int id) async{
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL +'Post/UnsolvedPostsByCityId/userId='+userId.toString()+'/cityId='+id.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }
  
    static Future getSolvedPostByCityId(String jwt, int id) async{
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL +'Post/SolvedPostsByCityId/userId='+userId.toString()+'/cityId='+id.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }

    static Future getNicePostByCityId(String jwt, int id) async{
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL +'Post/NicePostsByCityId/userId='+userId.toString()+'/cityId='+id.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }

  static Future getEventsByCityId(String jwt, int userId, int cityId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL + 'Event/byCityId='+cityId.toString()+'/userId=$userId',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

    static Future getNotificationForUser(String jwt, int id) async{
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL +'Notification/userId='+userId.toString(),headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });  
  }

    static Future getPostsSolvedByInstitution(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var jbody = jsonEncode({'id' : id.toString()});
    return await http.post(serverURL + 'Post/PostsSolvedByInstitution', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body : jbody);
  }

    static Future getInstitutionById(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Institution/' + id.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getInstitutionsForEvent(String jwt, int eventId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    var data = Map();
    data["id"] = eventId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(serverURL + 'Event/InstitutionsForEvent', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  	static Future switchThemeForUser(String jwt, int id) async  {
		var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'User/SwitchTheme';
		var data = Map();
		data["id"] = id;
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
	}
 
    static Future  getCityFromName(String jwt, String name) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    var data = Map();
    data["name"] = name;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(serverURL + 'City/GetCityFromName', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }
}