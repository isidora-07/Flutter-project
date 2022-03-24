import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/filters.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/notificationPage.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:frontend/widgets/postWidget.dart';

import '../main.dart';

class FeedPage extends StatefulWidget {
  final User user;
  FeedPage(this.user);
  @override
  _FeedPageState createState() => _FeedPageState(user);
}

class _FeedPageState extends State<FeedPage> {
  User user;
  List<FullPost> listPosts;

  _FeedPageState(User user1) {
    this.user = user1;
  }

  _getPosts() async {
    if(publicUser != null){
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPostByCityId(jwt, publicUser.cityId).then((res) {
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
  }

  _getUnsolvedPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getUnsolvedPostByCityId(jwt, publicUser.cityId).then((res) {
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

    _getNicePosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getNicePostByCityId(jwt, publicUser.cityId).then((res) {
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

  _getSolvedPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    var res = await APIServices.getSolvedPostByCityId(jwt, publicUser.cityId);
    print(res.body);
    Iterable list = json.decode(res.body);
    List<FullPost> listP = List<FullPost>();
    listP = list.map((model) => FullPost.fromObject(model)).toList();
    if (mounted) {
      setState(() {
        listPosts = listP;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor,
          iconTheme: IconThemeData(
              size: 0.1,
              color: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor),
              
          title: Text(
            "MOJ GRAD",
            style: TextStyle(
              color: Color(0xFF00BFA6),
              fontSize: 22.0,
              fontStyle: FontStyle.normal,
              fontFamily: 'pirulen rg',
            ),
          ),
          actions: <Widget>[
            SizedBox(width: 16.0),
            PopupMenuButton<String>(
                onSelected: choiceAction,
                icon: Icon(Icons.filter_list, color: Theme.of(context).copyWith().iconTheme.color),
                itemBuilder: (BuildContext context) {
                  return Filteri.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                }),
            IconButton(
              icon: Icon(Icons.notifications), 
              color:Theme.of(context).copyWith().iconTheme.color,
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()));
              },
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: (listPosts != null && listPosts != [] && listPosts.length != 0)
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 30.0),
                    itemCount: listPosts == null ? 0 : listPosts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostWidget(listPosts[index]);
                    })
                : listPosts == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                    ),
                  ):
              Center(child: Text("Trenutno nema objava"),)
            )
      );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
     if(mounted){
    setState(() {
      listPosts = [];
    });
     }
    _getPosts();
    return null;
  }

  Future<Null> choiceAction(String choice) async {
     if(mounted){
    setState(() {
      listPosts = null;
    });
     }
    await new Future.delayed(new Duration(seconds: 1));
    if (choice == Filteri.reseni) {
      _getSolvedPosts();
    } else if (choice == Filteri.nereseni) {
      _getUnsolvedPosts();
    }else if(choice == Filteri.pohvale){
      _getNicePosts();
    }else if (choice == Filteri.svi) {
      _getPosts();
    }

    return null;
  }
}
