import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewRowPost.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostMobile.dart';
import 'package:frontend_web/widgets/userProfile/userProfileInsWidget.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewUserProfileMobileIns extends StatefulWidget {
  
  final int userId;
  ViewUserProfileMobileIns(this.userId);

  @override
  _ViewUserProfileMobileInsState createState() => _ViewUserProfileMobileInsState(userId);
}

class _ViewUserProfileMobileInsState extends State<ViewUserProfileMobileIns> {
  
  int userId;
  User user;
  ScrollController _scrollController;
  List<FullPost> posts;
  
  _ViewUserProfileMobileInsState(int userId1){
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

    return CenteredViewRowPost(
      child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                // User information section
                SliverToBoxAdapter(child: (user != null) ? UserInfoInsWidget(user)
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(greenPastel),
                      ),
                    ),),
              ];
            },
            body: ListView.builder(
                    padding: EdgeInsets.only(bottom: 30.0),
                    itemCount: posts == null ? 0 : posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InsRowPostMobileWidget(posts[index], 2);
                    })
      )
    );
  }
}