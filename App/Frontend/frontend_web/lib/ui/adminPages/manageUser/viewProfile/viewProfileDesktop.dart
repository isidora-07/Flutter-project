import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewRowPost.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/widgets/post/rowPostWidget.dart';
import 'package:frontend_web/widgets/userProfile/userProfileWidget.dart';


Color greenPastel = Color(0xFF00BFA6);

class ViewUserProfileDesktop extends StatefulWidget {
  
  final User user;
  ViewUserProfileDesktop(this.user);

  @override
  _ViewUserProfileDesktopState createState() => _ViewUserProfileDesktopState(user);
}

class _ViewUserProfileDesktopState extends State<ViewUserProfileDesktop> {
  
  User user;
  ScrollController _scrollController;
  List<FullPost> posts;
  
  _ViewUserProfileDesktopState(User user1){
    this.user = user1;
  }

  _getPosts() async {
    APIServices.getPostsForUser(TokenSession.getToken, user.id).then((res) {
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

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(children: <Widget>[
      CenteredViewRowPost(
        child: Column(children: <Widget>[
          UserInfoWidget(user),
          Expanded( child: ListView.builder(
            padding: EdgeInsets.only(bottom: 30.0),
            itemCount: posts == null ? 0 : posts.length,
            itemBuilder: (BuildContext context, int index) {
              return RowPostWidget(posts[index]);
            }
          ))
        ],)
      ),
      CollapsingNavigationDrawer()
    ],);
  }
}