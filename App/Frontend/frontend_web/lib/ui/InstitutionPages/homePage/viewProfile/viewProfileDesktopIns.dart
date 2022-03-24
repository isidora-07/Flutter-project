import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewRowPost.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostDesktop.dart';
import 'package:frontend_web/widgets/post/rowPostWidget.dart';
import 'package:frontend_web/widgets/userProfile/userProfileInsWidget.dart';
import 'package:frontend_web/widgets/userProfile/userProfileWidget.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewUserProfileDesktopIns extends StatefulWidget {
  
  final int userId;
  ViewUserProfileDesktopIns(this.userId);

  @override
  _ViewUserProfileDesktopInsState createState() => _ViewUserProfileDesktopInsState(userId);
}

class _ViewUserProfileDesktopInsState extends State<ViewUserProfileDesktopIns> {
  
  int userId;
  User user;
  ScrollController _scrollController;
  List<FullPost> posts;
  
  _ViewUserProfileDesktopInsState(int userId1){
    this.userId = userId1;
  }

  _getPosts() async {
    APIServices.getPostsForUser(TokenSession.getToken, userId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          posts = listP;
        });
      }
    });
  }

  _getUser() async {
    APIServices.getUser(TokenSession.getToken, userId).then((res) {
      Map<String, dynamic> jsonUser = jsonDecode(res.body);
      User otherUser1 = User.fromObject(jsonUser);
      setState(() {
        user = otherUser1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: <Widget>[
      CenteredViewRowPost(
        child: Column(children: <Widget>[
          (user != null) ? UserInfoInsWidget(user)
            : Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(greenPastel),
                ),
              ),
          Expanded( child: ListView.builder(
            padding: EdgeInsets.only(bottom: 30.0),
            itemCount: posts == null ? 0 : posts.length,
            itemBuilder: (BuildContext context, int index) {
              return InsRowPostDesktopWidget(posts[index], 2);
            }
          ))
        ],)
      ),
      CollapsingInsNavigationDrawer()
    ],);
  }
}