import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/widgets/postWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostPage extends StatefulWidget {
  final User user;
  PostPage(this.user);
  @override
  _PostPageState createState() => _PostPageState(user);
}

class _PostPageState extends State<PostPage> {
  String token = '';
  User user;
  _PostPageState(User user1) {
    this.user = user1;
  }

  List<FullPost> listPosts;
  List<FullPost> listSolvedPosts;
  List<FullPost> listUnsolvedPosts;
  _getSolvedPosts() {
    APIServices.getSolvedPosts(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listSolvedPosts = listP;
        });
      }
    });
  }

  _getUnsolvedPosts() {
    APIServices.getUnsolvedPosts(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUnsolvedPosts = listP;
        });
      }
    });
  }

  _getAllPosts() async {
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
  Future<void> _doAsync() async {
  await _getAllPosts();
  await _getSolvedPosts();
  await _getUnsolvedPosts();

}

  @override
  initState() {
    super.initState();
    _doAsync();

  }

  Widget tabs() {
    return TabBar(
        labelColor: Colors.white,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: <Widget>[
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(MdiIcons.homeSearchOutline, color: Colors.white, size: 36),
                Text(
                  'Sve objave',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.done_all, color: Colors.white, size: 36),
                Text(
                  'Rešene objave',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.close, color: Colors.white, size: 36),
                Text(
                  'Nerešene objave',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text('Upravljanje objavama',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Color(0xFF00BFA6),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                   
                  }),
              bottom: tabs(),
            ),
            body:  Stack(children: <Widget>[
            TabBarView(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 200, right: 200),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    Flexible(child: PostWidget(listPosts)),
                  ])),
              Container(
                  margin: EdgeInsets.only(left: 200, right: 200),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    Flexible(child: PostWidget(listSolvedPosts)),
                  ])),
              Container(
                  margin: EdgeInsets.only(left: 200, right: 200),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    Flexible(child: PostWidget(listUnsolvedPosts)),
                  ])),
            ]),
            CollapsingNavigationDrawer(),
            ],)));
  }
}
