import 'dart:convert';
import 'package:async/async.dart';
import 'package:frontend/services/api.services.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


  final  String imageUploadURL = serverURL+ 'ImageUpload';

  final  String imageUploadURLProfilePhoto = serverURL+ 'ImageUpload/ProfilePhoto';
 

imageUpload(File imageFile) async {
 
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length= await imageFile.length();

  var uri = Uri.parse(imageUploadURL);

  var request= new http.MultipartRequest("POST", uri);
  var mulipartFile = new http.MultipartFile('files', stream, length, filename: basename(imageFile.path));

  request.files.add(mulipartFile);
  var response =await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value){
    print(value);
  });

}

imageUploadProfilePhoto(File imageFile) async {
 
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length= await imageFile.length();

  var uri = Uri.parse(imageUploadURLProfilePhoto);

  var request= new http.MultipartRequest("POST", uri);
  var mulipartFile = new http.MultipartFile('files', stream, length, filename: basename(imageFile.path));

  request.files.add(mulipartFile);
  var response =await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value){
    print(value);
  });

}
