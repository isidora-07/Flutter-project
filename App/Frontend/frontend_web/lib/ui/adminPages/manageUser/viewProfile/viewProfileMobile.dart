import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewRowPost.dart';
import 'package:frontend_web/widgets/post/rowPostMobileWidget.dart';
import 'package:frontend_web/widgets/userProfile/userProfileWidget.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewUserProfileMobile extends StatefulWidget {
  
  final User user;
  ViewUserProfileMobile(this.user);

  @override
  _ViewUserProfileMobileState createState() => _ViewUserProfileMobileState(user);
}

class _ViewUserProfileMobileState extends State<ViewUserProfileMobile> {
  
  User user;
  ScrollController _scrollController;
  List<FullPost> posts;
  
  _ViewUserProfileMobileState(User user1){
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

    return CenteredViewRowPost(
      child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                // User information section
                SliverToBoxAdapter(child: UserInfoWidget(user)),
              ];
            },
            body: ListView.builder(
                    padding: EdgeInsets.only(bottom: 30.0),
                    itemCount: posts == null ? 0 : posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RowPostMobileWidget(posts[index]);
                    })
      )
    );
  }
}