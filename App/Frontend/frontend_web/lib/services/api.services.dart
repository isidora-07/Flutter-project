import 'dart:convert' as convert;
import 'dart:convert';
import 'package:frontend_web/models/admin.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/models/postType.dart';
import 'package:http/http.dart' as http;

//String userPhotoURL = "http://147.91.204.116:2043/";
String userPhotoURL = "http://127.0.0.1:60676//";

class APIServices {
  //static String serverURL = 'http://147.91.204.116:2043/api/';
  static String serverURL = 'http://127.0.0.1:60676/api/';

  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  static Future getReportedUsers(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Report', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  // reported users with id
  static Future getReportedUser(String jwt, int userId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Report/' + userId.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  // users from cityId
  static Future getUsersFromCity(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var body = jsonEncode({'cityId' : cityId.toString()});
    return await http.post(serverURL + 'User/UsersByCityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: body);
  }
  
  //reported users from cityId
  static Future getReportedUsersFromCity(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var body = jsonEncode({'cityId' : cityId.toString()});
    return await http.post(serverURL + 'Report/ReportByCityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: body);
  }

  static Future getAdmin(String jwt, int userId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Admin/' + userId.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  // Login funtion
  static Future login(String mail, String password) async {
    String url = serverURL + 'Admin/Login';
    var body = jsonEncode({'email': mail, 'password': password});
    var res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  static Future registration(Admin user) async {
    String url = serverURL + 'Admin/Register';
    var data = Map();
    data["firstName"] = user.firstName;
    data["lastName"] = user.lastName;
    data["password"] = user.password;
    data["email"] = user.email;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    return await http.post(url, headers: header, body: jsonBody);
  }

  //fetch method for cities
  static Future getCity(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'City',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

   static Future getCity1() async {
        return await http.get(serverURL + 'City',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
  }

  //returns user with specific id for deletion
  static Future deleteUser(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = serverURL + 'User/Delete';
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }, body: convert.jsonEncode({
          'id': id,
        }));
  }

  //returns post with specific id for deletion
  static Future deletePost(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = serverURL + 'Post/Delete';
    return await http.post(
      url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    },  body: jsonEncode({
        'id': id,
      }),
    );
  }

  static Future getUsers(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'User',  headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  //return all posts
  static Future getPost(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Post/userID='+(0).toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  //return all posts from a specific user
  static Future getPostsForUser(String jwt, int userId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Post/UsersPosts';
    var data = Map();
    data["id"] = userId;
    data["userID"] = 0;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
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
    return await http.get(serverURL + 'Comment/' + postId.toString(), headers: {
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
  static Future getPostType(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'PostType',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getSolvedPosts(String jwt) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
     return await http.get(serverURL +'Post/SolvedPosts/userID='+0.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getUnsolvedPosts(String jwt) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
     return await http.get(serverURL +'Post/UnsolvedPosts/userID='+ 0.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  
  
// institution registratiton
static Future registerInstitution(Institution ins) async {
  String url = serverURL + 'Institution/Register';
  var data = Map();
  data["name"] = ins.name;
  data["description"] = ins.description;
  data["email"] = ins.email;
  data["password"] = ins.password;
  data["cityId"]  = ins.cityId;
  data["phone"] = ins.phone;
  var jbody = convert.jsonEncode(data);
  print(jbody);
  return await http.post(url, headers: header, body: jbody);
  
  }

   // get inst
  static Future getInstitutionById(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Institution/' + id.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  
  // editData ins

  static Future editInstitutionData(String jwt, int id, String name, String email, String phone, String description, int cityId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Institution/EditData';
    var data = Map();
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["description"] = description;
    data["cityId"] = cityId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  static Future editInstitutionPassword(String jwt, int id, String password, String password1) async {

    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Institution/EditPassword';
    var data = Map();
    data["id"] = id;
    data["password"] = password;
    data["password1"] = password1;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

    static Future getAllUnauthInstitutions(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Institution/Unauthorized',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

    static Future getAllAuthInstitutions(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Institution',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  
   static Future deleteInstitution(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = serverURL + 'Institution/Delete';
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }, body: convert.jsonEncode({
          'id': id,
        }));
  }

   static Future acceptInstitution(String jwt, int id, String email) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = serverURL + 'Institution/AcceptInstitution';
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }, body: convert.jsonEncode({
          'id': id,
          'email': email
        }));
  }
     static Future editInstitutionProfilePhoto(String jwt, int userId, String photo) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Institution/EditProfilePhoto';
    var data = Map();
    data["id"] = userId;
    data["photoPath"] = photo;
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

  static Future<String> addImageWeb(String img) async {
    print("pocetak ovoga");
    var url = serverURL + 'ImageUpload/test';
    var map = Map();
    map['img'] = img;
    var putBody = json.encode(map);
    var res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: putBody);
    print(res.statusCode);
    print(res.body);
    print("kraj ovoga");
    // print("*************************************************************");
    // print(res.statusCode);
    print(res.body);
    return res.body;
  }
  
  static Future getInstitutionUnsolvedFromCityId(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Post/UnsolvedPostsByCityId/userId='+(0).toString() + '/cityId=' + cityId.toString(), headers: {
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

  static Future deleteDonation(String jwt, int donationId) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Donation/Delete';
    var data = Map();
    data["id"] = donationId;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    
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

  //get events
  static Future getEvents(String jwt, int userId) async{
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Event/userId=$userId',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  
   static Future createEvent(String jwt, int adminId, int institutionId, String nameEvent, String shortDesc, String longDesc, String location, int cityId, String startDate, String endDate, double latitude, double longitude) async  {
		var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event';
		var data = Map();
    data["cityId"] = cityId;
    data["adminId"] = adminId != 0 ? adminId : null;
    data["institutionId"] = institutionId != 0 ? institutionId : null;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["shortDescription"] = shortDesc;
    data["startDate"] = startDate;
    data["endDate"] = endDate;
    data["address"] = location;
		data["description"] = longDesc;
		data["title"] = nameEvent;
    
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
	}

  static Future createDonation(String jwt, int adminId, String title, String organizationName, String description, double monetaryAmount) async  {
		var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Donation';
		var data = Map();
    data["adminId"] = adminId;
		data["title"] = title;
		data["organizationName"] = organizationName;
		data["description"] = description;
		data["monetaryAmount"] = monetaryAmount;
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
	}

  static Future removeEvent(String jwt, int eventId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event/Delete';
    var data = Map();
    data['id'] = eventId;
    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    return res;
  }

  static Future addNewCity(String jwt, String name, double latitude, double longitude) async  {
		var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'City';
		var data = Map();
    data["name"] = name;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
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
	
	// solve a post as institution

  static Future solveFromTheInstitution(String jwt, int postId, int institutionId, String description, String photo) async {

    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'ChallengeSolving/solutionFromTheInstitution';

    var data = Map();
    data['postId'] = postId;
    data['institutionId'] = institutionId;
    data['description'] = description;
    data['solvingPhoto'] = photo;

    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    return res;
  }
  
  
    static Future getAdmins(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Admin',  headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  
  // solved by inst

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

  static Future editDonationData(String jwt, int id, int adminId, String title, String organizationName, String description, double monetaryAmount) async  {
		var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Donation/editDonation';
		var data = Map();
    data["id"] = id;
    data["adminId"] = adminId;
		data["title"] = title;
		data["organizationName"] = organizationName;
		data["description"] = description;
		data["monetaryAmount"] = monetaryAmount;
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
	}

   static Future<String> addImageWebSolution(String img) async {
    var url = serverURL + 'ImageUpload/WebSolution';
    var map = Map();
    map['img'] = img;
    var putBody = json.encode(map);
    var res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: putBody);
    print("kraj ovoga");
    print(res.body);
    return res.body;
  }

  static Future editEventData(String jwt, int id, String nameEvent, String shortDesc, String longDesc, String location, int cityId, String startDate, String endDate, double latitude, double longitude) async  {
		var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event/editEvent';
		var data = Map();
    data["id"] = id;
    data["cityId"] = cityId;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["shortDescription"] = shortDesc;
    data["startDate"] = startDate;
    data["endDate"] = endDate;
    data["address"] = location;
		data["description"] = longDesc;
		data["title"] = nameEvent;
		var jsonBody = convert.jsonEncode(data);
		print(jsonBody);
		return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
	}
	
	
//Admin

  static Future editAdminData(String jwt, int id, String firstName, String lastName, String email) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Admin/EditAdminData';
    var data = Map();
    data["id"] = id;
    data["firstName"] = firstName;
    data["lastName"] = lastName;
    data["email"] = email;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

 static Future editAdminProfilePhoto(String jwt, int userId, String photo) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Admin/EditPhoto';
    var data = Map();
    data["id"] = userId;
    data["photoPath"] = photo;
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

    static Future editAdminPassword(String jwt, int id, String password, String password1) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Admin/editAdminPassword';
    var data = Map();
    data["id"] = id;
    data["password"] = password;
    data["password1"] = password1;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }
  
    static Future deleteAdmin(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = serverURL + 'Admin/Delete';
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }, body: convert.jsonEncode({
          'id': id,
        }));
  }

  static Future getStatistics(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Statistics', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  static Future getLastDonation(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Donation/GetLastDonation', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getTop10(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Statistics/Top10', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  static Future getMonthlyUsers(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Statistics/MonthlyUsers', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  // filter
  static Future getFiltered(String jwt, List<int> list, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var jbody = jsonEncode({'listFilter': list, 'cityId':cityId});

    print(jbody);
    var res =  await http.post(serverURL + 'Post/UnsolvedPostsByFilter',  headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jbody);
    return res;
  }

  static Future getPostsByCityId(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    return await http.get(serverURL + 'Post/ByCityId/userId=1/cityId=$cityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getPostsUnsolveddByCityId(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    return await http.get(serverURL + 'Post/UnsolvedPostsByCityId/userId=1/cityId=$cityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getPostsSolvedByCityId(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    return await http.get(serverURL + 'Post/SolvedPostsByCityId/userId=1/cityId=$cityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  //get method for users who are going for certain event
  static Future getUsersForEvent(String jwt, int eventId) async{
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    var data = Map();
    data["id"] = eventId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(serverURL + 'Event/UserForEvent' , headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  //get method for institutions that are going for certain event
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

  static Future getFinishedEvents(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    return await http.get(serverURL + 'Event/FinishedEvent', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getFinishedDonations(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    return await http.get(serverURL + 'Donation/FinishedDonation', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getInstitutionByCityId(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    return await http.get(serverURL + 'Institution/ByCityId/userId=1/cityId=$cityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getInstitutionByCityIdAuth(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    data["cityId"] = cityId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(serverURL + 'Institution/AuthorizedByCityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  static Future getInstitutionByCityIdUnauth(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    data["cityId"] = cityId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(serverURL + 'Institution/UnauthorizedByCityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  static Future getEventsByCity(String jwt, int instId,int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    //ByCityForWeb/cityId=$cityId/instId=$instId
    return await http.get(serverURL + 'Event/ForWeb/instId=$instId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future joinEvent(String jwt, int eventId, int institutionId) async{
    var datas  = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event/addGoingToEvent';
    var data = Map();
    data["eventId"] = eventId;
    data["institutionId"] = institutionId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

  static Future leaveEvent(String jwt, int eventId, int institutionId) async{
    var datas  = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Event/CancelArrival';
    var data = Map();
    data["eventId"] = eventId;
    data["institutionId"] = institutionId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }
}

