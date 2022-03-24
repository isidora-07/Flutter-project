import 'package:flutter/material.dart';
import 'package:frontend_web/models/admin.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/statisticsPage/statisticsPage.dart';
import 'dart:convert';


int globalAdminId;

class HomePage extends StatefulWidget {
 HomePage(this.jwt, this.payload);
  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;
  @override
  _HomePageState createState() => new _HomePageState(jwt, payload);
}
User globalUser;


class _HomePageState extends State<HomePage> {
    final String jwt;
  final Map<String, dynamic> payload;
  _HomePageState(this.jwt, this.payload);

  Admin admin1;
  List<FullPost> listPosts;

  _getAdmin() async {
    int userId1 = int.parse(payload['sub']);
    var res = await APIServices.getAdmin(TokenSession.getToken,userId1);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Admin admin = Admin.fromObject(jsonUser);
    setState(() {
      admin1 = admin;
      globalAdminId=userId1;
    });
  }
  _getPosts() async {
     APIServices.getPost(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listPosts = listP;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getAdmin();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return StatisticsPage();
  }
}
